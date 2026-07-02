# Linux File System 

## 1. What is a Linux File System?

A **Linux file system** is the structure Linux uses to organize, store, find, protect, and manage files and directories.

In Linux, almost everything is treated like a file:

- Regular files
- Directories
- Devices
- Partitions
- Terminals
- Processes
- Logs
- Sockets
- Pipes

Simple definition:

> A Linux file system is the organized tree structure where Linux stores and manages files, directories, devices, programs, logs, and system configuration.

---

## 2. Why Do We Need a File System?

We need a file system because the operating system must know:

- Where files are stored
- How files are named
- Who owns the files
- Who can read, write, or execute them
- How much disk space is used
- Which files belong to users, applications, or the system
- Where devices, logs, commands, and configuration files are located

Without a file system, Linux cannot properly boot, store data, manage users, run services, or organize programs.

---

## 3. Linux File System Structure

Linux uses a **single directory tree**.

The top-level directory is:

```bash
/
```

This is called the **root directory**.

Everything starts from `/`.

Important point:

> Linux does not use drive letters like Windows C:, D:, E:.  
> Linux attaches everything under `/`.

---

## 4. Linux File System Directories — One-Line Definitions

| Directory | One-Line Definition |
|---|---|
| `/` | The root directory; the starting point of the entire Linux file system. |
| `/home` | Stores normal users’ personal home directories. |
| `/root` | The home directory of the root/admin user. |
| `/etc` | Stores system and service configuration files. |
| `/bin` | Contains essential user commands needed for basic system use. |
| `/sbin` | Contains system administration commands, mostly used by root. |
| `/usr` | Stores installed programs, libraries, documentation, and shared files. |
| `/usr/bin` | Contains most user commands and applications. |
| `/usr/sbin` | Contains non-essential system administration commands. |
| `/usr/lib` | Stores libraries required by programs. |
| `/usr/share` | Stores shared data such as manuals, icons, and documentation. |
| `/var` | Stores variable data that changes frequently. |
| `/var/log` | Stores system, service, security, and application log files. |
| `/var/www` | Common location for website files served by web servers. |
| `/var/cache` | Stores cached data used by applications and package managers. |
| `/tmp` | Stores temporary files created by users and applications. |
| `/dev` | Contains device files for disks, terminals, USB devices, and other hardware. |
| `/proc` | Virtual file system that shows live process and kernel information. |
| `/sys` | Virtual file system that shows kernel, hardware, and device information. |
| `/boot` | Stores files required to boot Linux, such as kernel and GRUB files. |
| `/mnt` | Temporary mount point used by administrators for manual mounting. |
| `/media` | Common mount point for removable devices like USB drives and CDs. |
| `/opt` | Stores optional or third-party software. |
| `/run` | Stores temporary runtime files created after system boot. |
| `/lib` | Contains essential shared libraries required by system commands. |
| `/lib64` | Contains 64-bit shared libraries on 64-bit systems. |
| `/srv` | Stores data served by services such as web, FTP, or other servers. |
| `/lost+found` | Stores recovered files after file system checks on ext file systems. |
| `/snap` | Stores snap package files on systems that use Snap. |
| `/selinux` | Stores SELinux-related virtual file system data, if enabled. |
| `/data` | Custom directory often created by admins for application or storage data. |
| `/backup` | Custom directory often created to store backup files. |

---

## 5. Absolute Path and Relative Path

### Absolute Path

An absolute path starts from `/`.

Examples:

```bash
/home/khalid/file.txt
/etc/passwd
/var/log/syslog
```

### Relative Path

A relative path starts from your current location.

Examples:

```bash
Documents/file.txt
../notes.txt
./script.sh
```

### Useful Commands

Check current directory:

```bash
pwd
```

Go to root directory:

```bash
cd /
```

Go to home directory:

```bash
cd ~
```

Go one directory back:

```bash
cd ..
```

Go to previous directory:

```bash
cd -
```

---

## 6. File Types in Linux

Linux has different file types.

Check file type:

```bash
ls -l
```

Example output:

```bash
-rw-r--r--  1 user user 100 file.txt
drwxr-xr-x  2 user user 4096 notes
lrwxrwxrwx  1 root root  10 link -> file.txt
```

The first character tells the file type.

