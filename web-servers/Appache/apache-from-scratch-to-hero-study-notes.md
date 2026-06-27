# Apache — Study Notes

## 1. What is Apache?

**Apache HTTP Server**, commonly called **Apache**, is an open-source web server used to host websites and web applications.

Simple flow:

```text
User Browser
     |
     v
 Apache Web Server
     |
     v
 Website Files / Application
```

Example:

```text
User visits: http://example.com
Apache returns: index.html
```

---

## 2. Why Do We Need Apache?

Apache helps with:

```text
Hosting websites
Serving static files
Running PHP applications
Reverse proxying to backend apps
Managing multiple domains
Handling SSL/HTTPS
Authentication and access control
Logging requests and errors
```

Without a web server, users cannot properly access your website from the internet.

---

## 3. Apache vs NGINX

| Apache | NGINX |
|---|---|
| Older and widely used web server | Modern high-performance web server |
| Great with `.htaccess` | Does not use `.htaccess` |
| Common with PHP/LAMP stack | Common as reverse proxy/load balancer |
| Process/thread based architecture | Event-driven architecture |
| Easy per-directory configuration | Centralized config style |

Simple idea:

```text
Apache = flexible web server
NGINX = fast traffic controller/reverse proxy
```

---

## 4. Common Roles of Apache

### 4.1 Web Server

Apache serves website files such as:

```text
HTML
CSS
JavaScript
Images
PDFs
Downloads
```

Flow:

```text
User ---> Apache ---> /var/www/html/index.html
```

### 4.2 PHP Application Server with LAMP

Apache is commonly used in the **LAMP stack**:

```text
Linux
Apache
MySQL/MariaDB
PHP
```

Common apps:

```text
WordPress
phpMyAdmin
Laravel
Drupal
Joomla
```

### 4.3 Reverse Proxy

Apache can forward requests to backend applications.

```text
User ---> Apache ---> Node.js / Python / Java App
```

Example:

```text
Apache listens on port 80
Backend app runs on port 3000
```

### 4.4 SSL/HTTPS Handler

Apache can handle HTTPS certificates.

```text
User HTTPS ---> Apache ---> Website/App
```

### 4.5 Virtual Host Server

Apache can host multiple websites on one server.

```text
example.com       ---> /var/www/example
app.example.com   ---> /var/www/app
blog.example.com  ---> /var/www/blog
```

---

## 5. Install Apache on Ubuntu/Debian

Package name:

```bash
apache2
```

Install:

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

Restart:

```bash
sudo systemctl restart apache2
```

Reload safely after config changes:

```bash
sudo systemctl reload apache2
```

Check version:

```bash
apache2 -v
```

Test configuration:

```bash
sudo apache2ctl configtest
```

or:

```bash
sudo apachectl configtest
```

Expected output:

```text
Syntax OK
```

---

## 6. Install Apache on RHEL/CentOS/Rocky/AlmaLinux

Package name:

```bash
httpd
```

Install:

```bash
sudo dnf install httpd -y
```

Start:

```bash
sudo systemctl start httpd
```

Enable:

```bash
sudo systemctl enable httpd
```

Check status:

```bash
sudo systemctl status httpd
```

Test config:

```bash
sudo apachectl configtest
```

Allow HTTP/HTTPS in firewall:

```bash
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

---

## 7. Important Apache Files and Directories

### Ubuntu/Debian

| Path | Purpose |
|---|---|
| `/etc/apache2/` | Main Apache configuration directory |
| `/etc/apache2/apache2.conf` | Main Apache config file |
| `/etc/apache2/ports.conf` | Port configuration |
| `/etc/apache2/sites-available/` | Available site configs |
| `/etc/apache2/sites-enabled/` | Enabled site configs |
| `/etc/apache2/mods-available/` | Available modules |
| `/etc/apache2/mods-enabled/` | Enabled modules |
| `/var/www/html/` | Default web root |
| `/var/log/apache2/access.log` | Access log |
| `/var/log/apache2/error.log` | Error log |

### RHEL/CentOS/Rocky/AlmaLinux

| Path | Purpose |
|---|---|
| `/etc/httpd/conf/httpd.conf` | Main Apache config file |
| `/etc/httpd/conf.d/` | Extra config directory |
| `/var/www/html/` | Default web root |
| `/var/log/httpd/access_log` | Access log |
| `/var/log/httpd/error_log` | Error log |

---

## 8. Apache Basic Request Flow

```text
User enters domain in browser
        |
        v
