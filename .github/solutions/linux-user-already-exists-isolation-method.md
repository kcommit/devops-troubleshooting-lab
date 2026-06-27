# Linux Troubleshooting Scenario

# Scenario 6 -- User Already Exists

## Problem

The administrator runs:

``` bash
sudo useradd ali
```

Output:

``` text
useradd: user 'ali' already exists
```

## Goal

Instead of creating the user again, investigate the existing account and
find:

-   UID
-   GID
-   Home directory
-   Groups
-   Login shell

------------------------------------------------------------------------

# Why Use the Isolation Method?

Do not delete or recreate the account immediately.

First identify what already exists and verify the account configuration.

------------------------------------------------------------------------

# Step 1 -- Gather Information

## Check 1 -- Does the User Exist?

``` bash
id ali
```

Example:

``` text
uid=1002(ali) gid=1002(ali) groups=1002(ali),27(sudo),100(users)
```

This confirms the account exists.

------------------------------------------------------------------------

## Check 2 -- Find the Home Directory and Shell

``` bash
grep "^ali:" /etc/passwd
```

Example:

``` text
ali:x:1002:1002::/home/ali:/bin/bash
```

Field breakdown:

``` text
username : password : UID : GID : comment : home : shell
```

------------------------------------------------------------------------

## Check 3 -- View Group Membership

``` bash
groups ali
```

or

``` bash
id ali
```

Example:

``` text
ali : ali sudo users
```

------------------------------------------------------------------------

## Check 4 -- Verify the Home Directory

``` bash
ls -ld /home/ali
```

Expected:

``` text
drwx------ ali ali
```

------------------------------------------------------------------------

## Check 5 -- Verify the Login Shell

``` bash
cat /etc/shells
```

Ensure the configured shell (for example `/bin/bash`) is listed.

------------------------------------------------------------------------

# Root Cause

The account already exists in the system. Running `useradd` again fails
because Linux does not allow duplicate usernames.

------------------------------------------------------------------------

# Solution

Do **not** recreate the account.

Instead, inspect the existing account using:

``` bash
id ali
grep "^ali:" /etc/passwd
groups ali
ls -ld /home/ali
```

Modify the account only if required.

------------------------------------------------------------------------

# Verification

Confirm:

-   Correct UID
-   Correct home directory
-   Correct groups
-   Valid login shell

Test login:

``` bash
su - ali
```

------------------------------------------------------------------------

# Final Command Set

``` bash
id ali
grep "^ali:" /etc/passwd
groups ali
ls -ld /home/ali
cat /etc/shells
su - ali
```

------------------------------------------------------------------------

# Troubleshooting Flow

``` text
useradd reports "user already exists"
          │
          ▼
Verify user with id
          │
          ▼
Inspect /etc/passwd
          │
          ▼
Check groups
          │
          ▼
Check home directory
          │
          ▼
Check login shell
          │
          ▼
Verify login
```

------------------------------------------------------------------------

# Incident Documentation

``` text
Incident ID:
USR-006

Problem:
Attempt to create an existing user.

Root Cause:
The account already existed.

Resolution:
Verified the existing account instead of creating a duplicate.

Verification:
UID, home directory, groups, shell and login were confirmed.

Preventive Action:
Always verify whether a user already exists before running useradd.
```

------------------------------------------------------------------------

# RHCSA Tip

When `useradd` reports "user already exists", inspect the account rather
than deleting or recreating it.

------------------------------------------------------------------------

# Interview Tip

Explain how you would gather information first using `id`,
`/etc/passwd`, `groups`, and the user's home directory before deciding
on any corrective action.

------------------------------------------------------------------------

# Roman Urdu Summary

Agar `useradd` kahe:

``` text
user already exists
```

to naya user create karne ki koshish na karein. Pehle `id`,
`/etc/passwd`, `groups` aur home directory check karein, phir zarurat ho
to account modify karein.

------------------------------------------------------------------------

# One-Line Summary

A "user already exists" error means the account is already present;
investigate its UID, home directory, groups, and shell before taking
further action.
