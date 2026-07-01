# NFS in Linux — Study Notes

## 1. What is NFS?

**NFS** stands for **Network File System**.

NFS is a Linux/Unix file-sharing protocol that allows one system to share a directory over the network, and other systems can mount that shared directory as if it is a local folder.

### One-line definition

> **NFS allows Linux systems to share and access files over a network as if they are local files.**

---

## 2. Simple Real-Life Example

Imagine you have two Linux machines:

| Machine | Role | Purpose |
|---|---|---|
| Server A | NFS Server | Shares a directory |
| Server B | NFS Client | Mounts and uses that shared directory |

Example:

```text
NFS Server:
  /nfs/share

NFS Client:
  /mnt/nfs-share
```

The client sees `/mnt/nfs-share`, but the actual files are stored on the NFS server inside `/nfs/share`.

---

## 3. Why Do We Need NFS?

NFS is used when multiple Linux systems need access to the same files.

Common use cases:

```text
Central shared storage
Shared home directories
Backup directories
Application shared data
Web server shared content
DevOps lab shared folders
Kubernetes persistent storage
```

---

## 4. NFS Basic Architecture

```text
+-------------------+        Network        +-------------------+
|   NFS Server      |  ------------------->  |   NFS Client      |
|                   |                       |                   |
| /nfs/share        |                       | /mnt/nfs-share    |
| Shared directory  |                       | Mounted directory |
+-------------------+                       +-------------------+
```

### Main idea

```text
Server exports the directory.
Client mounts the exported directory.
Client uses it like a local folder.
```

---

## 5. Important NFS Terms

| Term | Meaning |
|---|---|
| NFS Server | The system that shares the directory |
| NFS Client | The system that mounts and accesses the shared directory |
| Export | A directory shared through NFS |
| Mount | Attaching a remote shared directory to a local directory |
| Mount Point | Local directory where the NFS share is attached |
| `/etc/exports` | Main NFS server configuration file |
| `exportfs` | Command used to manage exported directories |
| `showmount` | Command used to view available NFS shares |
| `/etc/fstab` | File used for permanent mounts |

---

# 6. NFS Server Setup

Note:
> Before starting the setup, check network connectivity between both servers using ping.

The following example uses a Linux machine as the NFS server.

## Step 1: Install NFS Package

### On RHEL / CentOS / Fedora

```bash
sudo dnf install nfs-utils -y
```

### On Ubuntu / Debian

```bash
sudo apt install nfs-kernel-server -y
```

---

## Step 2: Create Shared Directory

```bash
sudo mkdir -p /nfs/share
```

For practice lab:

```bash
sudo chmod 777 /nfs/share
```

### Important note

`chmod 777` is okay for practice only.

In production, avoid open permissions. Use proper user ownership, groups, and secure permissions.

Example:

```bash
sudo chown -R nobody:nobody /nfs/share
sudo chmod -R 755 /nfs/share
```

---

## Step 3: Configure `/etc/exports`

Open the file:

```bash
sudo vim /etc/exports
```

Add this line:

```bash
/nfs/share 192.168.1.0/24(rw,sync,no_subtree_check)
```

### Explanation

| Part | Meaning |
|---|---|
| `/nfs/share` | Directory being shared |
| `192.168.1.0/24` | Network allowed to access the share |
| `rw` | Read and write access |
| `sync` | Writes changes safely before replying |
| `no_subtree_check` | Avoids subtree checking problems |

---

## Step 4: Reload Exports

```bash
sudo exportfs -rav
```

### Explanation

| Option | Meaning |
|---|---|
| `-r` | Re-export all directories |
| `-a` | Apply to all exports |
| `-v` | Verbose output |

Check exported directories:

```bash
sudo exportfs -v
```

---

## Step 5: Start and Enable NFS Service

### On RHEL / CentOS / Fedora

```bash
sudo systemctl enable --now nfs-server
```

Check status:

