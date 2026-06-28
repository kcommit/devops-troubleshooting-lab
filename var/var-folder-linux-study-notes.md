# `/var` Folder in Linux 

## 1. What is `/var` in Linux?

`/var` means **variable data**.

Simple definition:

> `/var` stores files that change frequently while the Linux system is running.

Examples of changing data:

```text
Logs
Cache
Spool files
Lock files
Temporary application data
Mail
Databases
Web server files
Package manager data
```

`/var` is not mainly for static commands or configuration files. It is for data that grows, changes, rotates, or gets updated during normal system operation.

---

## 2. Why do we need `/var`?

Linux separates files by purpose.

| Directory | Purpose |
|---|---|
| `/bin` | Essential commands |
| `/etc` | Configuration files |
| `/home` | User personal files |
| `/root` | Root user home |
| `/tmp` | Temporary files |
| `/var` | Frequently changing system/application data |

We need `/var` because services create many changing files.

Examples:

```text
NGINX writes logs
Apache writes logs
Linux package manager stores cache
Mail server stores mail queue
Cron stores scheduled job data
Databases store data
System logs are written continuously
```

Without `/var`, all these changing files would be mixed with system files, making Linux harder to manage and troubleshoot.

---

## 3. Easy Example

Imagine Linux is a school.

```text
/etc  = school rules and configuration
/bin  = tools used by staff
/home = student lockers
/var  = daily activity records
```

`/var` contains records that keep changing every day:

```text
Attendance logs
Cafeteria records
Exam print queue
Notice board updates
```

In Linux, those are:

```text
System logs
Print spool
Cache
Runtime application data
Web files
Mail queue
```

---

## 4. Important `/var` Subdirectories

Check what is inside `/var`:

```bash
ls -l /var
```

Common directories:

```text
/var/log
/var/cache
/var/spool
/var/tmp
/var/lib
/var/run
/var/lock
/var/www
/var/mail
/var/opt
```

---

# 5. `/var/log`

`/var/log` stores log files.

Common examples:

```text
/var/log/syslog
/var/log/messages
/var/log/auth.log
/var/log/secure
/var/log/dmesg
/var/log/nginx/
/var/log/httpd/
/var/log/audit/
```

Ubuntu/Debian commonly use:

```text
/var/log/syslog
/var/log/auth.log
```

RHEL/CentOS/Fedora commonly use:

```text
/var/log/messages
/var/log/secure
```

Check logs:

```bash
ls -lh /var/log
```

Read logs on Ubuntu:

```bash
sudo less /var/log/syslog
```

Read logs on RHEL:

```bash
sudo less /var/log/messages
```

Authentication logs on Ubuntu:

```bash
sudo less /var/log/auth.log
```

Authentication logs on RHEL:

```bash
sudo less /var/log/secure
```

Follow logs live on Ubuntu:

```bash
sudo tail -f /var/log/syslog
```

Follow logs live on RHEL:

```bash
sudo tail -f /var/log/messages
```

### Why `/var/log` matters

Logs help troubleshoot:

```text
Service failure
Login failure
SSH issue
Permission issue
Disk issue
Kernel messages
Web server errors
Security events
```

---

# 6. `/var/cache`

`/var/cache` stores cached data used by applications.

Cache means:

> Data saved temporarily to make future operations faster.

Examples:

```text
Package manager cache
Application cache
Font cache
Web cache
```

Ubuntu package cache:

```text
/var/cache/apt/
```

RHEL package cache:

```text
/var/cache/dnf/
/var/cache/yum/
```

Check cache size:

```bash
sudo du -sh /var/cache
```

Clean package cache on Ubuntu:

```bash
sudo apt clean
```

Clean package cache on RHEL:

```bash
sudo dnf clean all
```

Important note:

> Cache can usually be recreated, but do not randomly delete files unless you understand which application owns them.

---

# 7. `/var/spool`

`/var/spool` stores queued work waiting to be processed.

Spool means:

> A waiting area or queue for jobs.

Examples:

```text
Print jobs
Mail queue
Cron jobs
At jobs
```

Common paths:

```text
/var/spool/cron
/var/spool/mail
/var/spool/cups
/var/spool/at
```

Check spool directory:

```bash
ls -l /var/spool
```

Check cron spool:

```bash
sudo ls -l /var/spool/cron
```

On many systems, user crontabs are stored inside `/var/spool/cron`.

