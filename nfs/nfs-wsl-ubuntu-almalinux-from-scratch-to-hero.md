# NFS Lab From Scratch to Hero
## Ubuntu WSL Server + AlmaLinux WSL Client

> **Lab Result:** Successful  
> **Server:** Ubuntu-24.04 WSL  
> **Client:** AlmaLinux-9 WSL  
> **Topic:** NFS Server and Client Setup in Linux

---

# 1. What is NFS?

**NFS** stands for **Network File System**.

NFS allows one Linux machine to share a directory over the network, and another Linux machine can mount that directory as if it is a local folder.

## One-line definition

> **NFS allows Linux systems to share and access files over the network like local files.**

---

# 2. Lab Architecture

In this lab, we used two WSL distributions on the same Windows laptop.

```text
Windows Laptop
│
├── Ubuntu-24.04 WSL
│   └── NFS Server
│       └── Shared Directory: /nfs/share
│
└── AlmaLinux-9 WSL
    └── NFS Client
        └── Mount Point: /mnt/nfs-share
```

## Final working flow

```text
AlmaLinux Client
/mnt/nfs-share
      |
      | NFS mount
      |
Ubuntu Server
/nfs/share
```

When a file is created in:

```text
/mnt/nfs-share
```

it appears on the server in:

```text
/nfs/share
```

---

# 3. Why We Used Ubuntu and AlmaLinux

| System | Role | Reason |
|---|---|---|
| Ubuntu-24.04 WSL | NFS Server | Uses `apt` and `nfs-kernel-server` |
| AlmaLinux-9 WSL | NFS Client | RHEL-like system using `dnf` and `nfs-utils` |

This is a great practice lab because it gives experience with both Debian/Ubuntu and RHEL-style Linux.

---

# 4. Important NFS Terms

| Term | Meaning |
|---|---|
| NFS Server | Machine that shares/exports a directory |
| NFS Client | Machine that mounts the shared directory |
| Export | A directory shared by the server |
| Mount | Attach remote shared directory to local folder |
| `/etc/exports` | Main NFS server configuration file |
| `exportfs` | Command used to reload/check exports |
| `showmount` | Command used to view NFS shares |
| `/mnt/nfs-share` | Client-side mount directory |
| `/nfs/share` | Server-side real shared directory |

---

# 5. Install AlmaLinux-9 WSL

## PowerShell command

```powershell
wsl --list --online
```

Your available distros included:

```text
Ubuntu
Ubuntu-26.04
Ubuntu-24.04
Ubuntu-22.04
Debian
AlmaLinux-8
AlmaLinux-9
AlmaLinux-10
FedoraLinux-44
FedoraLinux-43
```

## Install AlmaLinux-9

```powershell
wsl --install AlmaLinux-9
```

During setup, create a user:

```text
Enter new UNIX username: khan
```

Check installed WSL distros:

```powershell
wsl -l -v
```

Example output:

```text
NAME                   STATE           VERSION
Ubuntu-24.04           Stopped         2
AlmaLinux-9            Running         2
```

---

# 6. Important WSL Note

If the server WSL is stopped, the client cannot ping or connect to it.

## Check WSL status

```powershell
wsl -l -v
```

Both should be running:

```text
Ubuntu-24.04     Running
AlmaLinux-9      Running
```

## Start Ubuntu server WSL

```powershell
wsl -d Ubuntu-24.04
```

## Start AlmaLinux client WSL

Open another PowerShell tab:

```powershell
wsl -d AlmaLinux-9
```

---

# 7. Server Side Setup: Ubuntu WSL

## Step 1: Install NFS server package

Correct command:

```bash
sudo apt update
sudo apt install nfs-kernel-server -y
```

## Mistake and Fix

Wrong command:

```bash
sudo apt install nfs-kernal-server -y
```

Error:

```text
E: Unable to locate package nfs-kernal-server
```

Reason:

```text
kernal is wrong spelling
kernel is correct spelling
```

Correct command:

```bash
sudo apt install nfs-kernel-server -y
```

---

# 8. Create Shared Directory on Server

On Ubuntu server:

```bash
sudo mkdir -p /nfs/share
sudo chmod 777 /nfs/share
```

## Why `chmod 777`?

For a beginner lab, it makes testing easy.

Production warning:

