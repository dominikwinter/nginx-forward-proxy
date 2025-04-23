# Simple NGINX Forward Proxy as Docker Container

This is a simple [NGINX](https://www.nginx.com/) Forward Proxy Docker Image that you can use to bypass content filters, access geo-restricted websites, and protect your privacy online.

NGINX does not support forward proxying by default, but this Docker Image uses a custom NGINX module called [ngx_http_proxy_connect_module](https://github.com/chobits/ngx_http_proxy_connect_module) to enable this functionality. The module adds support for the `HTTP CONNECT` method, which is used to establish a tunnel through the proxy to the destination server.

Furthermore, the image has been optimized for performance and security based on the suggestions provided by [UnixTeacher.org](https://www.unixteacher.org/blog/build-options-to-improve-the-performance-and-security-of-nginx/).

To get started, simply run the container on your local machine or server to get started. The NGINX configuration can be easily customized to meet your specific needs, and the container can be deployed on any platform that supports Docker containers.

For questions or issues, feel free to open an issue in this repository.

| Component | Version  |
|-----------|----------|
| alpine    | 3.21     |
| nginx     | 1.27.1   |
| zlib      | 1.3.1    |

## How to Run

To start the container, you can use one of the following methods:

Using Docker Compose:
```bash
docker-compose up -d
```

Using Docker:

```bash
docker run --rm -d -p 8080:8080 --name nginx-forward-proxy dominikbechstein/nginx-forward-proxy
# -d: Run the container in detached mode
# -p: Map port 8080 on the host to port 8080 in the container
# --name: Assign a name to the container
```

Using a Custom `nginx.conf`:
```bash
docker run --rm -d -p 8080:8080 --name nginx-forward-proxy \
  -v ${PWD}/nginx.conf:/usr/local/nginx/conf/nginx.conf \
  dominikbechstein/nginx-forward-proxy
```

This allows you to override the default NGINX configuration with your custom settings.


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

## Security Note

Running a forward proxy can expose your network to potential security risks if not configured properly. Ensure that the proxy is not accessible from the public internet without proper authentication. Consider using firewall rules, VPNs, or other access control mechanisms to restrict access to trusted clients only.

## Developer Guide

### Building the Docker Container

To build the Docker container locally, follow these steps:

1. Ensure you have Docker installed on your system. You can verify this by running:
   ```bash
   docker --version
   ```

2. Navigate to the project directory:
   ```bash
   cd /path/to/nginx-forward-proxy
   ```

3. Build the Docker image using the `docker build` command:
   ```bash
   docker build -t nginx-forward-proxy .

   # -t nginx-forward-proxy: Tags the image with the name nginx-forward-proxy
   # .: Specifies the current directory as the build context
   ```

4. Verify that the image has been built successfully:
   ```bash
   docker images | grep nginx-forward-proxy
   ```

You can now use this locally built image to run the container as described in the "How to Run" section.

## Further Links
* [NGINX](https://www.nginx.com/)
* [A forward proxy module for CONNECT request handling](https://github.com/chobits/ngx_http_proxy_connect_module)
* [Build options to improve the performance and security of Nginx](https://www.unixteacher.org/blog/build-options-to-improve-the-performance-and-security-of-nginx/)