```bash
sudo systemctl status nfs-server
```

### On Ubuntu / Debian

```bash
sudo systemctl enable --now nfs-kernel-server
```

Check status:

```bash
sudo systemctl status nfs-kernel-server
```

---

## Step 6: Configure Firewall

### RHEL / CentOS / Fedora

```bash
sudo firewall-cmd --permanent --add-service=nfs
sudo firewall-cmd --permanent --add-service=mountd
sudo firewall-cmd --permanent --add-service=rpc-bind
sudo firewall-cmd --reload
```

### Ubuntu / Debian with UFW

Example:

```bash
sudo ufw allow from 192.168.1.0/24 to any port nfs
```

---

# 7. NFS Client Setup

## Step 1: Install NFS Client Package

### On RHEL / CentOS / Fedora

```bash
sudo dnf install nfs-utils -y
```

### On Ubuntu / Debian

```bash
sudo apt install nfs-common -y
```

---

## Step 2: Check Available NFS Shares

From the client machine:

```bash
showmount -e SERVER_IP
```

Example:

```bash
showmount -e 192.168.1.10
```

Possible output:

```text
Export list for 192.168.1.10:
/nfs/share 192.168.1.0/24
```

---

## Step 3: Create Mount Point

```bash
sudo mkdir -p /mnt/nfs-share
```

---

## Step 4: Mount NFS Share

```bash
sudo mount 192.168.1.10:/nfs/share /mnt/nfs-share
```

Check mounted file systems:

```bash
df -h
```

or:

```bash
mount | grep nfs
```

---

## Step 5: Test NFS Share

On the client:

```bash
cd /mnt/nfs-share
touch test-file.txt
echo "Hello from NFS client" | sudo tee hello.txt
```

On the server:

```bash
ls -l /nfs/share
cat /nfs/share/hello.txt
```

If you can see the files on the server, NFS is working.

---

# 8. Permanent NFS Mount Using `/etc/fstab`

If you mount manually, the mount disappears after reboot.

To make it permanent, edit `/etc/fstab` on the client:

```bash
sudo vim /etc/fstab
```

Add this line:

```text
192.168.1.10:/nfs/share /mnt/nfs-share nfs defaults 0 0
```

Then test:

```bash
sudo mount -a
```

Check:

```bash
df -h
```

---

## `/etc/fstab` Line Explanation

```text
192.168.1.10:/nfs/share /mnt/nfs-share nfs defaults 0 0
```

| Field | Meaning |
|---|---|
| `192.168.1.10:/nfs/share` | Remote NFS share |
| `/mnt/nfs-share` | Local mount point |
| `nfs` | File system type |
| `defaults` | Default mount options |
| `0` | Dump backup option disabled |
| `0` | File system check disabled |

---

# 9. Important NFS Commands

| Command | Purpose |
|---|---|
| `sudo dnf install nfs-utils -y` | Install NFS on RHEL-based systems |
| `sudo apt install nfs-common -y` | Install NFS client on Ubuntu/Debian |
| `sudo apt install nfs-kernel-server -y` | Install NFS server on Ubuntu/Debian |
| `sudo exportfs -rav` | Reload NFS exports |
| `sudo exportfs -v` | Show exported directories |
| `showmount -e SERVER_IP` | Show NFS shares from server |
| `sudo mount SERVER:/share /mnt` | Mount NFS share |
| `df -h` | Check mounted file systems |
| `mount | grep nfs` | Check NFS mounts |
| `sudo umount /mnt/nfs-share` | Unmount NFS share |
| `sudo systemctl status nfs-server` | Check NFS server status on RHEL |
| `sudo systemctl status nfs-kernel-server` | Check NFS server status on Ubuntu |

---

# 10. Common `/etc/exports` Options