```text
chmod 777 is not recommended for production.
Use proper user, group, and permissions in real environments.
```

---

# 9. Configure `/etc/exports`

Check the file:

```bash
ls -l /etc/exports
```

Open it:

```bash
sudo vim /etc/exports
```

For simple lab, add:

```text
/nfs/share *(rw,sync,no_subtree_check)
```

## Meaning

| Part | Meaning |
|---|---|
| `/nfs/share` | Directory being shared |
| `*` | Allow all clients |
| `rw` | Read and write access |
| `sync` | Write safely before replying |
| `no_subtree_check` | Avoid subtree checking issues |

## More secure example

If your server IP is:

```text
172.27.100.62/20
```

then the network range is:

```text
172.27.96.0/20
```

You can use:

```text
/nfs/share 172.27.96.0/20(rw,sync,no_subtree_check)
```

For this lab, the working export was:

```text
/nfs/share *(rw,sync,no_subtree_check)
```

---

# 10. Reload NFS Exports

Correct command:

```bash
sudo exportfs -rav
```

Check exports:

```bash
sudo exportfs -v
```

Working output:

```text
/nfs/share      <world>(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,root_squash,no_all_squash)
```

## Mistake and Fix

Wrong command:

```bash
sudo exports -rav
```

Error:

```text
sudo: exports: command not found
```

Reason:

| Word | Meaning |
|---|---|
| `exports` | Config file/concept |
| `exportfs` | Actual command |

Correct command:

```bash
sudo exportfs -rav
```

---

# 11. Check NFS Service on Ubuntu

Correct command:

```bash
sudo systemctl status nfs-kernel-server
```

or:

```bash
sudo systemctl status nfs-server
```

## Mistake and Fix

Wrong command:

```bash
sudo sysctl status nfs-kernel-server
```

Error:

```text
sysctl: cannot stat /proc/sys/status: No such file or directory
```

Reason:

| Command | Purpose |
|---|---|
| `systemctl` | Manage services |
| `sysctl` | Manage kernel parameters |

Correct:

```bash
sudo systemctl status nfs-kernel-server
```

---

# 12. Verify Server Export Locally

On Ubuntu server:

```bash
showmount -e localhost
```

Working output:

```text
Export list for localhost:
/nfs/share *
```

This confirms the server can see its own NFS export.

---

# 13. Find Ubuntu Server IP

On Ubuntu server:

```bash
ip -4 addr show eth0
```

Working output:

```text
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    inet 172.27.100.62/20 brd 172.27.111.255 scope global eth0
       valid_lft forever preferred_lft forever
```

Server IP:

```text
172.27.100.62
```

Important:

```text
WSL IP can change after restart.
Always check the IP again before mounting.
```

---

# 14. Client Side Setup: AlmaLinux WSL

Open AlmaLinux:

```powershell
wsl -d AlmaLinux-9
```

Install NFS client tools:

```bash
sudo dnf install nfs-utils -y
```

Working output:

```text
Package nfs-utils-1:2.5.4-42.el9_8.aarch64 is already installed.
Nothing to do.
Complete!
```

---

# 15. Ping Server from AlmaLinux Client

Normal ping gave this error:

```bash
ping -c 4 172.27.100.62
```

Error:

```text
ping: socket: Operation not permitted
```

This is a permission issue in AlmaLinux WSL.

## Fix

Use sudo:

```bash
sudo ping -c 4 172.27.100.62
```

Working output:

```text
PING 172.27.100.62 (172.27.100.62) 56(84) bytes of data.
64 bytes from 172.27.100.62: icmp_seq=1 ttl=64 time=1.91 ms
64 bytes from 172.27.100.62: icmp_seq=2 ttl=64 time=0.063 ms
64 bytes from 172.27.100.62: icmp_seq=3 ttl=64 time=0.101 ms
64 bytes from 172.27.100.62: icmp_seq=4 ttl=64 time=0.138 ms

--- 172.27.100.62 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss
```

This confirms network connectivity.

---

# 16. Check NFS Share from AlmaLinux Client

On AlmaLinux client:

```bash
showmount -e 172.27.100.62
```

Working output:

```text
Export list for 172.27.100.62:
/nfs/share *
```

This confirms the client can discover the NFS share.

---

