# NFS Server Auto Setup Script

This README explains how to use the NFS server setup script:

```text
nfs-server-setup-auto-network.sh
```

The script is designed to automatically configure an NFS server on common Linux systems.

---

## What This Script Does

The script automatically:

```text
Detects the Linux OS
Supports Ubuntu/Debian
Supports RHEL/AlmaLinux/Rocky/Fedora
Installs the correct NFS package
Creates the NFS shared directory
Backs up /etc/exports
Adds the NFS export line
Starts/enables the NFS service
Reloads exports using exportfs
Attempts basic firewall configuration
Detects server IP address
Can auto-calculate the allowed network CIDR
Prints client-side mount commands
```

---

## Supported Operating Systems

| OS Family | Examples | Package Used | Service Name |
|---|---|---|---|
| Debian-based | Ubuntu, Debian | `nfs-kernel-server` | `nfs-kernel-server` |
| RHEL-based | RHEL, AlmaLinux, Rocky, Fedora | `nfs-utils` | `nfs-server` |

---

## Supported Environments

| Environment | Supported? | Notes |
|---|---:|---|
| WSL | Yes | Good for local lab practice |
| AWS EC2 | Yes | Security Group must allow NFS |
| VirtualBox/VMware VMs | Yes | VM network must allow communication |
| Bare-metal Linux | Yes | Firewall/network must allow NFS |
| Two physical laptops with WSL | Limited | WSL NAT can make networking difficult |

---

## Important Note

The script configures the **Linux NFS server**, but it cannot fully control external networking.

For example:

```text
AWS Security Groups
Cloud firewalls
Router/firewall rules
WSL NAT behavior
VM network mode
```

These must allow the client to reach the server.

---

## Downloaded Script Name

```text
nfs-server-setup-auto-network.sh
```

---

## Make Script Executable

```bash
chmod +x nfs-server-setup-auto-network.sh
```

---

## Basic Usage

Run with default values:

```bash
sudo ./nfs-server-setup-auto-network.sh
```

Default behavior:

```text
Share directory: /nfs/share
Allowed network: auto
Export options: rw,sync,no_subtree_check
```

---

## Usage Format

```bash
sudo ./nfs-server-setup-auto-network.sh [SHARE_DIRECTORY] [ALLOWED_CLIENT_OR_NETWORK]
```

| Argument | Meaning | Default |
|---|---|---|
| `$1` | NFS share directory | `/nfs/share` |
| `$2` | Allowed client/network | `auto` |

---

## What `auto` Means

When you use:

```bash
sudo ./nfs-server-setup-auto-network.sh /nfs/share auto
```

The script detects the server IP and subnet.

Example:

```text
Server IP: 172.27.100.62/20
Auto network: 172.27.96.0/20
```

Then it configures `/etc/exports` like:

```text
/nfs/share 172.27.96.0/20(rw,sync,no_subtree_check)
```

This is better than using `*`.

---

## WSL Example

For your Ubuntu WSL NFS server:

```bash
sudo ./nfs-server-setup-auto-network.sh /nfs/share auto
```

Then on the client WSL, for example AlmaLinux:

```bash
sudo dnf install nfs-utils -y
showmount -e SERVER_IP
sudo mkdir -p /mnt/nfs-share
sudo mount -t nfs SERVER_IP:/nfs/share /mnt/nfs-share
df -h | grep nfs
```

Example:

```bash
showmount -e 172.27.100.62
sudo mount -t nfs 172.27.100.62:/nfs/share /mnt/nfs-share
```

---

## AWS EC2 Example

For AWS, it is often better to manually pass the VPC CIDR or client private IP.

### Example using VPC CIDR

```bash
sudo ./nfs-server-setup-auto-network.sh /nfs/share "172.31.0.0/16"
```

### Example using one client private IP

```bash
sudo ./nfs-server-setup-auto-network.sh /nfs/share "172.31.25.40"
```

### AWS Security Group Requirement

For NFSv4, allow inbound:

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

## Home VM Lab Example

For VirtualBox or VMware with local network:

```bash
sudo ./nfs-server-setup-auto-network.sh /nfs/share "192.168.1.0/24"
```

