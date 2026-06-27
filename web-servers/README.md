# Apache and NGINX Web Servers

This repository contains study notes and practice material for two of the most important web servers used in Linux System Administration, DevOps, Cloud, Docker, and production web hosting:

```text
Apache HTTP Server
NGINX
```

Both Apache and NGINX can serve websites, handle HTTP/HTTPS traffic, work with domains, and support production web application deployments.

---

## What is a Web Server?

A **web server** receives requests from users' browsers and sends back website content such as:

```text
HTML
CSS
JavaScript
Images
Videos
Application responses
```

Basic flow:

```text
User Browser
     |
     v
 Web Server
     |
     v
 Website Files / Backend Application
```

---

## What is Apache?

**Apache HTTP Server** is an open-source web server used to host websites and web applications over HTTP and HTTPS.

Apache is commonly used for:

```text
Static websites
PHP applications
LAMP stack
WordPress
Virtual hosts
.htaccess rules
Authentication
Reverse proxy
SSL/HTTPS
```

Simple Apache flow:

```text
User ---> Apache ---> Website Files / PHP App
```

---

## What is NGINX?

**NGINX** is a high-performance web server that can also work as a reverse proxy, load balancer, cache server, and SSL/TLS termination point.

NGINX is commonly used for:

```text
Static websites
Reverse proxy
Load balancing
SSL/TLS termination
Caching
Docker applications
Kubernetes Ingress
High-traffic websites
```

Simple NGINX flow:

```text
User ---> NGINX ---> Website / Backend App
```

---

## Apache vs NGINX

| Feature | Apache | NGINX |
|---|---|---|
| Web server | Yes | Yes |
| Reverse proxy | Yes | Yes |
| Load balancer | Yes | Yes |
| SSL/HTTPS support | Yes | Yes |
| Static file serving | Good | Excellent |
| PHP support | Very common with mod_php or PHP-FPM | Common with PHP-FPM |
| `.htaccess` support | Yes | No |
| Configuration style | Flexible, directory-based | Centralized, server-block based |
| Common use case | LAMP stack, PHP apps, WordPress | Reverse proxy, high traffic, containers |
| Multiple websites | Virtual Hosts | Server Blocks |
| Config test command | `apache2ctl configtest` | `nginx -t` |

---

## Common Ports

| Port | Purpose |
|---:|---|
| 80 | HTTP |
| 443 | HTTPS |
| 8080 | Alternative HTTP port |
| 3000 | Common Node.js app port |
| 5000 | Common Flask app port |

---

## Install Apache

### Ubuntu/Debian

```bash
sudo apt update
sudo apt install apache2 -y
```

Check status:

```bash
sudo systemctl status apache2
```

Start Apache:

```bash
sudo systemctl start apache2
```

Enable on boot:

```bash
sudo systemctl enable apache2
```

Test config:

```bash
sudo apache2ctl configtest
```

Reload Apache:

```bash
sudo systemctl reload apache2
```

---

## Install NGINX

### Ubuntu/Debian

```bash
sudo apt update
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

Enable on boot:

```bash
sudo systemctl enable nginx
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

## Important Apache Files and Directories

### Ubuntu/Debian

| Path | Purpose |
|---|---|
| `/etc/apache2/apache2.conf` | Main Apache configuration file |
| `/etc/apache2/ports.conf` | Apache port configuration |
| `/etc/apache2/sites-available/` | Available virtual host files |
| `/etc/apache2/sites-enabled/` | Enabled virtual host files |
| `/etc/apache2/mods-available/` | Available Apache modules |
| `/etc/apache2/mods-enabled/` | Enabled Apache modules |
| `/var/www/html/` | Default web root |
| `/var/log/apache2/access.log` | Access log |
| `/var/log/apache2/error.log` | Error log |

---

## Important NGINX Files and Directories

### Ubuntu/Debian

| Path | Purpose |
|---|---|
| `/etc/nginx/nginx.conf` | Main NGINX configuration file |
| `/etc/nginx/sites-available/` | Available server block files |
| `/etc/nginx/sites-enabled/` | Enabled server block files |
| `/var/www/html/` | Default web root |
| `/var/log/nginx/access.log` | Access log |
| `/var/log/nginx/error.log` | Error log |

---

## Apache Virtual Host Example

Apache uses **Virtual Hosts** to run multiple websites on one server.

Example:

```text
site1.com ---> /var/www/site1
site2.com ---> /var/www/site2
```

Apache virtual host:

```apache
<VirtualHost *:80>
    ServerName site1.com
    ServerAlias www.site1.com
    DocumentRoot /var/www/site1

    <Directory /var/www/site1>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/site1-error.log
    CustomLog ${APACHE_LOG_DIR}/site1-access.log combined
</VirtualHost>
```

Enable site:

```bash
sudo a2ensite site1.com.conf
sudo apache2ctl configtest
sudo systemctl reload apache2
```

---

## NGINX Server Block Example

NGINX uses **Server Blocks** to run multiple websites on one server.

Example:

```text
site1.com ---> /var/www/site1
site2.com ---> /var/www/site2
```

NGINX server block:

```nginx
server {
    listen 80;
    server_name site1.com www.site1.com;

    root /var/www/site1;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    access_log /var/log/nginx/site1-access.log;
    error_log /var/log/nginx/site1-error.log;
}
```