| Option | Meaning |
|---|---|
| `rw` | Read and write access |
| `ro` | Read-only access |
| `sync` | Safer writes; server writes data before replying |
| `async` | Faster but less safe |
| `no_subtree_check` | Avoids subtree checking issues |
| `root_squash` | Maps remote root user to anonymous user |
| `no_root_squash` | Allows remote root user to act as root on share |
| `all_squash` | Maps all users to anonymous user |
| `anonuid` | Sets anonymous user UID |
| `anongid` | Sets anonymous group GID |

---

## Important Security Note

Avoid this in production unless you fully understand the risk:

```text
no_root_squash
```

Why?

Because it can allow the root user from the client machine to have root-level access on the NFS share.

---

# 11. NFS Permission Concept

NFS permissions depend on two things:

```text
1. Export permissions in /etc/exports
2. Linux file permissions on the shared directory
```

Example:

```bash
/nfs/share 192.168.1.0/24(rw,sync,no_subtree_check)
```

This allows read/write from the network side.

But if the Linux directory permission does not allow writing, the client still cannot write.

So always check:

```bash
ls -ld /nfs/share
```

---

# 12. Unmount NFS Share

```bash
sudo umount /mnt/nfs-share
```

If the mount is busy:

```bash
sudo lsof +f -- /mnt/nfs-share
```

or:

```bash
sudo fuser -vm /mnt/nfs-share
```

Then close the process using it and try again:

```bash
sudo umount /mnt/nfs-share
```

---

# 13. Troubleshooting NFS

## Problem 1: `showmount: command not found`

### Cause

NFS client package is missing.

### Fix on RHEL

```bash
sudo dnf install nfs-utils -y
```

### Fix on Ubuntu

```bash
sudo apt install nfs-common -y
```

---

## Problem 2: `mount.nfs: access denied by server`

### Possible causes

```text
Client IP is not allowed in /etc/exports
Wrong network range
Exports not reloaded
Firewall is blocking NFS
```

### Fix

Check `/etc/exports`:

```bash
cat /etc/exports
```

Reload exports:

```bash
sudo exportfs -rav
```

Check server exports:

```bash
sudo exportfs -v
```

From client:

```bash
showmount -e SERVER_IP
```

---

## Problem 3: Permission denied while creating file

### Possible causes

```text
Directory permission issue
Wrong ownership
root_squash behavior
SELinux issue on RHEL
```

### Check permissions

```bash
ls -ld /nfs/share
```

Practice fix:

```bash
sudo chmod 777 /nfs/share
```

Better production-style fix:

```bash
sudo chown -R user:group /nfs/share
sudo chmod -R 775 /nfs/share
```

---

## Problem 4: NFS service not running

### RHEL

```bash
sudo systemctl status nfs-server
sudo systemctl restart nfs-server
```

### Ubuntu

```bash
sudo systemctl status nfs-kernel-server
sudo systemctl restart nfs-kernel-server
```

---

## Problem 5: Firewall blocking NFS

### RHEL

```bash
sudo firewall-cmd --list-all
sudo firewall-cmd --permanent --add-service=nfs
sudo firewall-cmd --permanent --add-service=mountd
sudo firewall-cmd --permanent --add-service=rpc-bind
sudo firewall-cmd --reload
```

---

# 14. NFS vs Samba

| Feature | NFS | Samba |
|---|---|---|
| Best for | Linux/Unix systems | Windows/Linux mixed systems |
| Protocol | NFS | SMB/CIFS |
| Common use | Linux shared storage | Windows file sharing |
| Authentication | UID/GID based | User/password based |
| Example use | Linux servers sharing directories | Windows accessing Linux shares |

---

# 15. Quick Lab Flow

## Server Side

```bash
sudo dnf install nfs-utils -y
sudo mkdir -p /nfs/share
sudo chmod 777 /nfs/share
echo "/nfs/share 192.168.1.0/24(rw,sync,no_subtree_check)" | sudo tee -a /etc/exports
sudo exportfs -rav
sudo systemctl enable --now nfs-server
sudo exportfs -v
```

