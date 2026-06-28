# Crontab in Linux 

## 1. What is cron?

**cron** is a Linux background service used to run commands or scripts automatically at scheduled times.

Simple definition:

> **cron is a Linux scheduler that runs tasks automatically based on time.**

Examples:

```text
Run backup every night
Clean temporary files every week
Run health check every 5 minutes
Send report every Monday
Restart a service at midnight
Run script every day at 9 AM
```

---

## 2. What is crontab?

**crontab** means **cron table**.

It is a file where scheduled cron jobs are written.

Simple definition:

> **crontab is the schedule file used by cron to know what command to run and when to run it.**

Example cron job:

```bash
0 2 * * * /home/khalid/backup.sh
```

Meaning:

```text
Run /home/khalid/backup.sh every day at 2:00 AM
```

---

## 3. Why do we need crontab?

As a Linux Admin, DevOps Engineer, or SRE, many tasks should run automatically.

Without crontab, you would need to manually run commands every time.

Examples:

```bash
sudo /opt/scripts/backup.sh
sudo /opt/scripts/cleanup.sh
sudo /opt/scripts/health-check.sh
```

That is not practical.

crontab helps with:

```text
Automation
Backups
Monitoring
Log cleanup
Report generation
Health checks
Database dumps
Certificate renewal
Scheduled deployments
System maintenance
```

---

## 4. cron vs crontab

| Term | Meaning |
|---|---|
| `cron` | The background scheduler service |
| `crontab` | The file/table where cron jobs are written |
| `cron job` | One scheduled command or script |
| `crond` | Cron daemon name on many RHEL-based systems |

Think like this:

```text
cron      = teacher
crontab   = timetable
cron job  = one class on the timetable
```

---

## 5. Check cron service

### Ubuntu/Debian

```bash
systemctl status cron
```

Start and enable:

```bash
sudo systemctl start cron
sudo systemctl enable cron
```

Check if enabled:

```bash
systemctl is-enabled cron
```

### RHEL/CentOS/Fedora

```bash
systemctl status crond
```

Start and enable:

```bash
sudo systemctl start crond
sudo systemctl enable crond
```

Check if enabled:

```bash
systemctl is-enabled crond
```

---

## 6. Basic crontab commands

### Edit current user’s crontab

```bash
crontab -e
```

This opens your user’s crontab file.

### List current user’s crontab

```bash
crontab -l
```

### Remove current user’s crontab

```bash
crontab -r
```

Careful: this removes all cron jobs for the current user.

### Remove with confirmation

```bash
crontab -i -r
```

Better because it asks before removing.

---

## 7. Edit another user’s crontab

As root or with sudo:

```bash
sudo crontab -u username -e
```

Example:

```bash
sudo crontab -u khalid -e
```

List another user’s cron jobs:

```bash
sudo crontab -u khalid -l
```

Remove another user’s crontab:

```bash
sudo crontab -u khalid -r
```

