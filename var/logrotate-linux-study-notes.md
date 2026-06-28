# logrotate in Linux — Study Notes

## 1. What is logrotate?

`logrotate` is a Linux tool used to **manage log files automatically**.

Simple definition:

> `logrotate` rotates, compresses, deletes, and recreates log files so logs do not become too large.

It is mainly used to prevent `/var/log` from growing too much and filling the `/var` filesystem.

---

## 2. Why do we need logrotate?

Linux services continuously write logs.

Examples:

```text
/var/log/messages
/var/log/syslog
/var/log/nginx/access.log
/var/log/httpd/access_log
/var/log/secure
/var/log/auth.log
```

If these logs keep growing without control, the system can face problems such as:

```text
/var becomes full
Services may fail
Applications may stop writing logs
Troubleshooting becomes difficult
System performance may be affected
```

`logrotate` helps by managing logs automatically.

---

## 3. What does logrotate do?

`logrotate` can:

```text
Rotate log files
Compress old logs
Delete very old logs
Create new empty log files
Run scripts after rotation
Prevent empty logs from rotating
Ignore missing log files
```

---

## 4. What is log rotation?

Log rotation means the current log file is renamed, and a new log file is created.

Example before rotation:

```text
/var/log/nginx/access.log
```

Example after rotation:

```text
/var/log/nginx/access.log
/var/log/nginx/access.log.1
/var/log/nginx/access.log.2.gz
/var/log/nginx/access.log.3.gz
```

Meaning:

| File | Meaning |
|---|---|
| `access.log` | Current active log |
| `access.log.1` | Previous log |
| `access.log.2.gz` | Older compressed log |
| `access.log.3.gz` | Even older compressed log |

---

## 5. Simple Example

Before logrotate:

```text
app.log
```

After first rotation:

```text
app.log
app.log.1
```

After more rotations with compression:

```text
app.log
app.log.1
app.log.2.gz
app.log.3.gz
```

After old logs exceed the limit, logrotate deletes the oldest ones automatically.

---

## 6. Main logrotate Configuration Files

Main configuration file:

```bash
/etc/logrotate.conf
```

Service-specific configuration directory:

```bash
/etc/logrotate.d/
```

Check main config:

```bash
cat /etc/logrotate.conf
```

List service-specific configs:

```bash
ls -l /etc/logrotate.d/
```

Examples:

```bash
cat /etc/logrotate.d/nginx
cat /etc/logrotate.d/httpd
cat /etc/logrotate.d/rsyslog
```

---

## 7. Common logrotate Options

| Option | Meaning |
|---|---|
| `daily` | Rotate logs every day |
| `weekly` | Rotate logs every week |
| `monthly` | Rotate logs every month |
| `rotate 4` | Keep 4 old log files |
| `compress` | Compress old logs |
| `missingok` | Do not show error if log file is missing |
| `notifempty` | Do not rotate empty log files |
| `create` | Create a new log file after rotation |
| `dateext` | Add date to rotated log file name |
| `size 100M` | Rotate when log reaches 100 MB |
| `copytruncate` | Copy the log and truncate the original file |
| `postrotate` | Run commands after rotation |
| `sharedscripts` | Run postrotate script once for multiple logs |

---

## 8. Basic logrotate Configuration Example

Example:

```conf
/var/log/myapp/*.log {
    daily
    rotate 7
    compress
    missingok
    notifempty
    create 0640 root root
}
```

Explanation:

| Line | Meaning |
|---|---|
| `/var/log/myapp/*.log` | Rotate all `.log` files inside `/var/log/myapp/` |
| `daily` | Rotate every day |
| `rotate 7` | Keep 7 old log files |
| `compress` | Compress old logs |
| `missingok` | No error if log file is missing |
| `notifempty` | Do not rotate empty logs |
| `create 0640 root root` | Create new log with permission `0640`, owner `root`, group `root` |

---

## 9. Create a Custom logrotate Rule

### Step 1: Create a sample log directory

```bash
sudo mkdir -p /var/log/myapp
```

### Step 2: Create a sample log file

```bash
echo "Test log line" | sudo tee -a /var/log/myapp/app.log
```

### Step 3: Create logrotate config

```bash
sudo nano /etc/logrotate.d/myapp
```

Add:

```conf
/var/log/myapp/app.log {
    daily
    rotate 5
    compress
    missingok
    notifempty
    create 0640 root root
}
```

Save and exit.

---

## 10. Test logrotate Safely

### Debug mode

Debug mode checks the config but does not actually rotate logs.

```bash
sudo logrotate -d /etc/logrotate.conf
```

This is safe for testing.

### Force rotation

Force logrotate to run immediately:

```bash
sudo logrotate -f /etc/logrotate.conf
```

Force a specific config:

```bash
sudo logrotate -f /etc/logrotate.d/myapp
```

---

## 11. logrotate Status File

logrotate keeps track of when logs were last rotated.

Common status file:

```bash
/var/lib/logrotate/status
```

Check it:

```bash
sudo cat /var/lib/logrotate/status
```

This file helps logrotate know whether a log file should be rotated again.

---

## 12. logrotate and Cron/Systemd Timer

On many Linux systems, logrotate runs automatically.

It may be started by:

```text
cron
systemd timer
```

Check cron location:

```bash
ls -l /etc/cron.daily/logrotate
```

Check systemd timer:

```bash
systemctl list-timers | grep logrotate
```

Check service/timer:

```bash
systemctl status logrotate.timer
```

---

## 13. Important: Do Not Delete Active Logs Blindly

Avoid:

```bash
sudo rm -f /var/log/app.log
```

Why?

The service may still be writing to the deleted file through an open file handle.

This can cause:

```text
Disk space not freed immediately
Logs disappear from normal path
Troubleshooting becomes harder
Service may need restart
```

Better approach:

```text
Use logrotate
Restart/reload service if needed
Use proper cleanup commands
```

---

## 14. copytruncate Option

`copytruncate` is used when an application cannot close and reopen its log file.

Example:

```conf
/var/log/myapp/app.log {
    daily
    rotate 7
    compress
    copytruncate
    missingok
    notifempty
}
```

Meaning:

```text
Copy current log to rotated file
Then empty/truncate the original log file
Application continues writing to the same file
```

Important note:

> `copytruncate` can lose a few log lines during the copy/truncate moment, but it is useful for applications that cannot reload logs properly.

---

## 15. postrotate Option

`postrotate` runs a command after log rotation.

Example for NGINX-style reload:

```conf
/var/log/nginx/*.log {
    daily
    rotate 14
    compress
    missingok
    notifempty
    create 0640 www-data adm
    sharedscripts
    postrotate
        systemctl reload nginx >/dev/null 2>&1 || true
    endscript
}
```

Meaning:

```text
Rotate NGINX logs
Create new log files
Reload NGINX after rotation
Ignore reload error if needed
```

---

## 16. size-Based Rotation

Instead of rotating daily or weekly, logs can rotate based on size.

Example:

```conf
/var/log/myapp/app.log {
    size 100M
    rotate 5
    compress
    missingok
    notifempty
    create 0640 root root
}
```

Meaning:

```text
Rotate when app.log reaches 100 MB
Keep 5 old logs
Compress old logs
```

---

## 17. dateext Option

`dateext` adds a date to rotated log files.

Example:

```conf
/var/log/myapp/app.log {
    daily
    rotate 7
    compress
    dateext
    missingok
    notifempty
}
```

Example rotated file:

```text
app.log-20260628.gz
```

This makes logs easier to identify by date.

---

## 18. Troubleshooting logrotate

### Check syntax/debug

```bash
sudo logrotate -d /etc/logrotate.conf
```

### Force rotation

```bash
sudo logrotate -f /etc/logrotate.conf
```

### Check status file

```bash
sudo cat /var/lib/logrotate/status
```

### Check if timer exists

```bash
systemctl list-timers | grep logrotate
```

### Check config files

```bash
ls -l /etc/logrotate.d/
cat /etc/logrotate.conf
```

### Check large logs

```bash
sudo find /var/log -type f -size +100M -exec ls -lh {} \;
```

---

## 19. Real-World Scenario

### Scenario

`/var` is almost full because `/var/log/myapp/app.log` is 5 GB.

Bad approach:

```bash
sudo rm -f /var/log/myapp/app.log
```

Better approach:

```bash
sudo du -sh /var/log/myapp
sudo logrotate -d /etc/logrotate.d/myapp
sudo logrotate -f /etc/logrotate.d/myapp
sudo systemctl restart myapp
```

Even better long-term solution:

```text
Create a proper logrotate rule
Keep limited old logs
Compress old logs
Reload/restart service after rotation if required
Monitor /var usage
```

---

## 20. Interview Questions

### What is logrotate?

`logrotate` is a Linux utility that manages log files by rotating, compressing, deleting old logs, and creating new log files.

### Why do we need logrotate?

We need logrotate to prevent log files from becoming too large and filling `/var` or the root filesystem.

### Where is logrotate configured?

Main config:

```bash
/etc/logrotate.conf
```

Service-specific configs:

```bash
/etc/logrotate.d/
```

### What does `rotate 7` mean?

It keeps 7 old rotated log files.

### What does `compress` mean?

It compresses old rotated logs, usually using gzip.

### What does `missingok` mean?

It tells logrotate not to show an error if the log file is missing.

### What does `notifempty` mean?

It tells logrotate not to rotate empty log files.

### What does `create 0640 root root` mean?

It creates a new log file with permission `0640`, owner `root`, and group `root`.

### What is `copytruncate`?

It copies the current log to a rotated file and then truncates the original log file. It is useful when an application cannot reopen logs.

### What is `postrotate`?

It is a section used to run commands after log rotation, such as reloading a service.

---

## 21. Quick Command Cheat Sheet

```bash
# Check main logrotate config
cat /etc/logrotate.conf

# List service-specific configs
ls -l /etc/logrotate.d/

# View NGINX logrotate config
cat /etc/logrotate.d/nginx

# View Apache/httpd logrotate config
cat /etc/logrotate.d/httpd

# Debug logrotate without rotating
sudo logrotate -d /etc/logrotate.conf

# Force logrotate
sudo logrotate -f /etc/logrotate.conf

# Force one specific config
sudo logrotate -f /etc/logrotate.d/myapp

# Check logrotate status
sudo cat /var/lib/logrotate/status

# Check logrotate timer
systemctl list-timers | grep logrotate

# Check large log files
sudo find /var/log -type f -size +100M -exec ls -lh {} \;

# Check /var/log size
sudo du -sh /var/log

# Check /var usage
sudo du -sh /var
sudo du -h /var --max-depth=1 | sort -h
```

---

## 22. Final Summary

```text
logrotate = automatic Linux log manager
Purpose = prevent logs from filling /var
Main config = /etc/logrotate.conf
Service configs = /etc/logrotate.d/
Common actions = rotate, compress, delete old logs, create new logs
Testing command = sudo logrotate -d /etc/logrotate.conf
Force command = sudo logrotate -f /etc/logrotate.conf
```

Best practice:

```text
Do not delete active logs blindly.
Use logrotate for long-term log control.
Compress old logs, not active logs.
Keep only needed history.
Monitor /var and /var/log regularly.
```
