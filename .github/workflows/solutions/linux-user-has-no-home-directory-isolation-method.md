# Linux Troubleshooting Scenario

# Scenario 5 -- User Has No Home Directory

## Problem

Verify the user account:

``` bash
grep "^ali" /etc/passwd
```

Output:

``` text
ali:x:1002:1002::/home/ali:/bin/bash
```

The account exists and the configured home directory is:

``` text
/home/ali
```

However:

``` bash
ls /home/ali
```

Output:

``` text
ls: cannot access '/home/ali': No such file or directory
```

## Goal

Recover the missing home directory without recreating the user account.

------------------------------------------------------------------------

# Why Use the Isolation Method?

Do not assume the user account is missing.

Verify each possible cause before making changes.

Possible causes:

-   User account deleted
-   Home directory missing
-   Wrong home directory path
-   Wrong ownership
-   Wrong permissions

------------------------------------------------------------------------

# Step 1 -- Gather Information

## Check 1 -- Does the User Exist?

``` bash
id ali
```

If the user exists, continue.

------------------------------------------------------------------------

## Check 2 -- Verify the Home Directory Path

``` bash
grep "^ali" /etc/passwd
```

Expected:

``` text
ali:x:1002:1002::/home/ali:/bin/bash
```

------------------------------------------------------------------------

## Check 3 -- Does the Directory Exist?

``` bash
ls -ld /home/ali
```

If you receive:

``` text
No such file or directory
```

then the home directory is missing.

------------------------------------------------------------------------

# Root Cause

The user account still exists, but the home directory was accidentally
deleted.

------------------------------------------------------------------------

# Solution

## Create the Home Directory

``` bash
sudo mkdir /home/ali
```

## Restore Default Files

``` bash
sudo cp -a /etc/skel/. /home/ali/
```

## Restore Ownership

``` bash
sudo chown -R ali:ali /home/ali
```

## Set Secure Permissions

``` bash
sudo chmod 700 /home/ali
```

------------------------------------------------------------------------

# Verification

``` bash
ls -ld /home/ali
ls -la /home/ali
su - ali
```

Expected:

``` text
ali@hostname:~$
```

------------------------------------------------------------------------

# Final Command Set

``` bash
id ali
grep "^ali" /etc/passwd
ls -ld /home/ali

sudo mkdir /home/ali
sudo cp -a /etc/skel/. /home/ali/
sudo chown -R ali:ali /home/ali
sudo chmod 700 /home/ali

ls -la /home/ali
su - ali
```

------------------------------------------------------------------------

# Troubleshooting Flow

``` text
User cannot access home
        │
        ▼
Does the user exist?
        │
       Yes
        │
        ▼
Check /etc/passwd
        │
        ▼
Does /home/ali exist?
        │
   No ─────► Create directory
        │
        ▼
Copy /etc/skel
        │
        ▼
Fix ownership
        │
        ▼
Fix permissions
        │
        ▼
Test login
        │
        ▼
Document
```

------------------------------------------------------------------------

# Incident Documentation

``` text
Incident ID:
USR-005

Problem:
User account existed but the home directory was missing.

Root Cause:
The home directory was accidentally deleted.

Resolution:
Recreated the home directory, restored default files, fixed ownership and permissions.

Verification:
User logged in successfully.

Preventive Action:
Back up user data and verify before deleting directories.
```

------------------------------------------------------------------------

# RHCSA Tip

Never recreate a user account if only the home directory is missing.
Recover the directory instead.

------------------------------------------------------------------------

# Interview Tip

Explain how you verify the account first, then restore the home
directory, copy `/etc/skel`, fix ownership, verify permissions, and test
the login.

------------------------------------------------------------------------

# Roman Urdu Summary

Agar `/etc/passwd` mein `/home/ali` configured ho lekin directory exist
na kare, to user ko dobara create mat karein. Sirf home directory
recreate karein, `/etc/skel` copy karein, ownership aur permissions
theek karein, aur login verify karein.

------------------------------------------------------------------------

# One-Line Summary

If a user's account exists but the home directory is missing, recreate
the directory, restore `/etc/skel`, fix ownership and permissions, then
verify the login.