DNS resolves domain to server IP
        |
        v
Request reaches server on port 80 or 443
        |
        v
Apache receives request
        |
        v
Apache checks VirtualHost
        |
        v
Apache checks DocumentRoot
        |
        v
Apache serves file or forwards to backend
        |
        v
User receives response
```

---

## 9. Apache Basic Configuration Example

```apache
<VirtualHost *:80>
    ServerName example.com
    DocumentRoot /var/www/example

    <Directory /var/www/example>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/example-error.log
    CustomLog ${APACHE_LOG_DIR}/example-access.log combined
</VirtualHost>
```

### Explanation

| Directive | Meaning |
|---|---|
| `<VirtualHost *:80>` | Website listens on port 80 |
| `ServerName` | Domain name |
| `DocumentRoot` | Website files location |
| `<Directory>` | Permission rules for that folder |
| `AllowOverride All` | Allows `.htaccess` rules |
| `Require all granted` | Allows access |
| `ErrorLog` | Error log file |
| `CustomLog` | Access log file |

---

## 10. Serve a Static Website on Ubuntu

Create website directory:

```bash
sudo mkdir -p /var/www/mywebsite
```

Create index file:

```bash
echo "<h1>Hello from Apache</h1>" | sudo tee /var/www/mywebsite/index.html
```

Set permissions:

```bash
sudo chown -R www-data:www-data /var/www/mywebsite
sudo chmod -R 755 /var/www/mywebsite
```

Create virtual host:

```bash
sudo nano /etc/apache2/sites-available/mywebsite.conf
```

Add:

```apache
<VirtualHost *:80>
    ServerName mywebsite.com
    DocumentRoot /var/www/mywebsite

    <Directory /var/www/mywebsite>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/mywebsite-error.log
    CustomLog ${APACHE_LOG_DIR}/mywebsite-access.log combined
</VirtualHost>
```

Enable site:

```bash
sudo a2ensite mywebsite.conf
```

Disable default site:

```bash
sudo a2dissite 000-default.conf
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

## 11. What is a Virtual Host?

A **Virtual Host** allows Apache to host multiple websites on the same server.

Example:

```text
One server IP: 192.168.1.10
```

Apache can host:

```text
site1.com
site2.com
site3.com
```

Each website can have a different folder:

```text
site1.com ---> /var/www/site1
site2.com ---> /var/www/site2
site3.com ---> /var/www/site3
```

Example:

```apache
<VirtualHost *:80>
    ServerName site1.com
    DocumentRoot /var/www/site1
</VirtualHost>

<VirtualHost *:80>
    ServerName site2.com
    DocumentRoot /var/www/site2
</VirtualHost>
```

---

## 12. What is DocumentRoot?

`DocumentRoot` is the folder where Apache looks for website files.

Example:

```apache
DocumentRoot /var/www/html
```

If user visits:

```text
http://example.com/about.html
```

Apache checks:

```text
/var/www/html/about.html
```

---

## 13. What is a Directory Block?

A `<Directory>` block controls permissions for a folder.

Example:

```apache
<Directory /var/www/html>
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>
```

### Explanation

| Directive | Meaning |
|---|---|
| `Options Indexes` | Allows directory listing if no index file exists |
| `FollowSymLinks` | Allows symbolic links |
| `AllowOverride None` | Disables `.htaccess` override |
| `Require all granted` | Allows all users to access |

---

## 14. What is `.htaccess`?

`.htaccess` is a per-directory Apache configuration file.

It can be used for:

```text
Redirects
Rewrite rules
Password protection
Custom error pages
Access restrictions
PHP settings
```

Example `.htaccess` redirect:

```apache
Redirect 301 /old-page.html /new-page.html
```

