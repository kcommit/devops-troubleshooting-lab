# Linux Troubleshooting Scenario

# Scenario 16 -- Home Directory Not Created

## Problem

The administrator creates a user:

``` bash
sudo useradd ali
```

The `-m` option was forgotten.

The user account exists, but no home directory was created.

Example:

``` bash
grep "^ali:" /etc/passwd
```

``` text
ali:x:1002:1002::/home/ali:/bin/bash
```

Checking the home directory:

``` bash
ls -ld /home/ali
```

Output:

``` text
ls: cannot access '/home/ali': No such file or directory
```

## Goal

Create the missing home directory and make it usable.

------------------------------------------------------------------------

# Why Use the Isolation Method?

Do not recreate the user account.

First verify:

-   Does the user exist?
-   Is the home path correct?
-   Does the directory exist?
-   Are ownership and permissions correct?

------------------------------------------------------------------------

# Step 1 -- Gather Information

## Verify the user exists

``` bash
id ali
```

## Verify the configured home directory

``` bash
grep "^ali:" /etc/passwd
```

Expected:

``` text
ali:x:1002:1002::/home/ali:/bin/bash
```

## Verify the directory exists

``` bash
ls -ld /home/ali
```

If it reports "No such file or directory", continue with recovery.

------------------------------------------------------------------------

# Root Cause

The administrator used:

``` bash
sudo useradd ali
```

instead of:

``` bash
sudo useradd -m ali
```

The account was created, but the home directory was not.

------------------------------------------------------------------------

# Recovery

## Create the directory

``` bash
sudo mkdir /home/ali
```

## Restore default files

``` bash
sudo cp -a /etc/skel/. /home/ali/
```

## Restore ownership

``` bash
sudo chown -R ali:ali /home/ali
```

## Set secure permissions

``` bash
sudo chmod 700 /home/ali
```

------------------------------------------------------------------------

# Verification

``` bash
ls -ld /home/ali
ls -la /home/ali
su - ali
pwd
```

Expected:

``` text
/home/ali
```

------------------------------------------------------------------------

# Final Command Set

``` bash
id ali
grep "^ali:" /etc/passwd
ls -ld /home/ali

sudo mkdir /home/ali
sudo cp -a /etc/skel/. /home/ali/
sudo chown -R ali:ali /home/ali
sudo chmod 700 /home/ali

su - ali
pwd
```

------------------------------------------------------------------------

# Troubleshooting Flow

``` text
User created
      │
      ▼
Check account exists
      │
      ▼
Check home path
      │
      ▼
Home directory missing?
      │
      ▼
Create directory
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
Verify login
```

------------------------------------------------------------------------

# Incident Documentation

``` text
Incident ID:
USR-016

Problem:
User account created without a home directory.

Root Cause:
The -m option was omitted from useradd.

Resolution:
Created the home directory, copied /etc/skel, restored ownership and permissions.

Verification:
User logged in successfully and landed in /home/ali.

Preventive Action:
Use `useradd -m` when creating users that require home directories.
```

------------------------------------------------------------------------

# RHCSA Tip

Remember that `useradd` does not always create a home directory unless
configured to do so. On exams and production systems, verify whether
`/home/username` exists after creating a user.

------------------------------------------------------------------------

# Interview Tip

Explain that you would not delete and recreate the account. Instead, you
would create the missing home directory, populate it from `/etc/skel`,
restore ownership, verify permissions, and test the login.

------------------------------------------------------------------------

# Roman Urdu Summary

Agar `useradd` chalate waqt `-m` bhool jayein, to user account ban jata
hai lekin home directory nahi banti. `/home/ali` create karein,
`/etc/skel` copy karein, ownership aur permissions theek karein, phir
login verify karein.

------------------------------------------------------------------------

# One-Line Summary

If `useradd` is run without `-m`, recover by creating the home
directory, copying `/etc/skel`, fixing ownership and permissions, and
verifying the user's login.
