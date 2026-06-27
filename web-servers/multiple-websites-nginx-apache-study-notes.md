# Launch Multiple Websites with Different Domain Names on NGINX and Apache

## Goal

Launch multiple websites on one Linux server using different domain names.

Example:

```text
site1.com  ---> /var/www/site1
site2.com  ---> /var/www/site2
site3.com  ---> /var/www/site3
```

In real life, this is how one server can host multiple websites.

---

## Main Idea

A web server checks the domain name requested by the user and serves the matching website folder.

```text
User visits site1.com
        |
        v
Web server checks domain name
        |
        v
Matches site1.com config
        |
        v
Serves /var/www/site1
```

For NGINX, this is called:

```text
Server Blocks
```

For Apache, this is called:

```text
Virtual Hosts
```

---

## DNS Requirement

Before configuring NGINX or Apache, your domains must point to your server IP.

Example DNS records:

```text
site1.com  A record  ---> your-server-ip
site2.com  A record  ---> your-server-ip
site3.com  A record  ---> your-server-ip
```

Example:

```text
site1.com  ---> 203.0.113.10
site2.com  ---> 203.0.113.10
```

All domains can point to the same server IP.

---

## Important Port Rule

On one server, only one service can directly listen on port `80` and `443`.

| Port | Purpose |
|---:|---|
| 80 | HTTP |
| 443 | HTTPS |

Bad setup:

```text
NGINX  ---> port 80
Apache ---> port 80
```

This causes a port conflict.

Good options:

```text
Option 1: Use only NGINX for all websites
Option 2: Use only Apache for all websites
Option 3: Use NGINX on port 80/443 and Apache behind it on port 8080
```

---

# Part 1: Launch Multiple Websites on NGINX

## Example Domains

```text
site1.com
site2.com
```

## Step 1: Install NGINX

```bash
sudo apt update
sudo apt install nginx -y
```

Check status:

```bash
sudo systemctl status nginx
```

---

## Step 2: Create Website Directories

```bash
sudo mkdir -p /var/www/site1
sudo mkdir -p /var/www/site2
```

---

## Step 3: Create Test Pages

```bash
echo "<h1>Welcome to Site 1</h1>" | sudo tee /var/www/site1/index.html
echo "<h1>Welcome to Site 2</h1>" | sudo tee /var/www/site2/index.html
```

---

## Step 4: Set Permissions

```bash
sudo chmod -R 755 /var/www/site1
sudo chmod -R 755 /var/www/site2
```

Optional ownership:

```bash
sudo chown -R www-data:www-data /var/www/site1
sudo chown -R www-data:www-data /var/www/site2
```

---

## Step 5: Create NGINX Server Block for Site 1

```bash
sudo nano /etc/nginx/sites-available/site1.com
```

Add:

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

---

## Step 6: Create NGINX Server Block for Site 2

```bash
sudo nano /etc/nginx/sites-available/site2.com
```

Add:

```nginx
server {
    listen 80;
    server_name site2.com www.site2.com;

    root /var/www/site2;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    access_log /var/log/nginx/site2-access.log;
    error_log /var/log/nginx/site2-error.log;
}
```

---

## Step 7: Enable Both NGINX Sites

```bash
sudo ln -s /etc/nginx/sites-available/site1.com /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/site2.com /etc/nginx/sites-enabled/
```

---

## Step 8: Test and Reload NGINX

Always test before reload:

```bash
sudo nginx -t
```

Reload:

```bash
sudo systemctl reload nginx
```

Now:

```text
http://site1.com ---> /var/www/site1
http://site2.com ---> /var/www/site2
```

---

## NGINX Important Directives

| Directive | Meaning |
|---|---|
| `listen 80;` | NGINX listens for HTTP traffic |
| `server_name site1.com;` | Domain name for this website |
| `root /var/www/site1;` | Website folder |
| `index index.html;` | Default page |
| `try_files $uri $uri/ =404;` | Serve file if found, otherwise show 404 |
| `access_log` | Log successful/requested traffic |
| `error_log` | Log errors |

---

# Part 2: Launch Multiple Websites on Apache

## Example Domains

```text
site1.com
site2.com
```

---

## Step 1: Install Apache

Ubuntu/Debian:

```bash
sudo apt update
sudo apt install apache2 -y
```

Check status:

```bash
sudo systemctl status apache2
```

---

## Step 2: Create Website Directories

```bash
sudo mkdir -p /var/www/site1
sudo mkdir -p /var/www/site2
```

---

## Step 3: Create Test Pages

```bash
echo "<h1>Welcome to Site 1</h1>" | sudo tee /var/www/site1/index.html
echo "<h1>Welcome to Site 2</h1>" | sudo tee /var/www/site2/index.html
```

---