Important:

```text
.htaccess works only when AllowOverride is enabled.
```

Example:

```apache
<Directory /var/www/mywebsite>
    AllowOverride All
    Require all granted
</Directory>
```

---

## 15. Apache Modules

Apache features are added using modules.

| Module | Purpose |
|---|---|
| `mod_ssl` | Enables HTTPS |
| `mod_rewrite` | URL rewriting |
| `mod_proxy` | Reverse proxy |
| `mod_headers` | Add/modify HTTP headers |
| `mod_deflate` | Compression |
| `mod_auth_basic` | Basic authentication |
| `mod_status` | Server status page |
| `mod_php` | PHP support, depending on setup |

Enable module on Ubuntu:

```bash
sudo a2enmod rewrite
```

Disable module:

```bash
sudo a2dismod rewrite
```

Reload:

```bash
sudo systemctl reload apache2
```

Check loaded modules:

```bash
apache2ctl -M
```

On RHEL:

```bash
httpd -M
```

---

## 16. Enable URL Rewrite

Very common for WordPress and Laravel.

Enable module:

```bash
sudo a2enmod rewrite
sudo systemctl reload apache2
```

Virtual host example:

```apache
<Directory /var/www/mywebsite>
    AllowOverride All
    Require all granted
</Directory>
```

Example `.htaccess`:

```apache
RewriteEngine On
RewriteRule ^old$ /new [R=301,L]
```

---

## 17. Apache with PHP

Install Apache and PHP:

```bash
sudo apt update
sudo apt install apache2 php libapache2-mod-php -y
```

Create PHP test file:

```bash
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php
```

Open:

```text
http://server-ip/info.php
```

After testing, remove it:

```bash
sudo rm /var/www/html/info.php
```

Important:

```text
Never leave phpinfo() page publicly available in production.
```

---

## 18. Apache Reverse Proxy

Enable required modules:

```bash
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo systemctl reload apache2
```

Suppose backend app runs on:

```text
localhost:3000
```

Virtual host:

```apache
<VirtualHost *:80>
    ServerName app.example.com

    ProxyPreserveHost On
    ProxyPass / http://localhost:3000/
    ProxyPassReverse / http://localhost:3000/

    ErrorLog ${APACHE_LOG_DIR}/app-error.log
    CustomLog ${APACHE_LOG_DIR}/app-access.log combined
</VirtualHost>
```

### Explanation

| Directive | Meaning |
|---|---|
| `ProxyPreserveHost On` | Sends original Host header to backend |
| `ProxyPass` | Forwards request to backend |
| `ProxyPassReverse` | Rewrites backend redirects correctly |

Flow:

```text
User ---> Apache ---> localhost:3000
```

---

## 19. Apache Load Balancer

Enable modules:

```bash
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_balancer
sudo a2enmod lbmethod_byrequests
sudo systemctl reload apache2
```

Example:

```apache
<VirtualHost *:80>
    ServerName app.example.com

    <Proxy "balancer://mycluster">
        BalancerMember "http://10.0.0.11:3000"
        BalancerMember "http://10.0.0.12:3000"
        BalancerMember "http://10.0.0.13:3000"
    </Proxy>

    ProxyPass "/" "balancer://mycluster/"
    ProxyPassReverse "/" "balancer://mycluster/"
</VirtualHost>
```

Flow:

```text
              ---> App Server 1
User -> Apache ---> App Server 2
              ---> App Server 3
```

---

## 20. Apache SSL/HTTPS

Install Certbot:

```bash
sudo apt install certbot python3-certbot-apache -y
```

Run:

```bash
sudo certbot --apache -d example.com -d www.example.com
```

Apache SSL virtual host example:

```apache
<VirtualHost *:443>
    ServerName example.com
    DocumentRoot /var/www/example

    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/example.com/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/example.com/privkey.pem

    <Directory /var/www/example>
        Require all granted
    </Directory>
</VirtualHost>
```

HTTP to HTTPS redirect:

```apache
<VirtualHost *:80>
    ServerName example.com
    Redirect permanent / https://example.com/
</VirtualHost>
```