Then on client:

```bash
showmount -e SERVER_IP
sudo mkdir -p /mnt/nfs-share
sudo mount -t nfs SERVER_IP:/nfs/share /mnt/nfs-share
```

---

## Simple Practice Only

You can allow all clients using:

```bash
sudo ./nfs-server-setup-auto-network.sh /nfs/share "*"
```

This creates:

```text
/nfs/share *(rw,sync,no_subtree_check)
```

Warning:

```text
Using * is okay for practice labs only.
Do not use it in production.
```

---

## Script Output

At the end, the script prints a summary like:

```text
NFS SERVER SETUP COMPLETED
OS                 : Ubuntu 24.04
Interface          : eth0
Server CIDR        : 172.27.100.62/20
Server IP          : 172.27.100.62
Share Directory    : /nfs/share
Allowed Client     : 172.27.96.0/20
Export Options     : rw,sync,no_subtree_check
NFS Service        : nfs-kernel-server
```

It also prints client-side commands.

---

## Verify on Server

Run:

```bash
sudo exportfs -v
showmount -e localhost
systemctl status nfs-kernel-server
```

On RHEL-based systems:

```bash
sudo exportfs -v
showmount -e localhost
systemctl status nfs-server
```

---

## Client Commands

### Ubuntu/Debian Client

```bash
sudo apt install nfs-common -y
```

### RHEL/AlmaLinux/Rocky/Fedora Client

```bash
sudo dnf install nfs-utils -y
```

### Mount from Client

```bash
sudo mkdir -p /mnt/nfs-share
sudo mount -t nfs SERVER_IP:/nfs/share /mnt/nfs-share
```

Check:

```bash
df -h | grep nfs
mount | grep nfs
```

Test:

```bash
echo "Hello from NFS client" | sudo tee /mnt/nfs-share/test.txt
```

Verify on server:

```bash
ls -l /nfs/share
cat /nfs/share/test.txt
```

---

## Unmount from Client

```bash
sudo umount /mnt/nfs-share
```

---

## Common Issues

| Problem | Cause | Fix |
|---|---|---|
| Client cannot ping server | Server stopped or network issue | Start server and check IP |
| `showmount` fails | NFS service/export issue | Check `exportfs -v` and service status |
| Mount fails | Firewall/security group issue | Allow TCP 2049 |
| Permission denied | Linux permissions or export options | Check `/nfs/share` permissions and `/etc/exports` |
| WSL IP changed | WSL restarted | Re-run script or check `ip -4 addr show eth0` |
| AWS client cannot connect | Security Group blocked | Allow TCP 2049 from client/VPC |

---

## Important WSL Reminder

WSL IP can change after restart.

Check current IP:

```bash
ip -4 addr show eth0
```

If the IP changes, re-run:

```bash
sudo ./nfs-server-setup-auto-network.sh /nfs/share auto
```

---

## Security Notes

For practice:

```text
chmod 777 /nfs/share
```

is acceptable.

For production, avoid open permissions. Use proper ownership and groups.

Example:

```bash
sudo chown -R nfsnobody:nfsnobody /nfs/share
sudo chmod -R 755 /nfs/share
```

Also avoid:

```text
*
no_root_squash
```

unless you understand the security risk.

---

## Best Practice

For labs:

```bash
sudo ./nfs-server-setup-auto-network.sh /nfs/share auto
```

For AWS:

```bash
sudo ./nfs-server-setup-auto-network.sh /nfs/share "CLIENT_PRIVATE_IP"
```

or:

```bash
sudo ./nfs-server-setup-auto-network.sh /nfs/share "VPC_CIDR"
```

For production:

```text
Use specific client IPs
Use restricted permissions
Avoid *
Avoid no_root_squash
Control firewall/security groups
```

---

## Final Summary

```text
This script configures the Linux NFS server automatically.
It works on Ubuntu/Debian and RHEL-style systems.
It can be used in WSL, AWS EC2, VMs, and real Linux servers.
Network/firewall/security group access must still be configured correctly.
```

---

## One-Line Definition

> This script automates NFS server setup by detecting the OS, installing the correct package, exporting a directory, and showing client mount commands.
