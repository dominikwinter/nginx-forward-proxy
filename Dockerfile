FROM alpine:3.21 AS base

# ==================================================================================================

FROM base AS builder

ENV NGINX_VERSION=1.27.1
ENV ZLIB_VERSION=1.3.1

WORKDIR /usr/local/src

RUN apk add curl git alpine-sdk openssl-dev zlib-dev pcre-dev

RUN <<EOF
  set -x

  curl -LSs https://github.com/madler/zlib/releases/download/v${ZLIB_VERSION}/zlib-${ZLIB_VERSION}.tar.gz -O
  tar xf zlib-${ZLIB_VERSION}.tar.gz

  curl -LSs http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -O
  tar xf nginx-${NGINX_VERSION}.tar.gz
  cd nginx-${NGINX_VERSION}

  git clone https://github.com/chobits/ngx_http_proxy_connect_module
  patch -p1 < ./ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_102101.patch

  ./configure \
    --add-module=./ngx_http_proxy_connect_module \
    --sbin-path=/usr/sbin/nginx \
    --with-zlib=../zlib-${ZLIB_VERSION} \
    --with-cc-opt=-static \
    --with-ld-opt=-static

  make -j $(nproc)
  make install
EOF

# ==================================================================================================

FROM base

LABEL maintainer="Dominik Bechstein <info@edge-project.org>"

COPY --from=builder /usr/local/nginx /usr/local/nginx
COPY --from=builder /usr/sbin/nginx /usr/sbin/nginx
COPY ./nginx.conf /usr/local/nginx/conf/nginx.conf

ENTRYPOINT ["/usr/sbin/nginx"]