---

## 21. Apache Logs

### Ubuntu/Debian

```bash
sudo tail -f /var/log/apache2/access.log
sudo tail -f /var/log/apache2/error.log
```

### RHEL/CentOS

```bash
sudo tail -f /var/log/httpd/access_log
sudo tail -f /var/log/httpd/error_log
```

### Access Log Shows

```text
Who visited
Which page was requested
Status code
Browser/user agent
Response size
```

### Error Log Shows

```text
Permission issues
Missing files
Config problems
Backend connection failures
PHP errors
SSL errors
```

---

## 22. Common Apache Errors

### 22.1 403 Forbidden

Meaning:

```text
Apache received the request but access is denied.
```

Possible reasons:

```text
Wrong file permissions
Missing Require all granted
Wrong ownership
SELinux issue on RHEL
Directory access blocked
```

Check:

```bash
ls -ld /var/www/mywebsite
ls -l /var/www/mywebsite
```

Fix permissions:

```bash
sudo chmod -R 755 /var/www/mywebsite
```

Ubuntu ownership:

```bash
sudo chown -R www-data:www-data /var/www/mywebsite
```

RHEL ownership:

```bash
sudo chown -R apache:apache /var/www/html
```

### 22.2 404 Not Found

Meaning:

```text
Apache cannot find the requested file.
```

Possible reasons:

```text
Wrong DocumentRoot
File does not exist
Wrong URL
Rewrite rule problem
Wrong virtual host
```

Check virtual hosts:

```bash
sudo apache2ctl -S
```

### 22.3 500 Internal Server Error

Meaning:

```text
Something failed inside the server/app/config.
```

Possible reasons:

```text
Bad .htaccess syntax
PHP error
Wrong permissions
Module missing
Application crash
```

Check:

```bash
sudo tail -f /var/log/apache2/error.log
```

### 22.4 502 Bad Gateway

Meaning:

```text
Apache is working, but backend app is not responding correctly.
```

Possible reasons:

```text
Backend app down
Wrong ProxyPass port
Firewall issue
Timeout
App crashed
```

Check backend:

```bash
curl localhost:3000
```

### 22.5 Apache Not Starting

Check config:

```bash
sudo apache2ctl configtest
```

Check status:

```bash
sudo systemctl status apache2
```

Check logs:

```bash
sudo journalctl -xeu apache2
```

---

## 23. Important Apache Commands

### Ubuntu/Debian

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

### RHEL/CentOS/Rocky/AlmaLinux

```bash
sudo systemctl status httpd
sudo systemctl start httpd
sudo systemctl stop httpd
sudo systemctl restart httpd
sudo systemctl reload httpd
sudo apachectl configtest
sudo apachectl -S
httpd -M
```

---

## 24. Apache with Docker

Run Apache container:

```bash
docker run -d --name apache-web -p 8080:80 httpd:latest
```

Open:

```text
http://localhost:8080
```

Create local HTML:

```bash
mkdir html
echo "<h1>Hello from Apache Docker</h1>" > html/index.html
```

Run with volume:

```bash
docker run -d \
  --name apache-web \
  -p 8080:80 \
  -v $(pwd)/html:/usr/local/apache2/htdocs/:ro \
  httpd:latest
```

Docker Compose:

```yaml
services:
  apache:
    image: httpd:latest
    container_name: apache-web
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/local/apache2/htdocs/:ro
```

Run:

```bash
docker compose up -d
```

Stop:

```bash
docker compose down
```

---

## 25. Apache Security Basics

Important practices:

```text
Keep Apache updated
Disable unnecessary modules
Use HTTPS
Protect admin pages
Set correct file permissions
Avoid directory listing in production
Hide sensitive files
Use security headers
Monitor logs
```

Disable directory listing:

```apache
<Directory /var/www/mywebsite>
    Options -Indexes
    Require all granted
</Directory>
```

Enable headers module:

```bash
sudo a2enmod headers
sudo systemctl reload apache2
```

Basic security headers:

```apache
Header always set X-Content-Type-Options "nosniff"
Header always set X-Frame-Options "SAMEORIGIN"
Header always set X-XSS-Protection "1; mode=block"
```

