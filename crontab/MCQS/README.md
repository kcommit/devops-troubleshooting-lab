# Crontab MCQ Quiz — README

## Overview

This HTML file contains a **25-question multiple-choice quiz** about **crontab in Linux**.

It is designed to help students practice cron scheduling, crontab commands, cron expressions, output redirection, troubleshooting, and production best practices.

## Main File

| File | Description |
|---|---|
| `crontab-25-mcq-quiz.html` | Interactive 25-question crontab quiz with timer, answer checking, score, and explanations |

## Features

- 25 multiple-choice questions
- Answer checking
- Score calculation
- 20-minute timer
- Correct and wrong answer highlighting
- Short explanation for each question
- Reset quiz option
- Mobile-friendly design

## Topics Covered

- What is cron?
- What is crontab?
- What is a cron job?
- `crontab -e`
- `crontab -l`
- `crontab -r`
- Editing another user’s crontab
- Cron schedule format
- Common cron expressions
- Cron shortcuts like `@reboot` and `@daily`
- Full path requirement
- Cron environment variables
- Output redirection
- `MAILTO`
- User crontab vs `/etc/crontab`
- Cron logs
- Preventing overlapping cron jobs with `flock`

## How to Use

1. Download the HTML file.
2. Open it in any web browser.
3. Select your answers.
4. Click **Check Answers**.
5. Review your score and explanations.
6. Click **Reset Quiz** to practice again.

## Best For

This quiz is useful for:

- Linux beginners
- DevOps students
- System Administrator practice
- SRE troubleshooting practice
- RHCSA/RHEL preparation
- Interview revision
- Automation practice

## Practice Commands

After completing the quiz, practice these commands in your Linux lab:

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
```

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
