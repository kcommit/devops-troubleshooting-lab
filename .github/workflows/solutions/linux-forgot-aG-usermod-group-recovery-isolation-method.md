# Linux Troubleshooting Scenario

# Scenario 15 -- Forgot `-aG`

## Problem

An administrator wants to add user `ali` to the `docker` group.

They accidentally run:

``` bash
sudo usermod -G docker ali
```

Oops!

After this, user `ali` disappears from every other secondary group.

For example, before the command the user belonged to:

``` text
ali : ali sudo developers users
```

After the command:

``` text
ali : ali docker
```

The user lost important supplementary groups such as:

-   `sudo`
-   `developers`
-   `users`

------------------------------------------------------------------------

# Goal

Recover the user's previous group memberships and understand how to
prevent this mistake.

------------------------------------------------------------------------

# Why This Happens

The option:

``` bash
-G
```

sets the user's supplementary groups.

If you use `-G` without `-a`, Linux replaces the existing supplementary
groups with the new list.

So this command:

``` bash
sudo usermod -G docker ali
```

means:

``` text
Make docker the only supplementary group for ali.
```

It does **not** mean:

``` text
Add docker to the existing groups.
```

------------------------------------------------------------------------

# Correct Command

The correct command should have been:

``` bash
sudo usermod -aG docker ali
```

Explanation:

  Option     Meaning
  ---------- --------------------------------------------
  `-a`       Append, keep existing supplementary groups
  `-G`       Add/set supplementary groups
  `docker`   Group being added
  `ali`      Username

------------------------------------------------------------------------

# Isolation Method

Do not randomly add groups back.

First, investigate what was changed and what the user should belong to.

------------------------------------------------------------------------

# Step 1 -- Gather Information

## Check 1 -- Verify the User Exists

``` bash
id ali
```

------------------------------------------------------------------------

## Check 2 -- Check Current Groups

``` bash
groups ali
```

or:

``` bash
id ali
```

Example after mistake:

``` text
uid=1002(ali) gid=1002(ali) groups=1002(ali),998(docker)
```

This confirms the user only has the primary group and the newly assigned
`docker` group.

------------------------------------------------------------------------

## Check 3 -- Find Previous Group Memberships

Possible places to recover previous group information:

### Option 1 -- Check Backup Group File

Many Linux systems keep a backup file:

``` bash
ls -l /etc/group-
```

Search for the user:

``` bash
grep ali /etc/group-
```

Example:

``` text
sudo:x:27:ali
developers:x:1003:ali
users:x:100:ali
```

------------------------------------------------------------------------

### Option 2 -- Check Git or Configuration Management

If `/etc/group` is managed by automation, check:

-   Ansible playbooks
-   Bash provisioning scripts
-   Terraform/user data scripts
-   Documentation
-   Previous Git commits

------------------------------------------------------------------------

### Option 3 -- Check Another Server

If this is part of a fleet, compare with a similar server:

``` bash
groups ali
```

on another machine.

------------------------------------------------------------------------

### Option 4 -- Ask the Application or Team Requirement

For example:

  Requirement          Group
  -------------------- -------------------
  Run Docker           `docker`
  Admin access         `sudo` or `wheel`
  Developer files      `developers`
  Shared user access   `users`

------------------------------------------------------------------------

# Root Cause

The administrator used:

``` bash
sudo usermod -G docker ali
```

instead of:

``` bash
sudo usermod -aG docker ali
```

This replaced all previous supplementary groups with only `docker`.

------------------------------------------------------------------------

# Recovery

## Step 1 -- Decide Correct Group List

Example correct groups:

``` text
sudo,developers,users,docker
```

## Step 2 -- Restore Groups

Use:

``` bash
sudo usermod -aG sudo,developers,users,docker ali
```

Or, if you want to explicitly set all supplementary groups:

``` bash
sudo usermod -G sudo,developers,users,docker ali
```

Important:

-   Use `-aG` when adding a group.
-   Use `-G` only when you intentionally want to replace the full
    supplementary group list.

------------------------------------------------------------------------

# Verification

Check:

``` bash
groups ali
```

Expected:

``` text
ali : ali sudo developers users docker
```

Or:

``` bash
id ali
```

Expected:

``` text
uid=1002(ali) gid=1002(ali) groups=1002(ali),27(sudo),1003(developers),100(users),998(docker)
```

------------------------------------------------------------------------

# Refresh Login Session

Group membership changes apply to new login sessions.

The user should log out and log back in.

For temporary testing:

``` bash
newgrp docker
```

Or test full login:

``` bash
su - ali
```

------------------------------------------------------------------------

# Final Command Set

``` bash
id ali
groups ali
grep ali /etc/group-
getent group sudo
getent group developers
getent group users
getent group docker

sudo usermod -aG sudo,developers,users,docker ali

groups ali
id ali
su - ali
```

------------------------------------------------------------------------

# Troubleshooting Flow

``` text
User lost secondary groups
        │
        ▼
Check current groups
        │
        ▼
Identify missing groups
        │
        ▼
Check /etc/group- or documentation
        │
        ▼
Build correct group list
        │
        ▼
Restore groups
        │
        ▼
Verify with id/groups
        │
        ▼
Ask user to log out/in
        │
        ▼
Document incident
```

------------------------------------------------------------------------

# Incident Documentation

``` text
Incident ID:
USR-015

Problem:
User lost previous supplementary group memberships.

Symptoms:
User could no longer access sudo/developer resources after being added to docker group.

Root Cause:
Administrator used `usermod -G docker ali` without `-a`, replacing all previous supplementary groups.

Resolution:
Recovered expected group list and restored memberships using:

sudo usermod -aG sudo,developers,users,docker ali

Verification:
Confirmed group memberships using `id ali` and `groups ali`.

Preventive Action:
Always use `usermod -aG` when adding a supplementary group.
Document current memberships before changing user groups.
```

------------------------------------------------------------------------

# Common Mistake

## Wrong

``` bash
sudo usermod -G docker ali
```

This replaces existing supplementary groups.

## Correct

``` bash
sudo usermod -aG docker ali
```

This appends the new group and keeps existing groups.

------------------------------------------------------------------------

# RHCSA Tip

In RHCSA-style tasks, when adding a user to a supplementary group,
always use:

``` bash
sudo usermod -aG groupname username
```

Omitting `-a` can remove existing group memberships.

------------------------------------------------------------------------

# Interview Tip

If asked:

``` text
A user lost all secondary groups after being added to docker. What happened?
```

A strong answer is:

``` text
The administrator probably used `usermod -G docker username` without `-a`.
The `-G` option replaces supplementary groups unless used with `-a`.
I would identify the expected groups from backups or documentation, restore them, verify with `id`, and ask the user to start a new login session.
```

------------------------------------------------------------------------

# Roman Urdu Summary

Agar administrator ne ye command chalai:

``` bash
sudo usermod -G docker ali
```

to user ke purane supplementary groups replace ho gaye honge.

Correct command ye thi:

``` bash
sudo usermod -aG docker ali
```

`-a` ka matlab hai append, yani purane groups ko keep karna aur naya
group add karna.

Recovery ke liye pehle purane groups identify karein, phir:

``` bash
sudo usermod -aG sudo,developers,users,docker ali
```

se groups restore karein.

------------------------------------------------------------------------

# Quick Memory Trick

``` text
-aG = Add Group
-G  = Replace Groups
```

``` text
Adding group?
        ↓
Always use -aG
```

------------------------------------------------------------------------

# One-Line Summary

Using `usermod -G` without `-a` replaces all supplementary groups;
recover by identifying the correct group list and restoring memberships
with `usermod -aG`.
