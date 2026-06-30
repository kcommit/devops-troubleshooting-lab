# NFS WSL Lab Files

This folder contains study material and an interactive MCQ quiz for the NFS lab using:

```text
Ubuntu-24.04 WSL  = NFS Server
AlmaLinux-9 WSL   = NFS Client
```

---

## Files Included

| File Name | Purpose |
|---|---|
| `nfs-wsl-ubuntu-almalinux-from-scratch-to-hero.md` | Complete NFS study notes from scratch to hero based on the real working lab |
| `nfs-wsl-lab-25-mcq-quiz.html` | Interactive 25-question MCQ quiz with timer, score, answer checking, and short explanations |

---

## 1. Study Notes File

### File

```text
nfs-wsl-ubuntu-almalinux-from-scratch-to-hero.md
```

### What it contains

This Markdown file explains the full NFS lab step by step:

```text
What is NFS?
Ubuntu WSL NFS server setup
AlmaLinux WSL NFS client setup
/etc/exports configuration
exportfs usage
showmount usage
mount command
root_squash explanation
Common mistakes and fixes
Troubleshooting checklist
Interview-style explanation
```

### Best use

Use this file for:

```text
Linux study notes
NFS revision
Interview preparation
Hands-on lab documentation
GitHub repository notes
```

---

## 2. MCQ Quiz HTML File

### File

```text
nfs-wsl-lab-25-mcq-quiz.html
```

### What it contains

This HTML file contains an interactive quiz with:

```text
25 MCQs
25-minute timer
Score calculation
Answer checking
Correct/incorrect highlighting
Short explanations
Reset button
Show explanations button
```

### How to open

Double-click the file:

```text
nfs-wsl-lab-25-mcq-quiz.html
```

It will open in your browser.

You can also open it from terminal:

```bash
start nfs-wsl-lab-25-mcq-quiz.html
```

or on Linux:

```bash
xdg-open nfs-wsl-lab-25-mcq-quiz.html
```

---

## Recommended Study Flow

Follow this order:

```text
1. Read the Markdown notes first.
2. Practice the NFS commands in WSL.
3. Open the HTML quiz.
4. Attempt all 25 questions.
5. Click Check Answers.
6. Review short explanations.
7. Repeat until you score 90% or higher.
```

---

## Lab Summary

In this lab:

```text
Ubuntu-24.04 WSL exported /nfs/share using NFS.
AlmaLinux-9 WSL mounted that share at /mnt/nfs-share.
A file created from AlmaLinux appeared on Ubuntu.
This proved that the NFS server-client setup worked successfully.
```

---

## Important Commands Covered

### Ubuntu NFS Server

```bash
sudo apt install nfs-kernel-server -y
sudo mkdir -p /nfs/share
sudo chmod 777 /nfs/share
sudo vim /etc/exports
sudo exportfs -rav
sudo exportfs -v
showmount -e localhost
ip -4 addr show eth0
```

### AlmaLinux NFS Client

```bash
sudo dnf install nfs-utils -y
sudo ping -c 4 SERVER_IP
showmount -e SERVER_IP
sudo mkdir -p /mnt/nfs-share
sudo mount -t nfs SERVER_IP:/nfs/share /mnt/nfs-share
df -h | grep nfs
mount | grep nfs
```

---

## Common Errors Covered

| Error | Fix |
|---|---|
| `Unable to locate package nfs-kernal-server` | Use `nfs-kernel-server` |
| `sudo: exports: command not found` | Use `sudo exportfs -rav` |
| `sysctl: cannot stat /proc/sys/status` | Use `systemctl`, not `sysctl` |
| `ping: socket: Operation not permitted` | Use `sudo ping` in AlmaLinux WSL |
| Client cannot connect | Make sure both WSL distros are running |

---

## Final Result

```text
NFS Server:
Ubuntu exports /nfs/share.

NFS Client:
AlmaLinux mounts it at /mnt/nfs-share.

Proof:
alma-test.txt created from AlmaLinux appeared inside /nfs/share on Ubuntu.
```

---

## One-Line Summary

> This project documents a successful NFS lab where Ubuntu WSL worked as the NFS server and AlmaLinux WSL worked as the NFS client.