# 17. Create Mount Point on AlmaLinux Client

```bash
sudo mkdir -p /mnt/nfs-share
```

This is the client-side folder where the NFS share will be mounted.

---

# 18. Mount NFS Share

On AlmaLinux client:

```bash
sudo mount -t nfs 172.27.100.62:/nfs/share /mnt/nfs-share
```

## Command breakdown

| Part | Meaning |
|---|---|
| `sudo mount` | Mount a filesystem |
| `-t nfs` | Filesystem type is NFS |
| `172.27.100.62:/nfs/share` | Server IP and exported directory |
| `/mnt/nfs-share` | Local mount point on client |

---

# 19. Verify Mount

On AlmaLinux client:

```bash
df -h | grep nfs
```

Working output:

```text
172.27.100.62:/nfs/share 1007G   13G  944G   2% /mnt/nfs-share
```

Also check:

```bash
mount | grep nfs
```

Working output:

```text
172.27.100.62:/nfs/share on /mnt/nfs-share type nfs4
```

This confirms the share is mounted using NFSv4.

---

# 20. Test File from AlmaLinux Client

On AlmaLinux client:

```bash
echo "Hello from AlmaLinux NFS client" | sudo tee /mnt/nfs-share/alma-test.txt
```

Output:

```text
Hello from AlmaLinux NFS client
```

---

# 21. Verify File on Ubuntu Server

On Ubuntu server:

```bash
ls -l /nfs/share
```

Working output:

```text
total 4
-rw-r--r-- 1 nobody nogroup 32 Jun 30 01:56 alma-test.txt
```

Read file:

```bash
cat /nfs/share/alma-test.txt
```

Working output:

```text
Hello from AlmaLinux NFS client
```

This confirms the NFS setup is successful.

---

# 22. Why Owner Shows `nobody nogroup`

On the Ubuntu server, file owner appeared as:

```text
nobody nogroup
```

Reason:

The export includes:

```text
root_squash
```

When the AlmaLinux client writes a file using `sudo`, the client user is root.

NFS does not allow remote root to behave as server root by default. It maps remote root to anonymous user, usually:

```text
nobody
```

This is normal and secure.

## Important security concept

| Option | Meaning |
|---|---|
| `root_squash` | Converts remote root to anonymous user |
| `no_root_squash` | Allows remote root as root; risky |
| `rw` | Read/write allowed |
| `sync` | Safe writes |
| `no_subtree_check` | Avoid subtree checking problems |

---

# 23. Final Lab Proof

## Ubuntu Server

```bash
sudo exportfs -v
```

Output:

```text
/nfs/share <world>(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,root_squash,no_all_squash)
```

```bash
showmount -e localhost
```

Output:

```text
Export list for localhost:
/nfs/share *
```

```bash
cat /nfs/share/alma-test.txt
```

Output:

```text
Hello from AlmaLinux NFS client
```

## AlmaLinux Client

```bash
sudo ping -c 4 172.27.100.62
```

Output:

```text
4 packets transmitted, 4 received, 0% packet loss
```

```bash
showmount -e 172.27.100.62
```

Output:

```text
Export list for 172.27.100.62:
/nfs/share *
```

```bash
df -h | grep nfs
```

Output:

```text
172.27.100.62:/nfs/share 1007G 13G 944G 2% /mnt/nfs-share
```

---

# 24. Unmount NFS Share

On AlmaLinux client:

```bash
sudo umount /mnt/nfs-share
```

Check:

```bash
df -h | grep nfs
```

If no output, it is unmounted.

---

# 25. Mount Again

On AlmaLinux client:

```bash
sudo mount -t nfs 172.27.100.62:/nfs/share /mnt/nfs-share
```

Check:

```bash
df -h | grep nfs
```

---

# 26. Permanent Mount Using `/etc/fstab`

If you want AlmaLinux client to mount automatically, edit:

```bash
sudo vim /etc/fstab
```

Add:

```text
172.27.100.62:/nfs/share /mnt/nfs-share nfs defaults 0 0
```

Test:

```bash
sudo mount -a
```

Check:

```bash
df -h | grep nfs
```

## Important WSL warning

WSL IP may change after restart.

If the Ubuntu server IP changes, the `/etc/fstab` entry must be updated.

For WSL labs, manual mounting is safer for practice.

