FROM alpine:3.17.3 as base

RUN apk add pcre-dev

# ==================================================================================================

FROM base as builder

ENV NGINX_VERSION 1.23.4

WORKDIR /tmp

RUN apk add alpine-sdk openssl-dev zlib-dev

RUN \
  set -x; \
  curl -LSs http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -O; \
  tar xf nginx-${NGINX_VERSION}.tar.gz; \
  cd nginx-${NGINX_VERSION}; \
  \
  git clone https://github.com/chobits/ngx_http_proxy_connect_module; \
  patch -p1 < ./ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_102101.patch; \
  \
  ./configure \
    --add-module=./ngx_http_proxy_connect_module \
    --sbin-path=/usr/sbin/nginx \
    --with-http_ssl_module \
    --with-cc-opt='-O2 -march=westmere -flto -funsafe-math-optimizations -fstack-protector-strong --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2'; \
  make -j $(nproc); \
  make install;

# ==================================================================================================

FROM base

LABEL maintainer "Dominik Winter <dominik.winter@klarna.com>"

COPY --from=builder /usr/local/nginx /usr/local/nginx
COPY --from=builder /usr/sbin/nginx /usr/sbin/nginx
COPY ./nginx.conf /usr/local/nginx/conf/nginx.conf

CMD ["/bin/sh", "-c", "nginx -V; nginx -t; nginx"]