Enable site:

```bash
sudo ln -s /etc/nginx/sites-available/site1.com /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

---

## Launch Multiple Websites

### DNS Requirement

Each domain must point to the server IP.

Example:

```text
site1.com A record ---> server-ip
site2.com A record ---> server-ip
```

### Apache

```text
site1.com ---> VirtualHost ---> /var/www/site1
site2.com ---> VirtualHost ---> /var/www/site2
```

### NGINX

```text
site1.com ---> server_name ---> /var/www/site1
site2.com ---> server_name ---> /var/www/site2
```

---

## Running Apache and NGINX Together

Apache and NGINX cannot both listen on port `80` on the same IP at the same time.

Bad setup:

```text
Apache ---> port 80
NGINX  ---> port 80
```

Good setup:

```text
User
 |
 v
NGINX on port 80/443
 |
 v
Apache on port 8080
```

In this setup:

```text
NGINX = public reverse proxy
Apache = backend web server
```

NGINX reverse proxy example:

```nginx
server {
    listen 80;
    server_name site1.com www.site1.com;

    location / {
        proxy_pass http://127.0.0.1:8080;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

---

## SSL/HTTPS with Certbot

### NGINX SSL

```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d site1.com -d www.site1.com
```

### Apache SSL

```bash
sudo apt install certbot python3-certbot-apache -y
sudo certbot --apache -d site1.com -d www.site1.com
```

Test renewal:

```bash
sudo certbot renew --dry-run
```

---

## Reverse Proxy Concept

Reverse proxy means the web server receives user traffic and forwards it to a backend application.

Example:

```text
User ---> NGINX/Apache ---> Backend App on port 3000
```

Common backend applications:

```text
Node.js
Python Flask
Django
Java Spring Boot
Docker containers
```

---

## Load Balancing Concept

Load balancing distributes traffic across multiple backend servers.

Example:

```text
              ---> App Server 1
User -> Proxy ---> App Server 2
              ---> App Server 3
```

NGINX load balancing example:

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

---

## Important Commands

### Apache Commands

```bash
sudo systemctl status apache2
sudo systemctl start apache2
sudo systemctl stop apache2
sudo systemctl restart apache2
sudo systemctl reload apache2
sudo apache2ctl configtest
sudo apache2ctl -S
apache2ctl -M
```

### NGINX Commands

```bash
sudo systemctl status nginx
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx
sudo systemctl reload nginx
sudo nginx -t
sudo nginx -T
```

---

## Logs

### Apache Logs

```bash
sudo tail -f /var/log/apache2/access.log
sudo tail -f /var/log/apache2/error.log
```

### NGINX Logs

```bash
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

---

## Common Errors and Troubleshooting

| Error | Meaning | Common Fix |
|---|---|---|
| 403 Forbidden | Access denied | Check permissions and access rules |
| 404 Not Found | File or route not found | Check root/DocumentRoot and file path |
| 500 Internal Server Error | Server-side issue | Check app, PHP, `.htaccess`, and logs |
| 502 Bad Gateway | Backend app not responding | Check backend service and proxy config |
| Port already in use | Two services using same port | Check `ss -tulnp` and change ports |

Check listening ports:

```bash
sudo ss -tulnp | grep ':80'
sudo ss -tulnp | grep ':443'
sudo ss -tulnp | grep ':8080'
```

---

## Recommended Learning Roadmap

### Level 1: Beginner

Learn:

```text
What is a web server?
Install Apache
Install NGINX
Start, stop, restart, reload services
Serve a simple HTML page
```

### Level 2: Junior Admin

Learn:

```text
Apache Virtual Hosts
NGINX Server Blocks
DocumentRoot and root
Logs
Permissions
Config testing
```

### Level 3: DevOps Level

Learn:

```text
Reverse proxy
SSL with Certbot
Multiple domains
Docker with Apache and NGINX
Backend app proxying
```

### Level 4: Production Level

Learn:

```text
Load balancing
Caching
Security headers
Rate limiting
Performance tuning
Monitoring logs
Troubleshooting 403, 404, 500, 502
```

---

## Suggested Repository Structure

```text
webservers-apache-nginx/
├── README.md
├── apache/
│   ├── apache-from-scratch-to-hero-study-notes.md
│   └── apache-25-mcqs.html
├── nginx/
│   ├── nginx-from-scratch-to-hero-study-notes.md
│   └── nginx-25-mcqs.html
└── multiple-websites/
    └── multiple-websites-nginx-apache-study-notes.md
```

---

## Interview Focus Areas

For Linux Admin and DevOps interviews, focus on:

```text
Apache vs NGINX difference
Virtual Hosts
Server Blocks
DocumentRoot vs root
Reverse proxy
SSL termination
Load balancing
403/404/500/502 errors
Logs
Permissions
Port conflicts
Running Apache and NGINX together
```

---

## Final Summary

Apache and NGINX are two major web servers used in production.

Apache is very common for:

```text
LAMP stack
PHP applications
WordPress
.htaccess
Virtual Hosts
```

NGINX is very common for:

```text
Reverse proxy
Load balancing
High traffic websites
Static content
Docker and Kubernetes
SSL termination
```

Main idea:

```text
User ---> Apache or NGINX ---> Website / Backend Application
```

Both are very important for Linux System Administration, DevOps, Cloud, and real production troubleshooting.
