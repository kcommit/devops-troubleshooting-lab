# Linux Troubleshooting Scenario

# Scenario 13 -- Wrong UID

## Problem

An administrator changes a user's UID:

``` bash
sudo usermod -u 2000 ali
```

Later, many files appear owned by a numeric UID instead of the username.

Example:

``` bash
ls -l /home/ali
```

``` text
-rw-r--r-- 1 1002 1002 report.txt
```

## Goal

Restore the correct ownership of all affected files.

------------------------------------------------------------------------

# Why Use the Isolation Method?

Linux stores file ownership by **UID**, not by username.

Changing a user's UID does **not** automatically update existing file
ownership.

Possible causes:

-   UID changed
-   Files still owned by old UID
-   Home directory ownership not updated
-   Files elsewhere on the system still use the old UID

------------------------------------------------------------------------

# Step 1 -- Gather Information

## Check 1 -- Verify Current UID

``` bash
id ali
```

Example:

``` text
uid=2000(ali)
```

------------------------------------------------------------------------

## Check 2 -- Find Files Owned by the Old UID

If the old UID was 1002:

``` bash
find / -uid 1002 2>/dev/null
```

------------------------------------------------------------------------

## Check 3 -- View Numeric Ownership

``` bash
ls -ln /home/ali
```

Example:

``` text
-rw-r--r-- 1 1002 1002 report.txt
```

Compare with:

``` bash
ls -l /home/ali
```

------------------------------------------------------------------------

# Root Cause

Linux records ownership using numeric UIDs. After changing the UID,
existing files still belong to the old UID until ownership is updated.

------------------------------------------------------------------------

# Solution

Fix only the home directory:

``` bash
sudo chown -R ali:ali /home/ali
```

Or update every file on the system owned by the old UID:

``` bash
sudo find / -uid 1002 -exec chown -h ali {} \;
```

------------------------------------------------------------------------

# Verification

``` bash
id ali
ls -l /home/ali
ls -ln /home/ali
```

Expected:

``` text
-rw-r--r-- 1 ali ali report.txt
```

------------------------------------------------------------------------

# Final Command Set

``` bash
id ali
find / -uid 1002 2>/dev/null
ls -ln /home/ali

sudo find / -uid 1002 -exec chown -h ali {} \;

ls -l /home/ali
```

------------------------------------------------------------------------

# Troubleshooting Flow

``` text
UID Changed
     │
     ▼
Check current UID
     │
     ▼
Find files with old UID
     │
     ▼
Update ownership
     │
     ▼
Verify ownership
     │
     ▼
Document
```

------------------------------------------------------------------------

# Incident Documentation

``` text
Incident ID:
USR-013

Problem:
Files displayed a numeric UID after changing the user's UID.

Root Cause:
Files remained owned by the old UID.

Resolution:
Located files with the old UID and reassigned ownership.

Verification:
Files display ali as the owner.

Preventive Action:
After changing a UID, always search for files owned by the old UID and update ownership.
```

------------------------------------------------------------------------

# RHCSA Tip

After using `usermod -u`, always search for files with the old UID and
fix ownership.

------------------------------------------------------------------------

# Interview Tip

Explain that Linux tracks ownership by numeric UID, not by usernames.
Changing the UID requires updating ownership on existing files.

------------------------------------------------------------------------

# Roman Urdu Summary

Agar `usermod -u` se UID change kar dein to purani files purane UID ki
ownership mein rehti hain. Purane UID ki files dhoond kar unki ownership
naye user ko deni hoti hai.

------------------------------------------------------------------------

# One-Line Summary

Changing a user's UID does not automatically update existing file
ownership; locate files with the old UID and reassign them to the
current user.
