# Simple NGINX Forward Proxy as Docker Container

This is a simple [NGINX](https://www.nginx.com/) Forward Proxy Docker Image that you can use to bypass content filters, access geo-restricted websites, and protect your privacy online.

NGINX does not support forward proxying by default, but this Docker Image uses a custom NGINX module called [ngx_http_proxy_connect_module](https://github.com/chobits/ngx_http_proxy_connect_module) to enable this functionality. The module adds support for the `HTTP CONNECT` method, which is used to establish a tunnel through the proxy to the destination server.

Furthermore the image has been optimized for performance and security based on the suggestions provided by [UnixTeacher.org](https://www.unixteacher.org/blog/build-options-to-improve-the-performance-and-security-of-nginx/).

All you need to do is run the container on your local machine or server to get started. The NGINX configuration can be easily customized to meet your specific needs, and the container can be deployed on any platform that supports Docker containers.

If you have any questions or issues, please don't hesitate to open an issue on this repository.

## Run

To start the container you can simple use docker-compose.

```bash
docker-compose up -d
```

Or natively with docker.

```bash
docker run -d -p 8080:8080 --name nginx-forward-proxy dominikbechstein/nginx-forward-proxy
```

Or with custom `nginx.conf`.
```bash
docker run -d -p 8080:8080 --name nginx-forward-proxy -v ${PWD}/nginx.conf:/usr/local/nginx/conf/nginx.conf dominikbechstein/nginx-forward-proxy
```

## Useful Snippets

Get your local IP address.
```bash
ifconfig | grep broadcast | cut -d' ' -f2
```

# Client Configuration

Suppose you run the container on your local machine with IP address: `192.168.2.192`.

# curl

```bash
curl -x http://192.168.2.192:8080 -ik --proxy-insecure https://www.google.de/
```

# iOS
Wi-Fi settings -> your Wi-Fi -> at the bottom Configure Proxy -> Manual -> set server and port -> don't forget to save


<img src="https://raw.githubusercontent.com/dominikwinter/nginx-forward-proxy/master/assets/nginx-forward-proxy-client-configuration-1.jpg" width="140" height="303" /> <img src="https://raw.githubusercontent.com/dominikwinter/nginx-forward-proxy/master/assets/nginx-forward-proxy-client-configuration-2.jpg" width="140" height="303" /> <img src="https://raw.githubusercontent.com/dominikwinter/nginx-forward-proxy/master/assets/nginx-forward-proxy-client-configuration-3.jpg" width="140" height="303" /> <img src="https://raw.githubusercontent.com/dominikwinter/nginx-forward-proxy/master/assets/nginx-forward-proxy-client-configuration-4.jpg" width="140" height="303" /> <img src="https://raw.githubusercontent.com/dominikwinter/nginx-forward-proxy/master/assets/nginx-forward-proxy-client-configuration-5.jpg" width="140" height="303" />


## Further Links
* [NGINX](https://www.nginx.com/)
* [A forward proxy module for CONNECT request handling](https://github.com/chobits/ngx_http_proxy_connect_module)
* [Build options to improve the performance and security of Nginx](https://www.unixteacher.org/blog/build-options-to-improve-the-performance-and-security-of-nginx/)
