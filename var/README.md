# Linux `/var` Study Notes — README

## Overview

This set of notes explains the Linux **`/var` directory** and how to safely think about compressing or backing it up.

These files are useful for Linux, DevOps, System Administrator, and RHCSA/RHEL practice.

## Files Included

| File | Description |
|---|---|
| `var-folder-linux-from-scratch-to-hero-study-notes.md` | Complete study notes explaining the `/var` folder from beginner to advanced level |
| `compress-var-folder-linux-study-notes.md` | Study notes explaining whether `/var` can be compressed, safe backup methods, warnings, and best practices |

## Topics Covered

- Meaning of `/var`
- Why Linux needs `/var`
- Important `/var` subdirectories
- `/var/log`, `/var/cache`, `/var/spool`, `/var/lib`, `/var/tmp`
- Ubuntu vs RHEL log and package paths
- Disk space troubleshooting
- Safe cleanup commands
- Compressing `/var` for backup
- Why not to compress `/var` in place
- Safe `tar` backup examples
- Logrotate basics
- Docker and database backup warnings

## Best For

These notes are helpful for:

- Linux beginners
- DevOps students
- System Administrator practice
- RHCSA/RHEL preparation
- Interview revision
- Troubleshooting disk space issues

## Practice Commands

```bash
ls -l /var
sudo du -sh /var
sudo du -h /var --max-depth=1 | sort -h
df -h
ls -lh /var/log
journalctl --disk-usage
sudo apt clean
sudo dnf clean all
docker system df
```

## Quick Safety Reminder

Do **not** run dangerous commands like:

```bash
sudo rm -rf /var/*
sudo gzip -r /var
```

Better approach:

```text
Check what is large.
Understand what owns it.
Use safe cleanup commands.
Backup only what is needed.
Save backups outside /var.
```

## Quick Summary

`/var` stores variable data that changes while Linux is running.

Examples include:

```text
Logs
Cache
Spool jobs
Application state
Docker data
Database data
Web server files
Mail
```

Compressing `/var` is possible for backup, but it should be done carefully with exclusions and proper planning.
