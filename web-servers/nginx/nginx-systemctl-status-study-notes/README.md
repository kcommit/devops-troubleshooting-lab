# Nginx Study Notes README

## Overview

This folder contains two Nginx study-note files. These notes are designed for Linux administration practice and help explain how to check Nginx service status and how to understand the Nginx service account on Ubuntu and RHEL-based systems.

---

## Files Included

| File Name | Description |
|---|---|
| `nginx-systemctl-status-study-notes.md` | Explains how to read `sudo systemctl status nginx` output line by line. |
| `nginx-user-rhel-study-notes.md` | Explains the Nginx service user and group, especially the difference between Ubuntu/Debian and RHEL/Rocky/AlmaLinux. |

---

## 1. Nginx systemctl Status Study Notes

This file focuses on how to check whether Nginx is running.

Main command:

```bash
sudo systemctl status nginx
```

You will learn:

- Correct `systemctl` command format
- Meaning of `Loaded: loaded`
- Meaning of `enabled`
- Meaning of `Active: active (running)`
- Meaning of `status=0/SUCCESS`
- Nginx master process and worker processes
- How to test Nginx using `curl localhost`
- Common Nginx service commands

Important point:

```text
Active: active (running)
```

means Nginx is currently running successfully.

---

## 2. Nginx User and Group Study Notes in RHEL

This file focuses on which Linux user runs Nginx.

You will learn:

- Ubuntu/Debian commonly uses `www-data`
- RHEL/Rocky/AlmaLinux commonly uses `nginx`
- How to check Nginx user in `/etc/passwd`
- How to check Nginx group in `/etc/group`
- How to check locked password status in `/etc/shadow`
- How to check the Nginx user directive in `/etc/nginx/nginx.conf`
- Why Nginx master process may run as `root`
- Why worker processes run as a low-privilege service account

Important RHEL commands:

```bash
grep nginx /etc/passwd
grep nginx /etc/group
sudo grep nginx /etc/shadow
grep user /etc/nginx/nginx.conf
ps aux | grep nginx
```

---

## Recommended Study Order

1. First read:

```text
nginx-systemctl-status-study-notes.md
```

2. Then read:

```text
nginx-user-rhel-study-notes.md
```

This order is better because first you learn how to check if Nginx is running, then you learn which user and group are running the Nginx processes.

---

## Quick Practice Commands

```bash
sudo systemctl status nginx
sudo nginx -t
curl localhost
ps aux | grep nginx
grep nginx /etc/passwd
grep nginx /etc/group
sudo grep nginx /etc/shadow
grep user /etc/nginx/nginx.conf
```

---

## Final Goal

After studying both files, you should be able to explain:

```text
How to check Nginx service status, how to confirm it is running, how to identify master and worker processes, and how to verify the Nginx service account on Ubuntu and RHEL-based systems.
```

---

## Best For

These notes are useful for:

- Linux beginners
- System administration practice
- RHCSA-style Linux service understanding
- DevOps foundation learning
- Interview preparation