## Client Side

```bash
sudo dnf install nfs-utils -y
showmount -e SERVER_IP
sudo mkdir -p /mnt/nfs-share
sudo mount SERVER_IP:/nfs/share /mnt/nfs-share
df -h
touch /mnt/nfs-share/test-file.txt
```

---

# 16. Interview Questions

## Q1. What is NFS?

NFS stands for Network File System. It allows Linux systems to share directories over a network.

## Q2. What is the main NFS configuration file?

```text
/etc/exports
```

## Q3. What is the use of `exportfs -rav`?

It reloads and applies NFS export configurations.

## Q4. What is the use of `showmount -e SERVER_IP`?

It shows the exported NFS shares available from the NFS server.

## Q5. How do you mount an NFS share?

```bash
sudo mount SERVER_IP:/shared/path /local/mountpoint
```

## Q6. How do you make an NFS mount permanent?

By adding the NFS mount entry in `/etc/fstab`.

## Q7. What is `root_squash`?

`root_squash` maps the root user from the client to an anonymous user on the NFS server for security.

## Q8. What is the difference between `rw` and `ro`?

| Option | Meaning |
|---|---|
| `rw` | Read and write |
| `ro` | Read only |

---

# 17. Quick Summary

```text
NFS = Network File System

Server:
  Shares/export directory using /etc/exports

Client:
  Mounts shared directory using mount command

Main file:
  /etc/exports

Main commands:
  exportfs -rav
  exportfs -v
  showmount -e SERVER_IP
  mount SERVER:/share /mnt
  umount /mnt
```

---

# 18. Final Memory Line

> **NFS is a Linux network file-sharing system where one server exports a directory and clients mount it like a local folder.**

---

# 19. NFS Issue and Solution: Different Results in `/mnt/nfs-share`

## Topic

NFS mounted folder looked like it was **not syncing**, but after running `pwd`, `pwd -P`, and entering the mount point again, the files appeared correctly.

---

## Lab Context

In this lab, NFS was configured like this:

| Machine | Role | Path |
|---|---|---|
| NFS Server | Shares directory | `/nfs/share` |
| NFS Client | Mounts server share | `/mnt/nfs-share` |

The client mounted the server directory using NFS:

```bash
192.168.1.251:/nfs/share  ->  /mnt/nfs-share
```

---

## The Confusion

On the client, this command showed files from the NFS share:

```bash
ls -l /mnt/nfs-share/
```

Example output:

```text
total 8
-rw-r--r--. 1 root root 14 Jul  1 08:23 server-file-2.txt
-rw-r--r--. 1 root root 12 Jul  1 08:14 server-file.txt
-rw-r--r--. 1 root root  0 Jul  1 08:00 server.txt
```

But then this command showed a different result:

```bash
ll
```

Example earlier output:

```text
total 4
-rw-r--r--. 1 root root 4 Jul  1 08:13 abc.txt
```

This made it look like NFS was **not syncing**.

---

## Why the Results Were Different

The command:

```bash
ls -l /mnt/nfs-share/
```

checks this exact directory:

```text
/mnt/nfs-share
```

But the command:

```bash
ll
```

is only an alias for:

```bash
ls -l
```

It checks the **current directory** where you are standing.

So if you are not really inside:

```text
/mnt/nfs-share
```

then `ll` can show different files.

---

## Important Difference

| Command | What it checks |
|---|---|
| `ls -l /mnt/nfs-share/` | Exact NFS mount directory |
| `ll` | Current directory only |
| `pwd` | Shows current directory path |
| `pwd -P` | Shows real physical path, resolving symbolic links |
| `findmnt /mnt/nfs-share` | Confirms whether the directory is an NFS mount |

---

## The Fix

The issue was solved by confirming the real location and entering the mount point again.

Commands used:

```bash
pwd
pwd -P
cd /
cd /mnt/nfs-share/
ls -l
```

Output:

