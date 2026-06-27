# Linux Troubleshooting Scenario

# Scenario 14 -- Wrong Group

## Problem

A user reports that they cannot run Docker commands.

The administrator checks:

``` bash
groups ali
```

Output:

``` text
ali : developers
```

The user belongs to:

``` text
developers
```

But should belong to:

``` text
docker
```

------------------------------------------------------------------------

# Goal

Add the user to the correct group without removing existing group
memberships.

------------------------------------------------------------------------

# Why Use the Isolation Method?

Before making changes, verify:

-   Does the user exist?
-   Does the required group exist?
-   Is the user already a member?
-   Is the required group a primary or supplementary group?

------------------------------------------------------------------------

# Step 1 -- Gather Information

## Check 1 -- Verify the User Exists

``` bash
id ali
```

Expected:

``` text
uid=1002(ali)
```

------------------------------------------------------------------------

## Check 2 -- View Current Groups

``` bash
groups ali
```

Example:

``` text
ali : developers
```

------------------------------------------------------------------------

## Check 3 -- Verify the Group Exists

``` bash
getent group docker
```

Example:

``` text
docker:x:998:
```

If the group does not exist:

``` bash
sudo groupadd docker
```

------------------------------------------------------------------------

## Check 4 -- Verify Membership

``` bash
id ali
```

If `docker` is not listed, the user is not a member.

------------------------------------------------------------------------

# Root Cause

The user is not a member of the `docker` group.

Without this group, Docker commands normally require `sudo`.

------------------------------------------------------------------------

# Solution

Add the user to the docker group while keeping existing groups.

``` bash
sudo usermod -aG docker ali
```

### Command Breakdown

  Option     Meaning
  ---------- --------------------------------------
  `-a`       Append existing supplementary groups
  `-G`       Specify supplementary group(s)
  `docker`   Group to add
  `ali`      Username

------------------------------------------------------------------------

# Common Mistake

Do **not** run:

``` bash
sudo usermod -G docker ali
```

Without `-a`, Linux replaces all supplementary groups with only
`docker`.

------------------------------------------------------------------------

# Verification

Check:

``` bash
groups ali
```

Expected:

``` text
ali : developers docker
```

Or:

``` bash
id ali
```

Refresh the session:

``` bash
newgrp docker
```

or log out and log back in.

------------------------------------------------------------------------

# Final Command Set

``` bash
id ali
groups ali
getent group docker

sudo usermod -aG docker ali

groups ali
id ali
newgrp docker
```

------------------------------------------------------------------------

# Troubleshooting Flow

``` text
User cannot run Docker
        │
        ▼
Verify user exists
        │
        ▼
Check current groups
        │
        ▼
Verify docker group exists
        │
        ▼
Add user to docker group
        │
        ▼
Refresh login session
        │
        ▼
Verify membership
        │
        ▼
Document incident
```

------------------------------------------------------------------------

# Incident Documentation

``` text
Incident ID:
USR-014

Problem:
User could not run Docker commands.

Root Cause:
User was not a member of the docker group.

Resolution:
Added the user using:

sudo usermod -aG docker ali

Verification:
Confirmed group membership and Docker access after re-login.

Preventive Action:
Always use -aG when adding supplementary groups.
```

------------------------------------------------------------------------

# RHCSA Tip

Always use `usermod -aG` to add a user to a supplementary group.
Omitting `-a` removes existing supplementary groups.

------------------------------------------------------------------------

# Interview Tip

Explain that you would verify the user's current groups, confirm the
required group exists, add the user with `usermod -aG`, and verify the
change after the user starts a new login session.

------------------------------------------------------------------------

# Roman Urdu Summary

Agar user `developers` group mein hai lekin `docker` group mein nahi, to
Docker commands permission error de sakti hain. User ko `docker` group
mein `sudo usermod -aG docker ali` se add karein. `-a` lagana bohat
zaroori hai, warna doosre supplementary groups remove ho sakte hain.

------------------------------------------------------------------------

# One-Line Summary

When a user belongs to the wrong group, verify existing memberships, add
the correct supplementary group using `usermod -aG`, refresh the login
session, and verify the result.
