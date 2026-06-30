# NFS Client Auto Setup Script

This README explains how to use the NFS client setup script:

```text
nfs-client-setup.sh
```

The script is used on the **client machine** to connect to an existing NFS server.

---

## What This Script Does

The script automatically:

```text
Detects the Linux OS
Supports Ubuntu/Debian clients
Supports RHEL/AlmaLinux/Rocky/Fedora clients
Installs the correct NFS client package
Checks network connectivity to the NFS server
Runs showmount to view server exports
Creates the local mount point
Mounts the NFS share
Verifies the mount
Tests write access
Optionally adds the mount to /etc/fstab
Prints useful commands at the end
```

---

## Supported Operating Systems

| OS Family | Examples | Client Package |
|---|---|---|
| Debian-based | Ubuntu, Debian | `nfs-common` |
| RHEL-based | RHEL, AlmaLinux, Rocky, Fedora | `nfs-utils` |

---

## Supported Environments

| Environment | Supported? | Notes |
|---|---:|---|
| WSL | Yes | Good for local NFS lab practice |
| AWS EC2 | Yes | Security Group must allow NFS from client to server |
| VirtualBox/VMware | Yes | VM network must allow communication |
| Bare-metal Linux | Yes | Firewall/network must allow NFS |
| Two physical laptops with WSL | Limited | WSL NAT can make networking difficult |

---

## Downloaded Script Name

```text
nfs-client-setup.sh
```

---

## Make Script Executable

```bash
chmod +x nfs-client-setup.sh
```

---

## Basic Usage

```bash
sudo ./nfs-client-setup.sh SERVER_IP
```

Example from the WSL lab:

```bash
sudo ./nfs-client-setup.sh 172.27.100.62
```

Default values:

```text
Remote share: /nfs/share
Local mount point: /mnt/nfs-share
```

---

## Full Usage Format

```bash
sudo ./nfs-client-setup.sh SERVER_IP [REMOTE_SHARE] [LOCAL_MOUNT_POINT] [--fstab]
```

| Argument | Meaning | Required? | Default |
|---|---|---:|---|
| `SERVER_IP` | NFS server IP address or hostname | Yes | None |
| `REMOTE_SHARE` | NFS shared directory on server | No | `/nfs/share` |
| `LOCAL_MOUNT_POINT` | Client mount point | No | `/mnt/nfs-share` |
| `--fstab` | Add permanent mount entry | No | Disabled |

---

## WSL Lab Example

In the working lab:

```text
Ubuntu-24.04 WSL  = NFS Server
AlmaLinux-9 WSL   = NFS Client
```

Ubuntu server IP was:

```text
172.27.100.62
```

Run on AlmaLinux client:

```bash
sudo ./nfs-client-setup.sh 172.27.100.62
```

This will mount:

```text
172.27.100.62:/nfs/share
```

to:

```text
/mnt/nfs-share
```

---

## Custom Share and Mount Point

```bash
sudo ./nfs-client-setup.sh 172.27.100.62 /nfs/share /mnt/nfs-share
```

Another example:

```bash
sudo ./nfs-client-setup.sh 192.168.1.50 /data/nfs /mnt/shared-data
```

---

## Permanent Mount with `/etc/fstab`

To add the NFS mount permanently:

```bash
sudo ./nfs-client-setup.sh 172.27.100.62 /nfs/share /mnt/nfs-share --fstab
```

This adds an entry like:

```text
172.27.100.62:/nfs/share /mnt/nfs-share nfs defaults,_netdev 0 0
```

---

## Important WSL Warning

For WSL practice, avoid `--fstab` at first.

Reason:

```text
WSL IP can change after restart.
If the server IP changes, the /etc/fstab entry will become incorrect.
```

Better for WSL:

```bash
sudo ./nfs-client-setup.sh 172.27.100.62
```

Mount manually when needed.

---

## AWS EC2 Example

Assume:

```text
NFS Server private IP: 172.31.20.10
NFS Share: /nfs/share
Client Mount Point: /mnt/nfs-share
```

Run on the EC2 client:

```bash
sudo ./nfs-client-setup.sh 172.31.20.10 /nfs/share /mnt/nfs-share
```