---

## 26. Apache Performance Basics

Check MPM:

```bash
apache2ctl -M | grep mpm
```

Common MPMs:

| MPM | Meaning |
|---|---|
| `prefork` | Older process-based model, common with mod_php |
| `worker` | Multi-process and multi-threaded |
| `event` | Better for keep-alive connections |

Enable compression:

```bash
sudo a2enmod deflate
sudo systemctl reload apache2
```

Enable caching modules:

```bash
sudo a2enmod cache
sudo a2enmod cache_disk
sudo systemctl reload apache2
```

---

## 27. Apache Roadmap: From Scratch to Hero

### Level 1: Beginner

Learn:

```text
What is Apache?
Install Apache
Start/stop/reload
Serve static website
Understand DocumentRoot
Read logs
```

Practice:

```bash
sudo apt install apache2 -y
curl localhost
```

### Level 2: Junior Admin

Learn:

```text
Virtual Hosts
Directory blocks
Permissions
sites-available and sites-enabled
apache2ctl configtest
apache2ctl -S
```

Practice:

```text
Host two websites on one server
```

### Level 3: Web Admin

Learn:

```text
.htaccess
mod_rewrite
Redirects
PHP with Apache
LAMP stack
Custom logs
```

Practice:

```text
Deploy a PHP website
Create redirect rules
Enable rewrite module
```

### Level 4: DevOps Level

Learn:

```text
Reverse proxy
Docker Apache
CI/CD deployment
SSL with Certbot
Security headers
```

Practice:

```text
Run app on port 3000
Expose it through Apache on port 80
Add HTTPS
```

### Level 5: Hero Level

Learn:

```text
Load balancing
Advanced proxy rules
Performance tuning
MPM tuning
Troubleshooting 403/404/500/502
SELinux with Apache
Monitoring logs
```

---

## 28. Apache Interview Questions

### Q1. What is Apache?

Apache is an open-source web server used to serve websites and web applications over HTTP and HTTPS.

### Q2. What is a Virtual Host?

A Virtual Host allows Apache to host multiple websites on the same server.

### Q3. What is DocumentRoot?

DocumentRoot is the directory where Apache looks for website files.

### Q4. What is `.htaccess`?

`.htaccess` is a per-directory Apache configuration file used for redirects, rewrites, authentication, and access control.

### Q5. What is `apache2ctl configtest`?

It checks Apache configuration syntax before restart or reload.

### Q6. What is `mod_rewrite`?

`mod_rewrite` is an Apache module used to rewrite URLs using rules.

### Q7. What is `mod_proxy`?

`mod_proxy` allows Apache to work as a reverse proxy.

### Q8. What is the difference between reload and restart?

```text
reload  = apply config changes without fully stopping Apache
restart = stop and start Apache again
```

### Q9. What causes 403 Forbidden?

Common causes are wrong permissions, missing `Require all granted`, SELinux restrictions, or directory access denied.

### Q10. What causes 500 Internal Server Error?

Common causes are bad `.htaccess`, PHP error, missing module, wrong permissions, or application failure.

---

## 29. Final Summary

Apache is a powerful and flexible web server.

It can be used for:

```text
Hosting websites
Serving static files
Running PHP apps
Reverse proxy
Load balancing
SSL/HTTPS
Virtual hosting
Authentication
Logging and troubleshooting
```

Most important flow:

```text
User ---> Apache ---> Website / Backend App
```

Most important commands:

```bash
sudo apache2ctl configtest
sudo systemctl reload apache2
sudo apache2ctl -S
sudo tail -f /var/log/apache2/error.log
```

Most important config:

```apache
<VirtualHost *:80>
    ServerName example.com
    DocumentRoot /var/www/example

    <Directory /var/www/example>
        Require all granted
    </Directory>
</VirtualHost>
```

For Linux System Admin and DevOps interviews, Apache is very important especially for:

```text
LAMP stack
Virtual hosts
.htaccess
SSL
Reverse proxy
Logs
403/404/500 troubleshooting
Permissions
```
