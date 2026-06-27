# Linux Troubleshooting Scenario

# Scenario 12 -- Deleted User Completely by Mistake

## Problem

An administrator accidentally runs:

``` bash
sudo userdel -r ali
```

The account, home directory, and mail spool are removed.

The administrator now needs to recover:

-   UID
-   Home directory
-   Ownership
-   Password

------------------------------------------------------------------------

# Goal

Recover as much information as possible and recreate the user account
correctly.

------------------------------------------------------------------------

# Why Use the Isolation Method?

Before recreating the account, determine what information still exists.

Possible questions:

-   Does the account still exist?
-   Are files still present?
-   Is the old UID known?
-   Is there a backup?
-   Can the original password be recovered?

------------------------------------------------------------------------

# Step 1 -- Gather Information

## Check 1 -- Does the User Exist?

``` bash
id ali
```

Expected:

``` text
id: 'ali': no such user
```

------------------------------------------------------------------------

## Check 2 -- Search for Remaining Files

If the old UID is known:

``` bash
find / -uid 1002 2>/dev/null
```

Or if the username still resolves:

``` bash
find / -user ali 2>/dev/null
```

------------------------------------------------------------------------

## Check 3 -- Look for Backups

Search for:

-   Home directory backups
-   Tar archives
-   Snapshots
-   Backup software

Without a backup, deleted personal files may not be recoverable.

------------------------------------------------------------------------

# Root Cause

The administrator executed:

``` bash
sudo userdel -r ali
```

This removes:

-   User account
-   Home directory
-   Mail spool

Files outside the home directory may still exist.

------------------------------------------------------------------------

# Recovery

## Recover the UID

If documented previously:

``` text
UID = 1002
```

Recreate the account:

``` bash
sudo useradd -u 1002 -m ali
```

If the UID is unknown, Linux assigns a new one.

------------------------------------------------------------------------

## Recover the Home Directory

If a backup exists:

``` bash
sudo cp -a /backup/ali /home/ali
```

Otherwise:

``` bash
sudo mkdir /home/ali
sudo cp -a /etc/skel/. /home/ali/
```

------------------------------------------------------------------------

## Restore Ownership

``` bash
sudo chown -R ali:ali /home/ali
```

Restore ownership on recovered files if necessary:

``` bash
sudo chown -R ali:ali /path/to/restored/files
```

------------------------------------------------------------------------

## Recover the Password

Passwords cannot be recovered because only password hashes are stored.

Set a new password:

``` bash
sudo passwd ali
```

------------------------------------------------------------------------

# Verification

``` bash
id ali
grep "^ali" /etc/passwd
ls -ld /home/ali
su - ali
```

------------------------------------------------------------------------

# Recoverability

  Item             Recoverable
  ---------------- ----------------------
  Username         Yes
  UID              Yes, if known
  Home directory   Yes, if backed up
  Ownership        Yes
  Password         No -- reset required

------------------------------------------------------------------------

# Final Command Set

``` bash
id ali
find / -uid 1002 2>/dev/null

sudo useradd -u 1002 -m ali
sudo cp -a /etc/skel/. /home/ali/
sudo chown -R ali:ali /home/ali
sudo passwd ali

su - ali
```

------------------------------------------------------------------------

# Troubleshooting Flow

``` text
User deleted
      │
      ▼
Verify account removed
      │
      ▼
Search for remaining files
      │
      ▼
Determine old UID
      │
      ▼
Recreate user
      │
      ▼
Restore home directory
      │
      ▼
Restore ownership
      │
      ▼
Set new password
      │
      ▼
Verify login
      │
      ▼
Document incident
```

------------------------------------------------------------------------

# Incident Documentation

``` text
Incident ID:
USR-012

Problem:
User was accidentally deleted.

Root Cause:
Administrator executed userdel -r.

Resolution:
Recreated the account, restored the home directory, fixed ownership, and reset the password.

Verification:
User logged in successfully.

Preventive Action:
Back up user data before deleting accounts and verify the command before pressing Enter.
```

------------------------------------------------------------------------

# RHCSA Tip

Always verify whether the user's data has been backed up before using
`userdel -r`.

------------------------------------------------------------------------

# Interview Tip

Explain that passwords cannot be recovered; they must be reset. Recovery
focuses on restoring the account, UID, files, and ownership.

------------------------------------------------------------------------

# Roman Urdu Summary

Agar `userdel -r` se user delete ho jaye to pehle dekhein kya backup ya
files abhi bhi mojood hain. Agar purana UID maloom ho to usi UID ke sath
user recreate karein, home directory restore karein, ownership theek
karein aur naya password set karein.

------------------------------------------------------------------------

# One-Line Summary

A deleted Linux user can often be recreated with the same UID and
restored files if backups exist, but the original password cannot be
recovered and must be reset.
