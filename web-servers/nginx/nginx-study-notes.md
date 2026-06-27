# NGINX From Scratch to Hero - Study Notes

## 1. What is NGINX?

NGINX, pronounced **Engine-X**, is a high-performance web server that can also work as a:

| Term                          | Definition                                                                                        |
| ----------------------------- | ---------------------------------------------------------------------------------------------------------- |
| **Web server**                | A server that delivers website files like HTML, CSS, JavaScript, and images to users.                      |
| **Reverse proxy**             | A server that receives user requests and forwards them to backend application servers.                     |
| **Load balancer**             | A server that distributes traffic across multiple backend servers to improve performance and availability. |
| **SSL/TLS termination point** | A server that handles HTTPS encryption and certificates before sending traffic to the backend.             |
| **Cache server**              | A server that stores copies of responses to serve future requests faster.                                  |
| **TCP/UDP proxy**             | A server that forwards raw TCP or UDP network traffic to another server.                                   |
| **Mail proxy**                | A server that forwards email protocol traffic like SMTP, IMAP, or POP3 to mail servers.                    |


In simple words, NGINX is a **traffic controller** for web applications.

```text
User Browser
     |
     v
   NGINX
     |
     v
Website / Application / Backend Server
```

When a user visits a website like:

```text
https://example.com
```

NGINX can:

- Serve HTML, CSS, JavaScript, images, and other static files
- Forward the request to a backend application
- Balance traffic across multiple servers
- Handle HTTPS certificates
- Cache content
- Protect backend applications

---

## 2. Why Do We Need NGINX?

Without NGINX:

```text
User ---> Application directly
```

Problems:

- Application server is exposed directly
- SSL/HTTPS setup becomes harder
- No load balancing
- No caching
- Harder to secure
- Harder to scale

With NGINX:

```text
User ---> NGINX ---> Application
```

Benefits:

- Better security
- Better performance
- Reverse proxy support
- SSL termination
- Load balancing
- Static file serving
- Production-ready setup

---

## 3. Common Roles of NGINX

### 3.1 NGINX as a Web Server

NGINX can serve static files such as:

- HTML
- CSS
- JavaScript
- Images
- Videos
- Downloads

Example:

```text
User visits website
NGINX sends index.html
```

---

### 3.2 NGINX as a Reverse Proxy

This is one of the most important uses in DevOps.

```text
User ---> NGINX ---> Node.js / Python / Java / Docker App
```

Example:

Your app is running on:

```text
localhost:3000
```

But users should access it using:

```text
https://myapp.com
```

NGINX receives the request on port `80` or `443` and forwards it to port `3000`.

---

### 3.3 NGINX as a Load Balancer

NGINX can distribute traffic across multiple backend servers.

```text
              ---> App Server 1
User -> NGINX ---> App Server 2
              ---> App Server 3
```

This improves:

- Performance
- Availability
- Scalability
- Fault tolerance

---

### 3.4 NGINX for SSL Termination

NGINX can handle HTTPS certificates.

```text
User HTTPS ---> NGINX ---> Backend HTTP
```

This means:

- NGINX handles encryption
- Backend app can run on normal HTTP internally
- Certificate management becomes easier

---

### 3.5 NGINX as a Cache Server

NGINX can cache responses so the backend does not need to process the same request again and again.

Benefits:

- Faster response
- Less backend load
- Better performance
- Better user experience

---

## 4. Real-Life Example

Suppose you have a Node.js app running on:

```text
localhost:3000
```

Without NGINX:

```text
User ---> localhost:3000
```

This is not a good production setup.

With NGINX:

```text
User ---> example.com ---> NGINX ---> localhost:3000
```

The user never sees port `3000`.

---

## 5. Install NGINX on Ubuntu

Update package list:

```bash
sudo apt update
```

Install NGINX:

```bash
sudo apt install nginx -y
```

Check status:

```bash
sudo systemctl status nginx
```

Start NGINX:

```bash
sudo systemctl start nginx
```

Enable NGINX on boot:

```bash
sudo systemctl enable nginx
```

Restart NGINX:

```bash
sudo systemctl restart nginx
```

Reload NGINX safely after config change:

```bash
sudo systemctl reload nginx
```

Check version:

```bash
nginx -v
```

Test configuration:

```bash
sudo nginx -t
```

Important note:

> Always run `sudo nginx -t` before restarting or reloading NGINX.

---

## 6. Important NGINX Files and Directories

Ubuntu/Debian structure:

```text
/etc/nginx/
```

Main configuration file:

