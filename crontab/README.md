# Crontab Linux Study Notes — README

## Overview

This study note explains **crontab in Linux** from beginner to advanced level.

It is designed for Linux, DevOps, System Administrator, and SRE practice.

## Main File

| File | Description |
|---|---|
| `crontab-linux-from-scratch-to-hero-study-notes.md` | Complete study notes explaining cron, crontab, cron jobs, syntax, examples, troubleshooting, and production best practices |

## Topics Covered

- What is cron?
- What is crontab?
- cron vs crontab vs cron job
- Cron service on Ubuntu and RHEL
- Basic crontab commands
- Crontab syntax
- Cron time fields
- Special cron characters
- Common cron expressions
- Cron shortcuts like `@reboot`, `@daily`, and `@hourly`
- Running scripts using crontab
- Full path requirement
- Output redirection to log files
- User crontab vs `/etc/crontab`
- Cron directories
- Cron logs
- Troubleshooting cron jobs
- Cron permissions
- Crontab vs systemd timers
- Timezone behavior
- Production best practices
- Preventing overlapping jobs with `flock`

## Best For

These notes are useful for:

- Linux beginners
- DevOps students
- System Administrator practice
- SRE troubleshooting practice
- RHCSA/RHEL preparation
- Interview revision
- Automation practice

## Practice Commands

```bash
crontab -e
crontab -l
crontab -i -r
sudo crontab -u username -e
systemctl status cron
systemctl status crond
grep CRON /var/log/syslog
sudo grep CRON /var/log/cron
date
timedatectl
ls -l /etc/cron.daily/
ls -l /etc/cron.allow /etc/cron.deny
```

## Crontab Calculator
[Crontab Calculator](https://www.uptimia.com/cron-expression-generator)

[Cron expression trnslater](https://www.uptimia.com/cron-expression-translator)

## Common Cron Examples

```bash
# Every 5 minutes
*/5 * * * * /path/script.sh

# Every day at 2 AM
0 2 * * * /path/script.sh

# Every weekday at 9 AM
0 9 * * 1-5 /path/script.sh

# First day of every month at midnight
0 0 1 * * /path/script.sh

# Every 6 hours
0 */6 * * * /path/script.sh
```

## Quick Summary

```text
cron = Linux scheduler service
crontab = schedule table/file
cron job = one scheduled command
crontab -e = edit jobs
crontab -l = list jobs
```

Golden rule:

```text
Test script manually first.
Then schedule it in crontab.
Then check logs.
```
