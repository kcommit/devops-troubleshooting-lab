# Linux `/var` and logrotate MCQ Files — README

## Overview

This folder contains interactive HTML quiz files for practicing Linux `/var` topics and `logrotate`.

These quizzes are designed for:

- Linux beginners
- System Administrator practice
- DevOps students
- SRE troubleshooting practice
- RHCSA/RHEL preparation
- Interview revision

## Files Included

| File | Description |
|---|---|
| `var-topics-25-mcq-quiz.html` | 25-question MCQ quiz covering Linux `/var` directory basics, subdirectories, disk usage, safe cleanup, and troubleshooting |
| `var-real-world-scenarios-10-mcq.html` | 10 real-world scenario-based questions for Sys Admin, DevOps, and SRE practice |
| `logrotate-25-mcq-quiz.html` | 25-question MCQ quiz covering `logrotate`, configuration files, rotation options, testing, and troubleshooting |

## Features

Each HTML quiz includes:

- Multiple-choice questions
- Answer checking
- Score calculation
- Timer
- Correct and wrong answer highlighting
- Short explanations
- Reset quiz option
- Mobile-friendly design

## Topics Covered

### Linux `/var`

- Meaning of `/var`
- `/var/log`
- `/var/cache`
- `/var/spool`
- `/var/tmp`
- `/var/lib`
- `/var/www`
- `/var/mail`
- `/var/run`
- `/var/lock`
- Ubuntu vs RHEL log paths
- Disk usage troubleshooting
- Safe cleanup commands
- Dangerous commands to avoid

### Real-World Scenarios

- `/var` filesystem full
- Large log files
- Docker storage usage
- Package cache cleanup
- Database backup safety
- Web root troubleshooting
- Avoiding unsafe cleanup commands

### logrotate

- What is `logrotate`
- `/etc/logrotate.conf`
- `/etc/logrotate.d/`
- `daily`, `weekly`, `monthly`
- `rotate`
- `compress`
- `missingok`
- `notifempty`
- `create`
- `copytruncate`
- `postrotate`
- Debug and force rotation commands

## How to Use

1. Download the HTML files.
2. Open any quiz file in a web browser.
3. Select your answers.
4. Click **Check Answers**.
5. Review your score and explanations.
6. Click **Reset Quiz** to practice again.

## Practice Commands

Use these commands in your Linux lab after completing the quizzes:

```bash
ls -l /var
sudo du -sh /var
sudo du -h /var --max-depth=1 | sort -h
df -h
ls -lh /var/log
journalctl --disk-usage
sudo journalctl --vacuum-time=7d
sudo apt clean
sudo dnf clean all
docker system df
cat /etc/logrotate.conf
ls -l /etc/logrotate.d/
sudo logrotate -d /etc/logrotate.conf
sudo logrotate -f /etc/logrotate.conf
```

## Safety Reminder

Do not run dangerous commands like:

```bash
sudo rm -rf /var/*
sudo gzip -r /var
sudo chmod -R 777 /var
```

Better troubleshooting approach:

```text
Check what is using space.
Understand which service owns the files.
Use safe cleanup commands.
Use logrotate for logs.
Never delete or compress /var blindly.
```

## Quick Summary

`/var` stores changing system and application data such as logs, cache, Docker data, databases, mail, spool jobs, and web files.

`logrotate` manages log files by rotating, compressing, deleting old logs, and creating new log files so `/var/log` does not grow without control.

These MCQ files help reinforce both theory and real-world troubleshooting skills.