| Symbol | Meaning |
|---|---|
| `-` | Regular file |
| `d` | Directory |
| `l` | Symbolic link |
| `c` | Character device |
| `b` | Block device |
| `p` | Pipe |
| `s` | Socket |

---

## 7. Regular File

### What?

A regular file contains data.

Examples:

```bash
notes.txt
script.sh
index.html
image.png
```

### Why?

Users and applications store data in files.

### How?

Create file:

```bash
touch file.txt
```

Write data:

```bash
echo "Hello Linux" > file.txt
```

Read file:

```bash
cat file.txt
```

---

## 8. Directory

### What?

A directory is like a folder that stores files and other directories.

### Why?

Directories help organize data.

### How?

Create directory:

```bash
mkdir myfolder
```

Go inside:

```bash
cd myfolder
```

Remove empty directory:

```bash
rmdir myfolder
```

Remove directory with files:

```bash
rm -r myfolder
```

---

## 9. Symbolic Link

### What?

A symbolic link is a shortcut to another file or directory.

### Why?

It helps access the same file from another location without copying it.

### How?

Create symbolic link:

```bash
ln -s /path/original /path/link
```

Example:

```bash
ln -s /var/www/html/index.html ~/index-link.html
```

Check:

```bash
ls -l
```

---

## 10. Hard Link

### What?

A hard link is another name for the same file data on disk.

### Why?

It allows the same file content to be accessed by multiple names.

### How?

Create hard link:

```bash
ln file1.txt file2.txt
```

Check inode:

```bash
ls -li
```

Important difference:

| Feature | Hard Link | Symbolic Link |
|---|---|---|
| Points to | Same inode/data | Path/name |
| Works across file systems | No | Yes |
| Works for directories | Usually no | Yes |
| Breaks if original deleted | No | Yes |
| Looks like shortcut | No | Yes |

---

## 11. Inode

### What?

An inode is a data structure that stores metadata about a file.

It stores:

- File type
- Permissions
- Owner
- Group
- Size
- Timestamps
- Disk block location
- Link count

It does not store the file name.

### Why?

Linux uses inodes to track files internally.

### How?

Check inode number:

```bash
ls -i file.txt
```

Check detailed inode information:

```bash
stat file.txt
```

Important point:

> File name is stored in the directory.  
> File metadata is stored in the inode.

---

## 12. File Permissions

Linux permissions control who can access files.

There are three permission types:

| Permission | Symbol | Number | Meaning |
|---|---|---|---|
| Read | `r` | 4 | View file content |
| Write | `w` | 2 | Modify file |
| Execute | `x` | 1 | Run file or enter directory |

There are three ownership levels:

| Level | Meaning |
|---|---|
| User | File owner |
| Group | Group owner |
| Others | Everyone else |

Example:

```bash
-rwxr-xr--
```

Breakdown:

```bash
- rwx r-x r--
  user group others
```

Meaning:

- User: read, write, execute
- Group: read, execute
- Others: read only

---

## 13. chmod

### What?

`chmod` changes file permissions.

### Why?

Administrators need to control file access.

### How?

Symbolic method:

```bash
chmod u+x script.sh
chmod g-w file.txt
chmod o-r file.txt
```

Numeric method:

```bash
chmod 755 script.sh
chmod 644 file.txt
chmod 700 private-folder
```

Common permissions:

| Permission | Meaning |
|---|---|
| `777` | Everyone can read, write, execute |
| `755` | Owner full, others read/execute |
| `644` | Owner read/write, others read |
| `600` | Owner read/write only |
| `700` | Owner full only |

Important warning:

> Avoid using `chmod 777` unless it is only for temporary practice.  
> It is unsafe in real production systems.

---

## 14. chown

### What?

`chown` changes file owner and group.

### Why?

Files must belong to the correct user and group for security and service access.

### How?

Change owner:

```bash
sudo chown khalid file.txt
```

Change owner and group:

```bash
sudo chown khalid:developers file.txt
```

Change recursively:

```bash
sudo chown -R khalid:developers /project
```

Check:

```bash
ls -l file.txt
```

---

## 15. chgrp

### What?

`chgrp` changes only the group owner.

### Why?

Sometimes only group ownership needs to be changed.

### How?

```bash
sudo chgrp developers file.txt
```

Recursive:

```bash
sudo chgrp -R developers /project
```

---

## 16. Disk Partitions and Mounting

### What is a partition?

A partition is a section of a disk.

Example disk:

```bash
/dev/sda
```

Example partition:

```bash
/dev/sda1
```

### Why?

Partitions help separate system files, user data, swap, and other storage areas.

### How?

Check disks and partitions:

```bash
lsblk
```

Check mounted file systems:

```bash
df -h
```

Check file system type:

```bash
df -Th
```

---

## 17. Mount Point

### What?

A mount point is a directory where a file system is attached.

Example:

```bash
/mnt/data
```

### Why?

Linux accesses disks and partitions by mounting them into the directory tree.

### How?

Create mount point:

```bash
sudo mkdir /mnt/data
```

Mount partition:

```bash
sudo mount /dev/sdb1 /mnt/data
```

Check:

```bash
df -h
```

Unmount:

```bash
sudo umount /mnt/data
```

---

## 18. `/etc/fstab`

### What?

`/etc/fstab` is the file system table.

It controls which file systems mount automatically at boot.

### Why?

Without `/etc/fstab`, manually mounted disks may not mount after reboot.

### How?

View:

```bash
cat /etc/fstab
```

Example entry:

```bash
UUID=xxxx-xxxx /mnt/data ext4 defaults 0 2
```

Check UUID:

```bash
blkid
```

Test fstab:

```bash
sudo mount -a
```

Important warning:

> Always test `/etc/fstab` using `sudo mount -a` before rebooting.  
> A wrong fstab entry can cause boot problems.

---

## 19. Common Linux File System Types

| File System | Use |
|---|---|
| ext4 | Common Linux file system |
| xfs | Common on RHEL/CentOS/Enterprise Linux |
| btrfs | Advanced Linux file system with snapshots |
| swap | Used as virtual memory |
| vfat | USB/FAT file systems |
| ntfs | Windows file system |
| nfs | Network file system |
| tmpfs | Temporary memory-based file system |

Check file system type:

```bash
df -Th
```

---

## 20. ext4

### What?

`ext4` is a popular Linux file system.

### Why?

It is stable, reliable, and commonly used on Ubuntu and many Linux systems.

### How?

Create ext4 file system:

```bash
sudo mkfs.ext4 /dev/sdb1
```

Mount it:

```bash
sudo mount /dev/sdb1 /mnt/data
```

---

## 21. xfs

### What?

`xfs` is a high-performance file system commonly used in RHEL-based systems.

### Why?

It handles large files and large file systems very well.

### How?

Create xfs file system:

```bash
sudo mkfs.xfs /dev/sdb1
```

Mount it:

```bash
sudo mount /dev/sdb1 /mnt/data
```

---

## 22. tmpfs

### What?

`tmpfs` is a temporary file system stored in memory.

### Why?

It is fast and useful for temporary runtime files.

### How?

Check tmpfs:

```bash
df -h -t tmpfs
```

Example locations:

```bash
/run
/dev/shm
```

---

## 23. NFS

### What?

NFS stands for Network File System.

It allows one Linux system to share a directory with another Linux system over the network.

### Why?

NFS is useful for shared storage between servers.

### How?

Mount NFS share:

```bash
sudo mount server-ip:/shared-folder /mnt/nfs-share
```

Check:

```bash
df -h
```

---

## 24. Important File System Commands

### `pwd`

Shows current directory.

```bash
pwd
```

### `ls`

Lists files.

```bash
ls
ls -l
ls -la
ls -lh
```

| Command | Meaning |
|---|---|
| `ls` | List files |
| `ls -l` | Long listing |
| `ls -a` | Show hidden files |
| `ls -h` | Human-readable size |
| `ls -R` | Recursive listing |

### `cd`

Changes directory.

```bash
cd /etc
cd ..
cd ~
cd -
```

### `mkdir`

Creates directory.

```bash
mkdir notes
mkdir -p linux/filesystem/basics
```

### `touch`

Creates empty file or updates timestamp.

```bash
touch file.txt
```

### `cp`

Copies files or directories.

```bash
cp file1.txt file2.txt
cp -r dir1 dir2
```

### `mv`

Moves or renames files.

```bash
mv old.txt new.txt
mv file.txt /tmp/
```

### `rm`

Removes files or directories.

```bash
rm file.txt
rm -r folder
```

Dangerous command:

```bash
rm -rf /
```

Important warning:

> Never run destructive commands without understanding them.

### `find`

Searches files and directories.

Find by name:

```bash
find /home -name "file.txt"
```

Find all `.log` files:

```bash
find /var/log -name "*.log"
```

Find files larger than 100MB:

```bash
find / -type f -size +100M 2>/dev/null
```

Find directories:

```bash
find /home -type d -name "notes"
```

### `du`

Shows disk usage of files/directories.

```bash
du -sh /home/khalid
du -sh *
```

### `df`

Shows disk space usage of mounted file systems.

```bash
df -h
df -Th
```

### `stat`

Shows detailed file information.

```bash
stat file.txt
```

### `file`

Shows file type.

```bash
file file.txt
file script.sh
file image.png
```

---

## 25. Hidden Files

### What?

Hidden files start with a dot `.`.

Examples:

```bash
.bashrc
.profile
.ssh
.gitconfig
```

### Why?

They are usually configuration files.

### How?

Show hidden files:

```bash
ls -a
```

Show long format:

```bash
ls -la
```

---

## 26. File Timestamps

Linux files have timestamps.

Check:

```bash
stat file.txt
```

Common timestamps:

| Timestamp | Meaning |
|---|---|
| Access | Last time file was read |
| Modify | Last time file content changed |
| Change | Last time metadata changed |
| Birth | Creation time, if supported |

---

## 27. File Ownership

Every file has:

- Owner user
- Owner group

Check:

```bash
ls -l
```

Example:

```bash
-rw-r--r-- 1 khalid developers 100 file.txt
```

Meaning:

- Owner: `khalid`
- Group: `developers`

---

## 28. Special Permissions

Linux has special permissions:

| Permission | Symbol | Use |
|---|---|---|
| SUID | `s` | Run file as file owner |
| SGID | `s` | Run file as group or inherit group on directory |
| Sticky Bit | `t` | Protect files in shared directory |

### Sticky Bit Example

Check `/tmp`:

```bash
ls -ld /tmp
```

Output:

```bash
drwxrwxrwt
```

Set sticky bit:

```bash
chmod +t shared-folder
```

Numeric:

```bash
chmod 1777 shared-folder
```

### SGID Directory Example

Set SGID:

```bash
chmod g+s project
```

New files inside inherit the group of the directory.

### SUID Example

Check passwd command:

```bash
ls -l /usr/bin/passwd
```

Example:

```bash
-rwsr-xr-x
```

This allows normal users to change their password while the command runs with root-level permission for required tasks.

---

## 29. File System Troubleshooting

### Issue 1: No Space Left on Device

Error:

```bash
No space left on device
```

Check disk:

```bash
df -h
```

Check large directories:

```bash
sudo du -sh /* 2>/dev/null
```

Find large files:

```bash
sudo find / -type f -size +500M 2>/dev/null
```

Fix:

- Delete unnecessary logs
- Clean package cache
- Move files
- Increase disk size
- Rotate logs

---

### Issue 2: Permission Denied

Error:

```bash
Permission denied
```

Check permissions:

```bash
ls -l file.txt
```

Check directory permissions:

```bash
ls -ld folder
```

Fix permissions:

```bash
chmod u+r file.txt
chmod u+x script.sh
```

Fix ownership:

```bash
sudo chown user:group file.txt
```

---

### Issue 3: Cannot Execute Script

Error:

```bash
Permission denied
```

Check:

```bash
ls -l script.sh
```

Fix:

```bash
chmod +x script.sh
./script.sh
```

Or run with bash:

```bash
bash script.sh
```

---

### Issue 4: Mount Not Working

Check devices:

```bash
lsblk
```

Check file system:

```bash
sudo blkid
```

Try mounting:

```bash
sudo mount /dev/sdb1 /mnt/data
```

Check error messages:

```bash
dmesg | tail
```

Check fstab:

```bash
cat /etc/fstab
```

Test fstab:

```bash
sudo mount -a
```

---

### Issue 5: File Deleted But Space Not Freed

Sometimes a process keeps using a deleted file.

Check deleted open files:

```bash
sudo lsof | grep deleted
```

Fix:

- Restart the related service
- Stop the process
- Reboot if needed

---

### Issue 6: Too Many Files / Inode Full

Check inode usage:

```bash
df -i
```

Fix:

- Delete unnecessary small files
- Clean cache
- Clean old sessions/logs

---

## 30. Practical Lab

### Lab 1: Explore Root File System