### AWS Security Group Requirement

On the NFS server security group, allow:

```text
TCP 2049
Source: Client private IP or VPC CIDR
```

Example:

```text
Type: Custom TCP
Port: 2049
Source: 172.31.0.0/16
```

or:

```text
Type: Custom TCP
Port: 2049
Source: Client private IP
```

---

## What the Script Checks

### 1. OS Detection

It reads:

```bash
/etc/os-release
```

Then chooses the correct package:

```text
Ubuntu/Debian  -> nfs-common
RHEL-style     -> nfs-utils
```

---

### 2. Network Test

It tries:

```bash
ping -c 2 SERVER_IP
```

If ping fails, the script continues because some environments block ping.

---

### 3. NFS Export Discovery

It runs:

```bash
showmount -e SERVER_IP
```

Example:

```bash
showmount -e 172.27.100.62
```

Expected output:

```text
Export list for 172.27.100.62:
/nfs/share *
```

---

### 4. Mount Operation

It runs:

```bash
sudo mount -t nfs SERVER_IP:/nfs/share /mnt/nfs-share
```

---

### 5. Mount Verification

It checks:

```bash
df -h | grep nfs
mount | grep nfs
```

---

### 6. Write Test

It creates a test file:

```bash
/mnt/nfs-share/nfs-client-test-DATE.txt
```

If write fails, check server-side permissions and export options.

---

## Useful Client Commands

Check exports:

```bash
showmount -e SERVER_IP
```

Create mount point:

```bash
sudo mkdir -p /mnt/nfs-share
```

Mount manually:

```bash
sudo mount -t nfs SERVER_IP:/nfs/share /mnt/nfs-share
```

Check mount:

```bash
df -h | grep nfs
mount | grep nfs
```

Test write:

```bash
echo "Hello from NFS client" | sudo tee /mnt/nfs-share/test.txt
```

Unmount:

```bash
sudo umount /mnt/nfs-share
```

Mount again:

```bash
sudo mount -t nfs SERVER_IP:/nfs/share /mnt/nfs-share
```

---

## Common Issues and Fixes

| Problem | Possible Cause | Fix |
|---|---|---|
| `ping: socket: Operation not permitted` | WSL user permission issue | Use `sudo ping` |
| `showmount` fails | Server/export/firewall issue | Check server NFS service and `exportfs -v` |
| Mount fails | Firewall or Security Group blocked | Allow TCP 2049 |
| Permission denied while writing | Directory permission or root_squash | Check `/nfs/share` permissions |
| Client cannot reach server | Wrong IP or server stopped | Check server IP and WSL status |
| Works before restart but fails later | WSL IP changed | Check new IP with `ip -4 addr show eth0` |
| `/etc/fstab` mount fails | Old server IP | Update fstab with new IP |

---

## Server-Side Commands to Check

Run these on the NFS server:

```bash
sudo exportfs -v
showmount -e localhost
ip -4 addr show eth0
systemctl status nfs-kernel-server
```

On RHEL-based server:

```bash
sudo exportfs -v
showmount -e localhost
ip -4 addr show eth0
systemctl status nfs-server
```

---

## Best Practice

For WSL labs:

```bash
sudo ./nfs-client-setup.sh SERVER_IP
```

Avoid `--fstab` until you are comfortable.

For AWS or real Linux servers:

```bash
sudo ./nfs-client-setup.sh SERVER_PRIVATE_IP /nfs/share /mnt/nfs-share --fstab
```

Use `--fstab` only when the server IP is stable.

---

## Final Lab Example

Server:

```text
Ubuntu-24.04 WSL
/nfs/share
```

Client:

```text
AlmaLinux-9 WSL
/mnt/nfs-share
```

Command:

```bash
sudo ./nfs-client-setup.sh 172.27.100.62
```

Result:

```text
AlmaLinux mounts Ubuntu NFS share successfully.
Files created in /mnt/nfs-share appear on Ubuntu in /nfs/share.
```

---

## One-Line Summary

> This script automates NFS client setup by installing client tools, checking the NFS server, mounting the shared directory, verifying the mount, and optionally adding it to `/etc/fstab`.