---

# 8. `/var/tmp`

`/var/tmp` stores temporary files that should survive reboot.

This is different from `/tmp`.

| Directory | Purpose |
|---|---|
| `/tmp` | Temporary files, often cleared on reboot |
| `/var/tmp` | Temporary files that may survive reboot |

Example:

```bash
touch /var/tmp/testfile
ls -l /var/tmp/testfile
```

Use `/var/tmp` when temporary data should remain after reboot.

---

# 9. `/var/lib`

`/var/lib` stores application state data.

Simple definition:

> `/var/lib` stores data that applications need to remember between runs.

Examples:

```text
Database files
Docker data
Package manager state
System service state
Cloud-init data
NetworkManager state
```

Common paths:

```text
/var/lib/docker
/var/lib/mysql
/var/lib/postgresql
/var/lib/rpm
/var/lib/dpkg
/var/lib/systemd
/var/lib/NetworkManager
```

Check Docker data:

```bash
sudo ls -l /var/lib/docker
```

Check RHEL package database:

```bash
ls -l /var/lib/rpm
```

Check Ubuntu package database:

```bash
ls -l /var/lib/dpkg
```

Very important warning:

> Do not randomly delete files from `/var/lib`.

Deleting files from `/var/lib` can break:

```text
Docker containers
Databases
Package manager
System services
```

---

# 10. `/var/www`

`/var/www` is commonly used for web server files.

Common web root:

```text
/var/www/html
```

Apache or NGINX may serve website files from this location.

Check web root:

```bash
ls -l /var/www/html
```

Create a simple web page:

```bash
echo "<h1>Hello from /var/www/html</h1>" | sudo tee /var/www/html/index.html
```

Important note:

> The exact web root depends on Apache or NGINX configuration.

---

# 11. `/var/mail`

`/var/mail` stores local user mail on some Linux systems.

Example:

```text
/var/mail/khalid
```

Check local mail directory:

```bash
ls -l /var/mail
```

If the system sends local mail to a user, it may appear here.

---

# 12. `/var/run`

Historically, `/var/run` stored runtime data such as PID files and sockets.

On modern Linux, `/var/run` is often a symbolic link to:

```text
/run
```

Check:

```bash
ls -ld /var/run
```

You may see:

```text
/var/run -> /run
```

Runtime data includes:

```text
PID files
Socket files
Service runtime state
```

---

# 13. `/var/lock`

`/var/lock` stores lock files.

Lock files help prevent two processes from using the same resource at the same time.

On modern Linux, `/var/lock` may link to:

```text
/run/lock
```

Check:

```bash
ls -ld /var/lock
```

---

# 14. `/var/opt`

`/var/opt` stores variable data for applications installed in `/opt`.

Example:

```text
/opt/myapp      = application files
/var/opt/myapp  = changing data for that application
/etc/opt/myapp  = configuration for that application
```

This follows a clean Linux directory structure.

---

# 15. `/var` and Disk Space Issues

`/var` can grow quickly because logs, cache, Docker data, and databases are stored there.

Check `/var` size:

```bash
sudo du -sh /var
```

Check top large folders:

```bash
sudo du -h /var --max-depth=1 | sort -h
```

Check disk space:

```bash
df -h
```

Common causes of full `/var`:

```text
Huge logs in /var/log
Package cache in /var/cache
Docker images/containers in /var/lib/docker
Database growth in /var/lib/mysql or /var/lib/postgresql
Mail queue in /var/spool
Web uploads in /var/www
```

---

# 16. Safe Cleanup Examples

## Clean package cache on Ubuntu

```bash
sudo apt clean
```

## Clean package cache on RHEL

```bash
sudo dnf clean all
```

## Check log size

```bash
sudo du -sh /var/log
```

## Find large log files

```bash
sudo find /var/log -type f -size +100M -exec ls -lh {} \;
```

## Check journal log size

```bash
journalctl --disk-usage
```

## Clean old journal logs by time

```bash
sudo journalctl --vacuum-time=7d
```

## Clean old journal logs by size

```bash
sudo journalctl --vacuum-size=500M
```

## Check Docker disk usage

```bash
docker system df
```

## Clean unused Docker data

```bash
docker system prune
```

Be careful with:

```bash
docker system prune -a
```

This removes unused images too.

---

# 17. Important Warning

Never run:

```bash
sudo rm -rf /var/*
```