```text
[root@LabPractice nfs-share]# pwd
/mnt/nfs-share

[root@LabPractice nfs-share]# pwd -P
/mnt/nfs-share

[root@LabPractice nfs-share]# cd /

[root@LabPractice /]# cd /mnt/nfs-share/

[root@LabPractice nfs-share]# ls -l
total 8
-rw-r--r--. 1 root root 14 Jul  1 08:23 server-file-2.txt
-rw-r--r--. 1 root root 12 Jul  1 08:14 server-file.txt
-rw-r--r--. 1 root root  0 Jul  1 08:00 server.txt
```

Now the result is correct because the command is being run from the real NFS mount directory:

```text
/mnt/nfs-share
```

---

## Why It Looked Like Sync After These Commands

It looked like NFS started syncing after these commands, but actually NFS was already working.

The real problem was that the command `ll` may have been run from a different directory before.

After running:

```bash
cd /
cd /mnt/nfs-share/
```

you entered the correct NFS mount path again.

Now:

```bash
ll
```

and:

```bash
ls -l /mnt/nfs-share/
```

show the same result because both are checking the same directory.

---

## NFS Is Not Copy-Sync

NFS is **not** like:

- `rsync`
- Google Drive
- OneDrive
- Dropbox
- backup synchronization software

NFS is **shared storage**.

That means the server has the real folder:

```text
/nfs/share
```

The client sees that same folder through the mount point:

```text
/mnt/nfs-share
```

The client is not keeping a separate copy. It is looking directly at the server share over the network.

---

## What `sync` Means in NFS

In `/etc/exports`, you may see this line:

```bash
/nfs/share 192.168.1.194(rw,sync,no_subtree_check)
```

The option:

```text
sync
```

does **not** mean folder synchronization.

It means:

```text
When the client writes data, the NFS server safely writes the data before confirming success.
```

So `sync` means **safe write confirmation**, not copy synchronization.

---

## Simple Diagram

```text
NFS Server
192.168.1.251

Real folder:
 /nfs/share
     |
     | shared by NFS
     |
NFS Client
192.168.1.194

Mounted view:
 /mnt/nfs-share
```

Both paths show the same shared data, but they are not two separate folders being synchronized.

---

## Correct Troubleshooting Commands

### On the NFS client

Check current location:

```bash
pwd
pwd -P
```

Check if you are inside the mounted NFS share:

```bash
findmnt .
```

Check the NFS mount directly:

```bash
findmnt /mnt/nfs-share
```

List the mounted share:

```bash
ls -l /mnt/nfs-share
```

Go to the mount point again:

```bash
cd /
cd /mnt/nfs-share
ll
```

---

## Proper NFS Test

### Step 1: Create file on server

On NFS server:

```bash
echo "from server" | sudo tee /nfs/share/server-test.txt
```

### Step 2: Check on client

On NFS client:

```bash
ls -l /mnt/nfs-share
cat /mnt/nfs-share/server-test.txt
```

### Step 3: Create file on client

On NFS client:

```bash
echo "from client" | sudo tee /mnt/nfs-share/client-test.txt
```

### Step 4: Check on server

On NFS server:

```bash
ls -l /nfs/share
cat /nfs/share/client-test.txt
```

If both sides can see the files, NFS is working.

---

## Important Warning

If you delete files from the client mount:

```bash
rm -rf /mnt/nfs-share/*
```

you are deleting files from the server share:

```text
/nfs/share
```

Because NFS is shared storage.

Memory line:

```text
Deleting from the NFS client mount deletes from the NFS server share.
```

---

## Final Conclusion

The issue was not NFS sync.

The issue was:

```text
Different commands were checking different directories.
```

The solution was:

```bash
pwd -P
cd /
cd /mnt/nfs-share
ls -l
```

Final memory line:

```text
NFS is shared storage, not copy synchronization.
sync means safe write confirmation.
Different results usually mean you are checking different directories.
```