```text
/etc/nginx/nginx.conf
```

Available website configurations:

```text
/etc/nginx/sites-available/
```

Enabled website configurations:

```text
/etc/nginx/sites-enabled/
```

Default web root:

```text
/var/www/html/
```

Log files:

```text
/var/log/nginx/access.log
/var/log/nginx/error.log
```

---

## 7. Basic NGINX Configuration Structure

NGINX config uses blocks.

```nginx
http {
    server {
        location / {

        }
    }
}
```

Simple explanation:

| Block | Meaning |
|---|---|
| `http` | Web traffic settings |
| `server` | One website or domain |
| `location` | URL path rules |

Example:

```nginx
server {
    listen 80;
    server_name example.com;

    location / {
        root /var/www/html;
        index index.html;
    }
}
```

Explanation:

| Directive | Meaning |
|---|---|
| `listen 80;` | Accept HTTP traffic |
| `server_name example.com;` | Domain name |
| `location /` | Homepage and all paths |
| `root /var/www/html;` | Website files location |
| `index index.html;` | Default page |

---

## 8. Serve a Static Website

Create website folder:

```bash
sudo mkdir -p /var/www/mywebsite
```

Create index file:

```bash
echo "<h1>Hello from NGINX</h1>" | sudo tee /var/www/mywebsite/index.html
```

Create config file:

```bash
sudo nano /etc/nginx/sites-available/mywebsite
```

Add this config:

```nginx
server {
    listen 80;
    server_name mywebsite.com;

    root /var/www/mywebsite;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

Enable the site:

```bash
sudo ln -s /etc/nginx/sites-available/mywebsite /etc/nginx/sites-enabled/
```

Test config:

```bash
sudo nginx -t
```

Reload NGINX:

```bash
sudo systemctl reload nginx
```

---

## 9. What is `try_files`?

```nginx
try_files $uri $uri/ =404;
```

Meaning:

1. First check the exact file
2. Then check the directory
3. If not found, return `404 Not Found`

Example request:

```text
/about.html
```

NGINX checks:

```text
/var/www/mywebsite/about.html
```

If the file exists, NGINX serves it.

If not, NGINX returns:

```text
404 Not Found
```

---

## 10. NGINX as a Reverse Proxy

Suppose backend app is running on:

```text
localhost:3000
```

Basic reverse proxy config:

```nginx
server {
    listen 80;
    server_name app.example.com;

    location / {
        proxy_pass http://localhost:3000;
    }
}
```

Flow:

```text
User ---> app.example.com ---> NGINX ---> localhost:3000
```

Better reverse proxy config:

```nginx
server {
    listen 80;
    server_name app.example.com;

    location / {
        proxy_pass http://localhost:3000;

        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Explanation:

| Directive | Meaning |
|---|---|
| `proxy_pass` | Forward request to backend |
| `proxy_http_version 1.1` | Use HTTP/1.1 for proxying |
| `proxy_set_header Host $host` | Pass original domain |
| `X-Real-IP` | Pass real user IP |
| `X-Forwarded-For` | Pass client/proxy chain |
| `X-Forwarded-Proto` | Pass HTTP or HTTPS info |

---

## 11. NGINX Load Balancing

Example backend servers:

```text
App1 = 10.0.0.11:3000
App2 = 10.0.0.12:3000
App3 = 10.0.0.13:3000
```

NGINX config:

```nginx
upstream backend_servers {
    server 10.0.0.11:3000;
    server 10.0.0.12:3000;
    server 10.0.0.13:3000;
}

server {
    listen 80;
    server_name app.example.com;

    location / {
        proxy_pass http://backend_servers;
    }
}
```

Flow:

```text
User 1 ---> App1
User 2 ---> App2
User 3 ---> App3
User 4 ---> App1
```

By default, NGINX uses round-robin load balancing.

---

## 12. Load Balancing Methods

### 12.1 Round Robin

Default method.

```nginx
upstream backend {
    server app1:3000;
    server app2:3000;
}
```

Traffic goes one by one to each server.

---

### 12.2 Least Connections

Sends request to the server with fewer active connections.

```nginx
upstream backend {
    least_conn;
    server app1:3000;
    server app2:3000;
}
```

Useful when requests take different amounts of time.

---

### 12.3 IP Hash

Same user IP goes to the same backend server.

```nginx
upstream backend {
    ip_hash;
    server app1:3000;
    server app2:3000;
}
```

Useful for session-based applications.

---

## 13. NGINX with SSL/HTTPS

Usually we use Let's Encrypt Certbot.

Install Certbot:

```bash
sudo apt install certbot python3-certbot-nginx -y
```

Run Certbot:

```bash
sudo certbot --nginx -d example.com -d www.example.com
```

After SSL setup:

```text
http://example.com
```

Redirects to:

```text
https://example.com
```

Example SSL server block:

```nginx
server {
    listen 443 ssl;
    server_name example.com;

    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

    location / {
        root /var/www/html;
        index index.html;
    }
}
```

---

## 14. HTTP to HTTPS Redirect

```nginx
server {
    listen 80;
    server_name example.com www.example.com;

    return 301 https://$host$request_uri;
}
```

Meaning:

```text
All HTTP traffic permanently redirects to HTTPS.
```

---

## 15. NGINX Logs

Access log:

```bash
sudo tail -f /var/log/nginx/access.log
```

The access log shows successful and attempted requests.

Error log:

```bash
sudo tail -f /var/log/nginx/error.log
```

The error log shows problems such as:

- Permission denied
- File not found
- Backend connection failed
- Bad gateway
- Config issue

---

## 16. Common NGINX Errors and Fixes

### 16.1 403 Forbidden

Possible reasons:

- Wrong file permissions
- Missing `index.html`
- NGINX cannot access directory
- Wrong root path

Check:

```bash
ls -ld /var/www/mywebsite
ls -l /var/www/mywebsite
```

Fix example:

```bash
sudo chmod -R 755 /var/www/mywebsite
```

---

### 16.2 404 Not Found

Possible reasons:

- File does not exist
- Wrong root path
- Wrong location block
- Wrong server block

Check full active config:

```bash
sudo nginx -T
```

---

### 16.3 502 Bad Gateway

Meaning:

```text
NGINX is working, but backend app is not responding.
```

Possible reasons:

- Backend app is down
- Wrong backend port
- Wrong `proxy_pass`
- Firewall issue
- Timeout issue

Check backend:

```bash
curl localhost:3000
```

Check app status:

```bash
sudo systemctl status myapp
```

Check NGINX error log:

```bash
sudo tail -f /var/log/nginx/error.log
```

---

### 16.4 413 Request Entity Too Large

Meaning:

```text
The uploaded file is larger than NGINX allows.
```

Fix:

```nginx
server {
    client_max_body_size 50M;
}
```

Test and reload:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

---

## 17. NGINX with Docker

Run NGINX container:

```bash
docker run -d --name my-nginx -p 8080:80 nginx:alpine
```

Open in browser:

```text
http://localhost:8080
```

Mount custom website:

```bash
docker run -d \
  --name my-nginx \
  -p 8080:80 \
  -v $(pwd)/html:/usr/share/nginx/html:ro \
  nginx:alpine
```

Folder structure:

```text
project/
├── html/
│   └── index.html
```

---

## 18. NGINX Docker Compose Example

```yaml
services:
  nginx:
    image: nginx:alpine
    container_name: nginx-web
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html:ro
```

Run:

```bash
docker compose up -d
```

Check:

```bash
docker ps
```

Stop:

```bash
docker compose down
```

---

## 19. NGINX as Reverse Proxy for Docker App

Example `docker-compose.yml`:

```yaml
services:
  app:
    image: myapp:latest
    expose:
      - "3000"

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./default.conf:/etc/nginx/conf.d/default.conf:ro
```

Example `default.conf`:

```nginx
server {
    listen 80;

    location / {
        proxy_pass http://app:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

Important point:

Inside Docker Compose, NGINX can reach the app by service name:

```text
http://app:3000
```

---

## 20. NGINX in Kubernetes

In Kubernetes, NGINX is commonly used as an Ingress Controller.

Without Ingress:

```text
Service 1 needs LoadBalancer
Service 2 needs LoadBalancer
Service 3 needs LoadBalancer
```

With Ingress:

```text
Internet
   |
NGINX Ingress Controller
   |
Routes traffic to services
```

Example routing:

```text
app.example.com      ---> frontend-service
api.example.com      ---> backend-service
admin.example.com    ---> admin-service
```

---

## 21. Important NGINX Commands

| Command | Purpose |
|---|---|
| `sudo nginx -t` | Test NGINX config |
| `sudo systemctl reload nginx` | Reload without stopping service |
| `sudo systemctl restart nginx` | Restart NGINX service |
| `sudo nginx -T` | Show full active config |
| `sudo tail -f /var/log/nginx/access.log` | Watch access logs |
| `sudo tail -f /var/log/nginx/error.log` | Watch error logs |
| `curl -I http://localhost` | Check response headers |
| `ss -tulnp | grep nginx` | Check listening ports |

---

## 22. NGINX Request Flow

```text
User enters domain in browser
        |
        v
DNS resolves domain to server IP
        |
        v
Request reaches server on port 80/443
        |
        v
NGINX receives request
        |
        v
NGINX checks server_name
        |
        v
NGINX checks location block
        |
        v
NGINX serves file or proxies to backend
        |
        v
User gets response
```

---

## 23. Important Ports

| Port | Meaning |
|---:|---|
| 80 | HTTP |
| 443 | HTTPS |
| 3000 | Common Node.js app port |
| 5000 | Common Flask app port |
| 8080 | Common alternative web port |

---

## 24. Beginner to Hero Roadmap

### Level 1: Beginner

Learn:

- What is NGINX?
- Install NGINX
- Start, stop, restart, reload
- Serve static website
- Understand `root` and `index`
- Read logs

Practice:

```bash
sudo apt install nginx -y
sudo systemctl status nginx
curl localhost
```

---

### Level 2: Junior Linux Admin

Learn:

- `server` block
- `location` block
- `sites-available`
- `sites-enabled`
- Custom domain
- Permissions
- Logs

Practice:

```text
Host two websites on one server:
example1.com
example2.com
```

---

### Level 3: DevOps Level

Learn:

- Reverse proxy
- Backend app proxy
- Docker with NGINX
- Environment-based configs
- CI/CD deployment

Practice:

```text
Run app on port 3000
Expose it using NGINX on port 80
```

---

### Level 4: Production Level

Learn:

- SSL
- HTTP to HTTPS redirect
- Load balancing
- Caching
- Security headers
- Rate limiting
- Gzip compression

Practice:

```text
Deploy real domain with HTTPS
Add backend load balancing
Add upload size limit
Add log monitoring
```

---

### Level 5: Hero Level

Learn:

- NGINX Ingress Controller
- Blue-green deployment
- Canary routing
- Advanced caching
- Zero-downtime reload
- Performance tuning
- Troubleshooting 502, 504, 403, and 404 errors

---

## 25. Interview Questions

### Q1. What is NGINX?

NGINX is a high-performance web server that can also work as a reverse proxy, load balancer, cache server, and SSL termination point.

---

### Q2. What is a reverse proxy?

A reverse proxy receives client requests and forwards them to backend servers.

```text
Client ---> NGINX ---> Backend App
```

---

### Q3. What is load balancing?

Load balancing distributes traffic across multiple servers to improve availability, performance, and scalability.

---

### Q4. What is SSL termination?

SSL termination means NGINX handles HTTPS encryption and forwards traffic to backend servers.

---

### Q5. What is the difference between restart and reload?

```text
restart = stop and start NGINX
reload  = apply config changes without full stop
```

In production, use reload when possible.

---

### Q6. What causes 502 Bad Gateway?

Common reasons:

- Backend app is down
- Wrong backend port
- Wrong `proxy_pass`
- Firewall issue
- Timeout issue

---

### Q7. What is `nginx -t`?

`nginx -t` tests NGINX configuration syntax before reload or restart.

---

## 26. Final Summary

NGINX is used to control web traffic.

It can work as:

- Web server
- Reverse proxy
- Load balancer
- SSL handler
- Cache server
- Docker/Kubernetes traffic router

Most important flow:

```text
User ---> NGINX ---> Application
```

Most important commands:

```bash
sudo nginx -t
sudo systemctl reload nginx
sudo tail -f /var/log/nginx/error.log
```

Most important reverse proxy config:

```nginx
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://localhost:3000;
    }
}
```

For DevOps and Linux System Admin roles, NGINX is a must-practice skill.

Focus on:

- Static hosting
- Reverse proxy
- SSL
- Load balancing
- Logs
- Troubleshooting
- Docker usage
- Kubernetes Ingress

---

## 27. Quick Revision Table

| Topic | Key Point |
|---|---|
| Web Server | Serves static files |
| Reverse Proxy | Forwards traffic to backend apps |
| Load Balancer | Distributes traffic across servers |
| SSL Termination | Handles HTTPS certificates |
| Cache | Stores responses for faster delivery |
| `nginx -t` | Tests config syntax |
| `reload` | Applies changes safely |
| `access.log` | Shows incoming requests |
| `error.log` | Shows problems and failures |
| 502 Error | Backend app issue |
| 403 Error | Permission or index issue |
| 404 Error | File/path/location issue |