[Crontab Calculator](https://www.uptimia.com/cron-expression-generator)

[Cron expression trnslater](https://www.uptimia.com/cron-expression-translator)


---

## 8. Crontab syntax

A cron job has 5 time fields plus command:

```text
* * * * * command
│ │ │ │ │
│ │ │ │ └── Day of week
│ │ │ └──── Month
│ │ └────── Day of month
│ └──────── Hour
└────────── Minute
```

Full format:

```text
MINUTE HOUR DAY_OF_MONTH MONTH DAY_OF_WEEK COMMAND
```

Example:

```bash
30 2 * * * /home/khalid/backup.sh
```

Meaning:

```text
Minute: 30
Hour: 2
Day of month: every day
Month: every month
Day of week: every day
Command: /home/khalid/backup.sh
```

So this runs:

```text
Every day at 2:30 AM
```

---

## 9. Cron time fields

| Field | Allowed Values |
|---|---|
| Minute | `0-59` |
| Hour | `0-23` |
| Day of month | `1-31` |
| Month | `1-12` |
| Day of week | `0-7` |

Important:

```text
0 or 7 = Sunday
1 = Monday
2 = Tuesday
3 = Wednesday
4 = Thursday
5 = Friday
6 = Saturday
```

---

## 10. Special characters in cron

### Asterisk `*`

Means **every**.

```bash
* * * * * command
```

Meaning:

```text
Every minute
```

### Comma `,`

Means **multiple values**.

```bash
0 9,17 * * * command
```

Meaning:

```text
Run at 9 AM and 5 PM every day
```

### Hyphen `-`

Means **range**.

```bash
0 9 * * 1-5 command
```

Meaning:

```text
Run at 9 AM Monday to Friday
```

### Slash `/`

Means **step interval**.

```bash
*/5 * * * * command
```

Meaning:

```text
Run every 5 minutes
```

---

## 11. Common crontab examples

```bash
# Every minute
* * * * * /path/script.sh

# Every 5 minutes
*/5 * * * * /path/script.sh

# Every hour
0 * * * * /path/script.sh

# Every day at midnight
0 0 * * * /path/script.sh

# Every day at 2:30 AM
30 2 * * * /path/script.sh

# Every Monday at 9 AM
0 9 * * 1 /path/script.sh

# Every weekday at 9 AM
0 9 * * 1-5 /path/script.sh

# Every Sunday at midnight
0 0 * * 0 /path/script.sh

# First day of every month at midnight
0 0 1 * * /path/script.sh

# Every 6 hours
0 */6 * * * /path/script.sh

# Every 15 minutes
*/15 * * * * /path/script.sh
```

---

## 12. Special cron shortcuts

| Shortcut | Meaning |
|---|---|
| `@reboot` | Run once at boot |
| `@yearly` | Once a year |
| `@annually` | Once a year |
| `@monthly` | Once a month |
| `@weekly` | Once a week |
| `@daily` | Once a day |
| `@midnight` | Once a day at midnight |
| `@hourly` | Once an hour |

Examples:

```bash
@reboot /home/khalid/startup.sh
@daily /home/khalid/backup.sh
```

---

## 13. Run a script using crontab

Create script directory:

```bash
mkdir -p ~/scripts
```

Create script:

```bash
nano ~/scripts/hello-cron.sh
```

Add:

```bash
#!/bin/bash
echo "Hello from cron at $(date)" >> /tmp/cron-test.log
```

Make script executable:

```bash
chmod +x ~/scripts/hello-cron.sh
```

Edit crontab:

```bash
crontab -e
```

Add:

```bash
* * * * * /home/khalid/scripts/hello-cron.sh
```

Check output:

```bash
tail -f /tmp/cron-test.log
```

---

## 14. Very important: use full paths

Cron has a limited environment.

This means commands that work in your terminal may fail in cron.

Bad:

```bash
* * * * * backup.sh
```

Better:

```bash
* * * * * /home/khalid/scripts/backup.sh
```

Find command path:

```bash
which bash
which tar
which docker
which python3
```

Example:

```bash
* * * * * /usr/bin/bash /home/khalid/scripts/backup.sh
```

---

## 15. Cron environment variables

Cron does not load your full shell environment like an interactive terminal.

You can set variables inside crontab:

```bash
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

0 2 * * * /home/khalid/scripts/backup.sh
```

---

## 16. Redirect cron output to logs

If a cron job produces output, it may be sent as local mail or lost depending on system setup.

Better: redirect output to a log file.

```bash
* * * * * /home/khalid/scripts/hello-cron.sh >> /tmp/cron-test.log 2>&1
```

Meaning:

```text
>> /tmp/cron-test.log = append standard output
2>&1 = send error output to same place
```

Production style:

```bash
0 2 * * * /opt/scripts/backup.sh >> /var/log/backup.log 2>&1
```

---

## 17. Disable cron email

Cron may send command output to local mail.

Disable mail:

```bash
MAILTO=""
```

Example:

```bash
MAILTO=""
0 2 * * * /opt/scripts/backup.sh >> /var/log/backup.log 2>&1
```

Or send mail to an address if mail is configured:

```bash
MAILTO="admin@example.com"
```

---

## 18. System-wide cron files

### User crontab

Edited with:

```bash
crontab -e
```

Format:

```text
* * * * * command
```

### System crontab

File:

```bash
/etc/crontab
```

Format includes username:

```text
* * * * * user command
```

Example:

```bash
0 2 * * * root /opt/scripts/backup.sh
```

Important difference:

```text
User crontab = no username field
/etc/crontab = has username field
```

---

## 19. Cron directories

Linux also has cron directories:

```text
/etc/cron.hourly/
/etc/cron.daily/
/etc/cron.weekly/
/etc/cron.monthly/
```

Check:

```bash
ls -l /etc/cron.hourly/
ls -l /etc/cron.daily/
ls -l /etc/cron.weekly/
ls -l /etc/cron.monthly/
```

---

## 20. Where are user crontabs stored?

Do not usually edit these files directly, but it is good to know.

On many RHEL-based systems:

```text
/var/spool/cron/
```

On many Debian/Ubuntu systems:

```text
/var/spool/cron/crontabs/
```

Examples:

```bash
sudo ls -l /var/spool/cron/
sudo ls -l /var/spool/cron/crontabs/
```

Best practice:

```bash
crontab -e
```

---

## 21. Cron logs

Cron logs help troubleshoot whether a job ran.

Ubuntu/Debian:

```bash
grep CRON /var/log/syslog
```

RHEL/CentOS/Fedora:

```bash
sudo grep CRON /var/log/cron
```

With journalctl:

```bash
journalctl -u cron
journalctl -u crond
```

---

## 22. Troubleshooting cron jobs

When a cron job does not run, check:

```text
Is cron service running?
Is crontab syntax correct?
Is script executable?
Are full paths used?
Does the script depend on environment variables?
Is output redirected to a log?
Does the user have permission?
Is the schedule correct?
Is the system timezone correct?
```

Commands:

```bash
systemctl status cron
systemctl status crond
crontab -l
ls -l /path/script.sh
chmod +x /path/script.sh
which command-name
date
timedatectl
grep CRON /var/log/syslog
sudo grep CRON /var/log/cron
```

---

## 23. Real-world cron examples

### Backup every night at 2 AM

```bash
0 2 * * * /opt/scripts/backup.sh >> /var/log/backup.log 2>&1
```

### Health check every 5 minutes

```bash
*/5 * * * * /opt/scripts/health-check.sh >> /var/log/health-check.log 2>&1
```

### Clean temp files every Sunday at midnight

```bash
0 0 * * 0 /opt/scripts/cleanup-temp.sh >> /var/log/cleanup-temp.log 2>&1
```

### Run database dump daily at 1 AM

```bash
0 1 * * * /opt/scripts/db-dump.sh >> /var/log/db-dump.log 2>&1
```

### Check disk usage every hour

```bash
0 * * * * /opt/scripts/disk-check.sh >> /var/log/disk-check.log 2>&1
```

---

## 24. Cron permissions

Cron access can be controlled by:

```text
/etc/cron.allow
/etc/cron.deny
```

If `/etc/cron.allow` exists:

```text
Only users listed inside it can use crontab.
```

If `/etc/cron.allow` does not exist but `/etc/cron.deny` exists:

```text
Users listed in cron.deny cannot use crontab.
```

Check:

```bash
ls -l /etc/cron.allow /etc/cron.deny
```

---

## 25. Crontab vs systemd timer

| Feature | Crontab | systemd Timer |
|---|---|---|
| Easy to write | Yes | Medium |
| Good for simple schedules | Yes | Yes |
| Integrated with systemd logs | Limited | Strong |
| Can track missed runs | Limited | Better with `Persistent=true` |
| Best for | Simple scheduled scripts | Service-based scheduled tasks |

Simple answer:

```text
Use crontab for simple scheduled jobs.
Use systemd timers for deeper systemd integration.
```

---

## 26. Important timezone point

Cron runs based on the system’s local timezone.

Check current time:

```bash
date
```

Check timezone:

```bash
timedatectl
```

Example:

```text
If your system timezone is CST, cron follows CST.
If your system timezone is UTC, cron follows UTC.
```

For GitHub Actions schedules, cron is UTC. But Linux crontab usually follows the system timezone.

---

## 27. Common mistakes

### Missing full path

Bad:

```bash
* * * * * script.sh
```

Good:

```bash
* * * * * /home/khalid/scripts/script.sh
```

### Script not executable

Fix:

```bash
chmod +x /home/khalid/scripts/script.sh
```

### No output logging

Bad:

```bash
0 2 * * * /opt/scripts/backup.sh
```

Good:

```bash
0 2 * * * /opt/scripts/backup.sh >> /var/log/backup.log 2>&1
```

### Wrong user

A job that needs root permissions should be in root crontab:

```bash
sudo crontab -e
```

or system crontab with user field:

```bash
0 2 * * * root /opt/scripts/backup.sh
```

### Wrong timezone

Check:

```bash
date
timedatectl
```

---

## 28. Cron expression practice

```bash
# Every weekday at 9 AM
0 9 * * 1-5 /path/script.sh

# First day of every month at midnight
0 0 1 * * /path/script.sh

# Every 6 hours
0 */6 * * * /path/script.sh

# Every Monday at 2:30 AM
30 2 * * 1 /path/script.sh

# Every day at 11:45 PM
45 23 * * * /path/script.sh
```

---

## 29. Production best practices

For production cron jobs:

```text
Use full script paths
Use full command paths if needed
Redirect output to logs
Use meaningful log files
Add comments in crontab
Test scripts manually first
Keep scripts in /opt/scripts or similar
Check permissions
Monitor job success/failure
Avoid overlapping jobs
Document schedules
Use locking if job must not run twice
```

Example with comment:

```bash
# Daily backup at 2 AM
0 2 * * * /opt/scripts/backup.sh >> /var/log/backup.log 2>&1
```

---

## 30. Prevent overlapping cron jobs

Sometimes a job takes longer than expected and the next run starts before the old one finishes.

Use `flock`.

Example:

```bash
*/5 * * * * /usr/bin/flock -n /tmp/health-check.lock /opt/scripts/health-check.sh >> /var/log/health-check.log 2>&1
```

Meaning:

```text
If previous health-check is still running, do not start another one.
```

---

## 31. Quick command cheat sheet

```bash
# Edit current user's crontab
crontab -e

# List current user's crontab
crontab -l

# Remove current user's crontab
crontab -r

# Remove with confirmation
crontab -i -r

# Edit another user's crontab
sudo crontab -u username -e

# List another user's crontab
sudo crontab -u username -l

# Check cron service on Ubuntu/Debian
systemctl status cron

# Check cron service on RHEL
systemctl status crond

# Check cron logs on Ubuntu
grep CRON /var/log/syslog

# Check cron logs on RHEL
sudo grep CRON /var/log/cron

# Check timezone
date
timedatectl

# Check cron permission files
ls -l /etc/cron.allow /etc/cron.deny

# Check cron directories
ls -l /etc/cron.daily/
ls -l /etc/cron.hourly/
```

---

## 32. Interview questions

### What is cron?

cron is a Linux scheduler that runs commands or scripts automatically at scheduled times.

### What is crontab?

crontab is the file/table where cron jobs are defined.

### What is a cron job?

A cron job is one scheduled command or script.

### What command edits the current user’s crontab?

```bash
crontab -e
```

### What command lists current user cron jobs?

```bash
crontab -l
```

### What is the format of a cron schedule?

```text
minute hour day-of-month month day-of-week command
```

### What does `*/5 * * * *` mean?

Every 5 minutes.

### What does `0 2 * * *` mean?

Every day at 2:00 AM.

### What does `0 9 * * 1-5` mean?

Every weekday at 9:00 AM.

### Difference between user crontab and `/etc/crontab`?

User crontab does not include username field. `/etc/crontab` includes username field.

---

## 33. Final summary

```text
cron = Linux scheduler service
crontab = schedule table/file
cron job = one scheduled command
crontab -e = edit jobs
crontab -l = list jobs
5 fields = minute hour day month weekday
Use full paths
Redirect output to logs
Check cron logs when troubleshooting
Cron follows system timezone
```

Golden rule:

```text
Test script manually first.
Then schedule it in crontab.
Then check logs.
```