## Step 4: Set Permissions

Ubuntu/Debian:

```bash
sudo chown -R www-data:www-data /var/www/site1
sudo chown -R www-data:www-data /var/www/site2
sudo chmod -R 755 /var/www/site1
sudo chmod -R 755 /var/www/site2
```

RHEL/CentOS/Rocky/AlmaLinux:

```bash
sudo chown -R apache:apache /var/www/site1
sudo chown -R apache:apache /var/www/site2
sudo chmod -R 755 /var/www/site1
sudo chmod -R 755 /var/www/site2
```

---

## Step 5: Create Apache Virtual Host for Site 1

Ubuntu/Debian:

```bash
sudo nano /etc/apache2/sites-available/site1.com.conf
```

Add:

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

---

## Step 6: Create Apache Virtual Host for Site 2

```bash
sudo nano /etc/apache2/sites-available/site2.com.conf
```

Add:

```apache
<VirtualHost *:80>
    ServerName site2.com
    ServerAlias www.site2.com
    DocumentRoot /var/www/site2

    <Directory /var/www/site2>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/site2-error.log
    CustomLog ${APACHE_LOG_DIR}/site2-access.log combined
</VirtualHost>
```

---

## Step 7: Enable Both Apache Sites

```bash
sudo a2ensite site1.com.conf
sudo a2ensite site2.com.conf
```

Optional: disable default Apache site.

```bash
sudo a2dissite 000-default.conf
```

---

## Step 8: Test and Reload Apache

Always test config first:

```bash
sudo apache2ctl configtest
```

Expected output:

```text
Syntax OK
```

Reload Apache:

```bash
sudo systemctl reload apache2
```

Now:

```text
http://site1.com ---> /var/www/site1
http://site2.com ---> /var/www/site2
```

---

## Apache Important Directives

| Directive | Meaning |
|---|---|
| `<VirtualHost *:80>` | Website listens on HTTP port 80 |
| `ServerName site1.com` | Main domain name |
| `ServerAlias www.site1.com` | Additional domain name |
| `DocumentRoot /var/www/site1` | Website folder |
| `<Directory>` | Folder permission block |
| `Require all granted` | Allow users to access site |
| `ErrorLog` | Error log |
| `CustomLog` | Access log |

---

# Part 3: Running NGINX and Apache on the Same Server

## Problem

NGINX and Apache cannot both use port `80` on the same IP.

Bad:

```text
NGINX  ---> port 80
Apache ---> port 80
```

Good:

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

---

## Step 1: Change Apache to Listen on Port 8080

Edit Apache ports file:

```bash
sudo nano /etc/apache2/ports.conf
```

Change or add:

```apache
Listen 8080
```

If Apache has `Listen 80`, you can comment it or replace it with `Listen 8080`.

Example:

```apache
# Listen 80
Listen 8080
```

---

## Step 2: Update Apache Virtual Host to Port 8080

Edit site config:

```bash
sudo nano /etc/apache2/sites-available/site1.com.conf
```

Use:

```apache
<VirtualHost *:8080>
    ServerName site1.com
    DocumentRoot /var/www/site1

    <Directory /var/www/site1>
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/site1-error.log
    CustomLog ${APACHE_LOG_DIR}/site1-access.log combined
</VirtualHost>
```

Test Apache:

```bash
sudo apache2ctl configtest
```

Restart Apache:

```bash
sudo systemctl restart apache2
```

Check listening ports:

```bash
sudo ss -tulnp | grep apache
```

Apache should now listen on:

```text
8080
```

---

## Step 3: Configure NGINX as Reverse Proxy to Apache

Create NGINX config:

```bash
sudo nano /etc/nginx/sites-available/site1.com
```

Add:

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

    access_log /var/log/nginx/site1-access.log;
    error_log /var/log/nginx/site1-error.log;
}
```

Enable site:

```bash
sudo ln -s /etc/nginx/sites-available/site1.com /etc/nginx/sites-enabled/
```

Test NGINX:

```bash
sudo nginx -t
```

Reload NGINX:

```bash
sudo systemctl reload nginx
```

---

## Final Flow with NGINX and Apache Together

```text
User visits site1.com
        |
        v
NGINX receives request on port 80
        |
        v
NGINX forwards request to Apache on port 8080
        |
        v
Apache serves /var/www/site1
        |
        v
