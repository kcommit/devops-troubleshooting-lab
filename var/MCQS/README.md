# Linux `/var` MCQ Quiz — README

## Overview

This HTML file contains a **25-question multiple-choice quiz** about the Linux **`/var` directory**.

It is designed to help students review `/var` concepts, troubleshooting commands, safe cleanup methods, and compression warnings.

## Main File

| File | Description |
|---|---|
| `var-topics-25-mcq-quiz.html` | Interactive `/var` topics quiz with 25 MCQs |

## Features

- 25 multiple-choice questions
- Answer checking
- Score calculation
- 20-minute timer
- Correct and wrong answer highlighting
- Short explanation for each question
- Reset quiz option
- Mobile-friendly layout

## Topics Covered

- Meaning of `/var`
- Variable data in Linux
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
- Disk usage commands
- Journal cleanup
- Safe `/var` cleanup
- Why not to blindly compress or delete `/var`

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
- RHCSA/RHEL preparation
- Interview revision
- Classroom practice

## Practice Commands

After completing the quiz, practice these commands in your Linux lab:

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
```

## Safety Reminder

Do not run dangerous commands like:

```bash
sudo rm -rf /var/*
sudo gzip -r /var
```

Always check what is using space first, then clean safely.

## Quick Summary

The `/var` directory stores changing system and application data such as logs, cache, spool jobs, Docker data, databases, mail, and web files. This quiz helps reinforce the most important `/var` troubleshooting and safety concepts.