This can destroy:

```text
Logs
Databases
Package manager data
Docker data
Web files
Mail
Service state
```

A safer approach:

```text
Find what is large
Understand what owns it
Use application-specific cleanup commands
Remove only safe files
```

---

# 18. `/var` Permissions

Check permissions:

```bash
ls -ld /var
```

Usually:

```text
drwxr-xr-x root root /var
```

Check important subdirectories:

```bash
ls -ld /var/log
ls -ld /var/www
ls -ld /var/lib
ls -ld /var/spool
```

Do not randomly change ownership of `/var`:

```bash
sudo chown -R user:user /var
```

This is dangerous and can break services.

---

# 19. `/var` in Ubuntu vs RHEL

Most `/var` concepts are the same, but some file names differ.

| Purpose | Ubuntu/Debian | RHEL/CentOS/Fedora |
|---|---|---|
| Main system log | `/var/log/syslog` | `/var/log/messages` |
| Auth/security log | `/var/log/auth.log` | `/var/log/secure` |
| Apache logs | `/var/log/apache2/` | `/var/log/httpd/` |
| Package cache | `/var/cache/apt/` | `/var/cache/dnf/` or `/var/cache/yum/` |
| Package database | `/var/lib/dpkg/` | `/var/lib/rpm/` |
| Web root | `/var/www/html` | `/var/www/html` |

---

# 20. `/var` Troubleshooting Flow

When disk is full or a service is failing:

```text
1. Check disk space
2. Check size of /var
3. Find largest subdirectories
4. Check logs
5. Check service-specific data
6. Clean safely using proper commands
7. Restart affected service if needed
```

Commands:

```bash
df -h
sudo du -sh /var
sudo du -h /var --max-depth=1 | sort -h
sudo find /var -type f -size +500M -exec ls -lh {} \;
journalctl --disk-usage
sudo systemctl status nginx
sudo journalctl -u nginx -n 50
```

---

# 21. Practical Lab

Try these commands safely:

```bash
ls -l /var
sudo du -sh /var
sudo du -h /var --max-depth=1 | sort -h
ls -lh /var/log
journalctl --disk-usage
ls -ld /var/run
ls -ld /var/lock
```

Create a test file in `/var/tmp`:

```bash
echo "temporary test" | sudo tee /var/tmp/test-var-file.txt
cat /var/tmp/test-var-file.txt
sudo rm /var/tmp/test-var-file.txt
```

Check web root:

```bash
ls -ld /var/www
ls -ld /var/www/html
```

---

# 22. Interview Questions

## What is `/var`?

`/var` stores variable data that changes during system operation, such as logs, cache, spool files, application state, and web data.

## What is `/var/log`?

`/var/log` stores system and application log files.

## What is `/var/cache`?

`/var/cache` stores cached data used by applications and package managers.

## What is `/var/lib`?

`/var/lib` stores persistent application state data, such as package databases, Docker data, and database files.

## What is `/var/spool`?

`/var/spool` stores queued jobs such as mail, print jobs, cron jobs, and at jobs.

## Difference between `/tmp` and `/var/tmp`?

`/tmp` is for temporary files that may be cleared on reboot. `/var/tmp` is for temporary files that may survive reboot.

## Why can `/var` become full?

Because logs, cache, Docker data, databases, mail queues, and application files can grow over time.

---

# 23. Quick Command Cheat Sheet

```bash
ls -l /var
sudo du -sh /var
sudo du -h /var --max-depth=1 | sort -h
df -h
ls -lh /var/log
sudo tail -f /var/log/syslog
sudo tail -f /var/log/messages
journalctl --disk-usage
sudo journalctl --vacuum-time=7d
sudo apt clean
sudo dnf clean all
docker system df
docker system prune
ls -ld /var/run
ls -ld /var/lock
ls -ld /var/www/html
```

---

# 24. Final Summary

```text
/var = variable data
/var/log = logs
/var/cache = cache
/var/spool = queued jobs
/var/tmp = temporary files that may survive reboot
/var/lib = application state and data
/var/www = web server files
/var/mail = local mail
/var/run = runtime data, usually linked to /run
/var/lock = lock files, often linked to /run/lock
```

As a Linux admin or DevOps engineer, `/var` is very important because many real troubleshooting cases start there:

```text
Logs
Disk full issues
Docker storage
Database data
Web server files
Package manager cache
Service state
```