---

# 27. Common Mistakes and Fixes

## Mistake 1: Wrong package name

Wrong:

```bash
sudo apt install nfs-kernal-server -y
```

Correct:

```bash
sudo apt install nfs-kernel-server -y
```

---

## Mistake 2: Wrong command `exports`

Wrong:

```bash
sudo exports -rav
```

Correct:

```bash
sudo exportfs -rav
```

---

## Mistake 3: Confusing `sysctl` and `systemctl`

Wrong:

```bash
sudo sysctl status nfs-kernel-server
```

Correct:

```bash
sudo systemctl status nfs-kernel-server
```

---

## Mistake 4: Ping without sudo on AlmaLinux WSL

Wrong:

```bash
ping -c 4 172.27.100.62
```

Error:

```text
ping: socket: Operation not permitted
```

Correct:

```bash
sudo ping -c 4 172.27.100.62
```

---

## Mistake 5: Server WSL stopped

If Ubuntu server is stopped, client cannot connect.

Check:

```powershell
wsl -l -v
```

Start Ubuntu:

```powershell
wsl -d Ubuntu-24.04
```

---

## Mistake 6: Using old WSL IP

WSL IP can change.

Always check on Ubuntu server:

```bash
ip -4 addr show eth0
```

Then use the current IP on AlmaLinux client.

---

# 28. Troubleshooting Checklist

## On Ubuntu Server

```bash
sudo systemctl status nfs-kernel-server
sudo exportfs -v
showmount -e localhost
ip -4 addr show eth0
ls -ld /nfs/share
```

## On AlmaLinux Client

```bash
sudo ping -c 4 SERVER_IP
showmount -e SERVER_IP
sudo mkdir -p /mnt/nfs-share
sudo mount -t nfs SERVER_IP:/nfs/share /mnt/nfs-share
df -h | grep nfs
mount | grep nfs
```

---

# 29. Quick Full Command Summary

## Ubuntu Server

```bash
sudo apt update
sudo apt install nfs-kernel-server -y

sudo mkdir -p /nfs/share
sudo chmod 777 /nfs/share

sudo vim /etc/exports
```

Add:

```text
/nfs/share *(rw,sync,no_subtree_check)
```

Apply:

```bash
sudo exportfs -rav
sudo exportfs -v
showmount -e localhost
ip -4 addr show eth0
```

---

## AlmaLinux Client

```bash
sudo dnf install nfs-utils -y

sudo ping -c 4 172.27.100.62
showmount -e 172.27.100.62

sudo mkdir -p /mnt/nfs-share
sudo mount -t nfs 172.27.100.62:/nfs/share /mnt/nfs-share

df -h | grep nfs
mount | grep nfs

echo "Hello from AlmaLinux NFS client" | sudo tee /mnt/nfs-share/alma-test.txt
```

---

## Ubuntu Server Verification

```bash
ls -l /nfs/share
cat /nfs/share/alma-test.txt
```

Expected:

```text
Hello from AlmaLinux NFS client
```

---

# 30. Interview-Style Explanation

## What did we do in this lab?

We configured an NFS server on Ubuntu WSL and exported `/nfs/share`. Then we used AlmaLinux WSL as an NFS client, installed `nfs-utils`, discovered the exported share using `showmount`, mounted it at `/mnt/nfs-share`, and verified that a file created on the client appeared on the server.

## Why was `root_squash` important?

Because the client wrote the file using `sudo`, NFS mapped the remote root user to `nobody` on the server. This prevents remote root from having root-level control over the server’s shared directory.

## What commands prove NFS is working?

```bash
showmount -e SERVER_IP
df -h | grep nfs
mount | grep nfs
cat /nfs/share/alma-test.txt
```

---

# 31. Final Memory Lines

```text
NFS Server:
Ubuntu exports /nfs/share.

NFS Client:
AlmaLinux mounts the share at /mnt/nfs-share.

Proof:
File created on AlmaLinux appeared inside /nfs/share on Ubuntu.

Result:
NFS server-client lab completed successfully.
```

---

# 32. One-Line Final Summary

> **In this lab, Ubuntu WSL worked as the NFS server and AlmaLinux WSL worked as the NFS client; the client mounted `/nfs/share` successfully and wrote a file that appeared on the server.**