User sees website
```

---

# Part 4: Add HTTPS SSL for Each Domain

## HTTPS with NGINX

Install Certbot:

```bash
sudo apt install certbot python3-certbot-nginx -y
```

Create SSL for site1:

```bash
sudo certbot --nginx -d site1.com -d www.site1.com
```

Create SSL for site2:

```bash
sudo certbot --nginx -d site2.com -d www.site2.com
```

---

## HTTPS with Apache

Install Certbot:

```bash
sudo apt install certbot python3-certbot-apache -y
```

Create SSL for site1:

```bash
sudo certbot --apache -d site1.com -d www.site1.com
```

Create SSL for site2:

```bash
sudo certbot --apache -d site2.com -d www.site2.com
```

---

## Check Certbot Auto Renewal

```bash
sudo certbot renew --dry-run
```

---

# Part 5: Testing

## Test DNS

```bash
dig site1.com
dig site2.com
```

or:

```bash
nslookup site1.com
nslookup site2.com
```

---

## Test HTTP Response

```bash
curl -I http://site1.com
curl -I http://site2.com
```

---

## Test Local Server Block Without DNS

If DNS is not ready, test locally using `/etc/hosts`.

Edit:

```bash
sudo nano /etc/hosts
```

Add:

```text
your-server-ip site1.com
your-server-ip site2.com
```

Example:

```text
203.0.113.10 site1.com
203.0.113.10 site2.com
```

Then test:

```bash
curl http://site1.com
curl http://site2.com
```

---

# Part 6: Troubleshooting

## Problem 1: Website Shows Wrong Site

Possible causes:

```text
Wrong server_name or ServerName
Default site still enabled
DNS points to wrong server
Config file not enabled
Web server not reloaded
```

NGINX check:

```bash
sudo nginx -T | grep server_name
```

Apache check:

```bash
sudo apache2ctl -S
```

---

## Problem 2: 403 Forbidden

Possible causes:

```text
Wrong permissions
Wrong ownership
Missing Require all granted in Apache
NGINX cannot read website directory
```

Check:

```bash
ls -ld /var/www/site1
ls -l /var/www/site1
```

Fix:

```bash
sudo chmod -R 755 /var/www/site1
```

Apache Ubuntu ownership:

```bash
sudo chown -R www-data:www-data /var/www/site1
```

NGINX common ownership:

```bash
sudo chown -R www-data:www-data /var/www/site1
```

---

## Problem 3: 404 Not Found

Possible causes:

```text
index.html missing
Wrong root or DocumentRoot
Wrong location block
Wrong domain config
```

Check:

```bash
ls -l /var/www/site1
```

---

## Problem 4: Port Already in Use

Check ports:

```bash
sudo ss -tulnp | grep ':80'
sudo ss -tulnp | grep ':443'
sudo ss -tulnp | grep ':8080'
```

If both Apache and NGINX try to use port 80, one will fail.

---

## Problem 5: NGINX Config Error

Test:

```bash
sudo nginx -t
```

Check logs:

```bash
sudo tail -f /var/log/nginx/error.log
```

---

## Problem 6: Apache Config Error

Test:

```bash
sudo apache2ctl configtest
```

Check logs:

```bash
sudo tail -f /var/log/apache2/error.log
```

---

# Part 7: Quick Comparison

| Task | NGINX | Apache |
|---|---|---|
| Multiple websites | Server Blocks | Virtual Hosts |
| Website folder directive | `root` | `DocumentRoot` |
| Domain directive | `server_name` | `ServerName` |
| Alias domain | Add inside `server_name` | `ServerAlias` |
| Enable site | Symlink to `sites-enabled` | `a2ensite` |
| Disable site | Remove symlink | `a2dissite` |
| Test config | `sudo nginx -t` | `sudo apache2ctl configtest` |
| Reload service | `sudo systemctl reload nginx` | `sudo systemctl reload apache2` |
| Access logs | `/var/log/nginx/` | `/var/log/apache2/` |
| Error logs | `/var/log/nginx/` | `/var/log/apache2/` |

---

# Part 8: Best Practice

## Recommended Setup for Beginners

Use only one web server first:

```text
Use NGINX only
or
Use Apache only
```

Do not mix both at the beginning.

## Recommended Production Setup

A common production setup is:

```text
Internet
   |
   v
NGINX
   |
   v
Backend Apps / Apache / Docker containers
```

NGINX is often used as the public reverse proxy because it is fast and simple for handling traffic, SSL, and proxying.

---

# Final Summary

To launch multiple websites with different domain names:

```text
1. Point each domain DNS to your server IP
2. Create separate website folders
3. Create separate NGINX server blocks or Apache virtual hosts
4. Match each domain with the correct website folder
5. Test configuration
6. Reload the web server
7. Add SSL certificates
```

Main concept:

```text
One server can host many websites by checking the requested domain name.
```

NGINX example:

```text
site1.com ---> server_name site1.com ---> /var/www/site1
site2.com ---> server_name site2.com ---> /var/www/site2
```

Apache example:

```text
site1.com ---> ServerName site1.com ---> /var/www/site1
site2.com ---> ServerName site2.com ---> /var/www/site2
```