```bash
cd /
pwd
ls -l
```

Question:

```text
Which directories do you see under / ?
```

---

### Lab 2: Create Files and Directories

```bash
mkdir ~/filesystem-practice
cd ~/filesystem-practice
touch file1.txt
echo "Linux file system practice" > file1.txt
cat file1.txt
```

---

### Lab 3: Permissions Practice

```bash
touch script.sh
echo 'echo "Hello Linux"' > script.sh
ls -l script.sh
chmod +x script.sh
./script.sh
```

---

### Lab 4: Ownership Practice

```bash
sudo useradd -m ali
sudo chown ali:ali file1.txt
ls -l file1.txt
```

---

### Lab 5: Find Command Practice

```bash
find ~ -name "file1.txt"
find ~ -type f -name "*.txt"
```

---

### Lab 6: Disk Usage Practice

```bash
df -h
du -sh ~
du -sh ~/filesystem-practice
```

---

### Lab 7: Inode Practice

```bash
ls -i file1.txt
stat file1.txt
```

---

## 31. Admin-Level Important Files

| File | Purpose |
|---|---|
| `/etc/passwd` | User account information |
| `/etc/shadow` | Encrypted password information |
| `/etc/group` | Group information |
| `/etc/fstab` | Auto mount file systems |
| `/etc/hosts` | Local hostname resolution |
| `/etc/hostname` | System hostname |
| `/etc/resolv.conf` | DNS resolver config |
| `/var/log/syslog` | Ubuntu system logs |
| `/var/log/messages` | RHEL system logs |
| `/var/log/auth.log` | Ubuntu authentication logs |
| `/var/log/secure` | RHEL authentication logs |

---

## 32. Ubuntu vs RHEL Notes

| Topic | Ubuntu/Debian | RHEL/CentOS/Rocky/Alma |
|---|---|---|
| Main log | `/var/log/syslog` | `/var/log/messages` |
| Auth log | `/var/log/auth.log` | `/var/log/secure` |
| Common file system | ext4 | xfs |
| Web user | www-data | apache or nginx |
| Package manager | apt | dnf/yum |

---

## 33. Interview Questions

### Q1. What is the root directory in Linux?

Answer:

`/` is the root directory. It is the starting point of the Linux file system.

---

### Q2. What is the difference between `/root` and `/`?

Answer:

`/` is the root directory of the whole file system.  
`/root` is the home directory of the root user.

---

### Q3. What is `/etc` used for?

Answer:

`/etc` stores system and service configuration files.

---

### Q4. What is `/var/log` used for?

Answer:

`/var/log` stores log files used for troubleshooting.

---

### Q5. What is an inode?

Answer:

An inode stores file metadata such as permissions, owner, size, timestamps, and block location.

---

### Q6. What is a mount point?

Answer:

A mount point is a directory where another file system is attached.

---

### Q7. What is the difference between `df` and `du`?

Answer:

`df` shows disk usage of mounted file systems.  
`du` shows disk usage of files and directories.

---

### Q8. What is the difference between hard link and soft link?

Answer:

A hard link points to the same inode.  
A soft link points to a file path.

---

### Q9. What is `/tmp` used for?

Answer:

`/tmp` stores temporary files.

---

### Q10. What is `/dev` used for?

Answer:

`/dev` stores device files.

---

## 34. Quick Revision Table

| Topic | Quick Meaning |
|---|---|
| `/` | Starting point of Linux file system |
| Path | Location of a file or directory |
| Absolute path | Path starting from `/` |
| Relative path | Path starting from current location |
| Inode | Metadata record of a file |
| Permission | Rules for read, write, and execute |
| Ownership | User and group that own a file |
| Mount point | Directory where storage is attached |
| `df` | Shows file system disk usage |
| `du` | Shows directory/file size |
| `chmod` | Changes permissions |
| `chown` | Changes owner/group |
| `lsblk` | Shows disks and partitions |
| `fstab` | Controls auto-mounting at boot |

---

## 35. Final Summary

The Linux file system is a single tree that starts from `/`.

Everything in Linux is organized under this root directory.

Important idea:

> Everything in Linux is organized under `/`, including users, commands, configuration files, logs, devices, applications, and mounted storage.

Final one-line definition:

> The Linux file system is a single directory tree starting from `/`, used to organize users, files, commands, devices, logs, configuration, and mounted storage.
