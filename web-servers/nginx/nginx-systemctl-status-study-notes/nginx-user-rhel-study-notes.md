# Nginx User and Group Study Notes in RHEL

## Topic
Understanding which Linux user runs Nginx, and how to check it using
 > `/etc/passwd`

 > `/etc/group`

 > `/etc/shadow`

 > `/etc/nginx/nginx.conf`

---

## 1. Important Difference: Ubuntu vs RHEL

In Linux, Nginx runs using a special **service account**. This account is not normally used by a human user. It is used by the Nginx service for security.

| Linux Family | Common Nginx User | Common Nginx Group |
|---|---|---|
| Ubuntu / Debian | `www-data` | `www-data` |
| RHEL / Rocky Linux / AlmaLinux / CentOS / Fedora | `nginx` | `nginx` |

### Simple Meaning

On Ubuntu/Debian, you usually check:

```bash
grep www-data /etc/passwd
```

On RHEL/Rocky/AlmaLinux, you usually check:

```bash
grep nginx /etc/passwd
```

---

## 2. Check Nginx User in `/etc/passwd`

### Ubuntu/Debian Command

```bash
grep www-data /etc/passwd
```

### RHEL/Rocky/AlmaLinux Command

```bash
grep nginx /etc/passwd
```

### Example Output on RHEL

```text
nginx:x:987:987:Nginx web server:/var/lib/nginx:/sbin/nologin
```

### How to Read It

| Field | Example | Meaning |
|---|---|---|
| Username | `nginx` | Service account name |
| Password placeholder | `x` | Password is stored in `/etc/shadow` |
| UID | `987` | User ID |
| GID | `987` | Primary group ID |
| Comment | `Nginx web server` | Description of the account |
| Home directory | `/var/lib/nginx` | Home directory for this service account |
| Shell | `/sbin/nologin` | User cannot login normally |

### Important Point

```text
/sbin/nologin
```

means the `nginx` user is not a normal login user. It is a **service account**.

---

## 3. Check Nginx Group in `/etc/group`

### Ubuntu/Debian Command

```bash
grep www-data /etc/group
```

### RHEL/Rocky/AlmaLinux Command

```bash
grep nginx /etc/group
```

### Example Output on RHEL

```text
nginx:x:987:
```

### How to Read It

| Field | Example | Meaning |
|---|---|---|
| Group name | `nginx` | Name of the group |
| Password placeholder | `x` | Group password placeholder |
| GID | `987` | Group ID |
| Members | empty | No extra users are added to this group |

---

## 4. Check Nginx Shadow Entry in `/etc/shadow`

The `/etc/shadow` file stores password information. Normal users cannot read it, so we use `sudo`.

### Ubuntu/Debian Command

```bash
sudo grep www-data /etc/shadow
```

### RHEL/Rocky/AlmaLinux Command

```bash
sudo grep nginx /etc/shadow
```

### Example Output on RHEL

```text
nginx:!!:19800::::::
```

### How to Read It

| Field | Example | Meaning |
|---|---|---|
| Username | `nginx` | Account name |
| Password field | `!!` | Password is locked |

### Important Meaning

```text
!!
```

means this account cannot login using a password.

This is normal for Nginx because the `nginx` user is a **locked service account**.

---

## 5. Check Nginx User in Config File

Nginx configuration file is usually here:

```bash
/etc/nginx/nginx.conf
```

Use this command:

```bash
grep user /etc/nginx/nginx.conf
```

### Ubuntu/Debian Example Output

```nginx
user www-data;
```

### RHEL/Rocky/AlmaLinux Example Output

```nginx
user nginx;
```

### Meaning

This line tells Nginx which user should run the **worker processes**.

```text
user nginx;
```

means Nginx worker processes run as the `nginx` user.

---

## 6. Check Actual Running Nginx Processes

Use this command:

```bash
ps aux | grep nginx
```

### Example Output

```text
root      1200  nginx: master process /usr/sbin/nginx
nginx     1201  nginx: worker process
nginx     1202  nginx: worker process
```

### How to Read It

| Process User | Process Type | Meaning |
|---|---|---|
| `root` | master process | Main Nginx process |
| `nginx` | worker process | Handles web requests |

---

## 7. Why Does Master Process Run as Root?

The master process often runs as `root` because Nginx needs permission to bind to privileged ports.

Common privileged ports:

| Port | Meaning |
|---|---|
| `80` | HTTP |
| `443` | HTTPS |

After starting, Nginx runs worker processes as a safer low-privilege user such as:

```text
nginx
```

This improves security.

---

## 8. Useful RHEL Nginx Commands

### Check Nginx User

```bash
grep nginx /etc/passwd
```

### Check Nginx Group

```bash
grep nginx /etc/group
```

### Check Nginx Shadow Entry

```bash
sudo grep nginx /etc/shadow
```

### Check User Directive in Nginx Config

```bash
grep user /etc/nginx/nginx.conf
```

### Check Running Nginx Processes

```bash
ps aux | grep nginx
```

### Check Nginx Service Status

```bash
sudo systemctl status nginx
```

### Test Nginx Configuration

```bash
sudo nginx -t
```

### Restart Nginx

```bash
sudo systemctl restart nginx
```

### Reload Nginx After Config Changes

```bash
sudo systemctl reload nginx
```

---

## 9. Command Comparison: Ubuntu vs RHEL

| Purpose | Ubuntu/Debian | RHEL/Rocky/AlmaLinux |
|---|---|---|
| Check service user | `grep www-data /etc/passwd` | `grep nginx /etc/passwd` |
| Check service group | `grep www-data /etc/group` | `grep nginx /etc/group` |
| Check shadow entry | `sudo grep www-data /etc/shadow` | `sudo grep nginx /etc/shadow` |
| Check Nginx config user | `grep user /etc/nginx/nginx.conf` | `grep user /etc/nginx/nginx.conf` |
| Check service status | `sudo systemctl status nginx` | `sudo systemctl status nginx` |

---

## 10. One-Line Definitions

### Nginx User

```text
The Nginx user is a low-privilege service account used to run Nginx worker processes safely.
```

### Service Account

```text
A service account is a special Linux account used by a service, not by a normal human user.
```

### `/sbin/nologin`

```text
/sbin/nologin means the account cannot be used for normal shell login.
```

### `!!` in `/etc/shadow`

```text
!! means the account password is locked.
```

### Nginx Master Process

```text
The master process controls Nginx and usually starts as root.
```

### Nginx Worker Process

```text
Worker processes handle user web requests and usually run as the nginx user.
```

---

## 11. Final Summary

On Ubuntu/Debian, Nginx commonly uses:

```text
www-data
```

On RHEL/Rocky/AlmaLinux, Nginx commonly uses:

```text
nginx
```

So on RHEL, instead of checking `www-data`, check `nginx`:

```bash
grep nginx /etc/passwd
```

```bash
grep nginx /etc/group
```

```bash
sudo grep nginx /etc/shadow
```

```bash
grep user /etc/nginx/nginx.conf
```

The main idea is:

```text
Nginx uses a locked, low-privilege service account to run worker processes securely.
```
