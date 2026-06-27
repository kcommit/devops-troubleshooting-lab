# Linux Troubleshooting Scenario

## Scenario 4 -- Shell Changed to `/bin/sh`

### Problem

A user logs in and only sees:

``` text
$
```

Check:

``` bash
echo $SHELL
```

Output:

``` text
/bin/sh
```

## Goal

Restore `/bin/bash` as the default login shell.

------------------------------------------------------------------------

## Isolation Method

### 1. Verify the user exists

``` bash
id ali
```

### 2. Check the configured login shell

``` bash
grep '^ali' /etc/passwd
```

Example:

``` text
ali:x:1002:1002::/home/ali:/bin/sh
```

### 3. Verify the current shell

``` bash
echo $SHELL
echo $0
```

> Note: A `$` prompt does not always mean `/bin/sh`. Always verify using
> `echo $SHELL` and `echo $0`.

### 4. Verify Bash is installed

``` bash
which bash
cat /etc/shells
```

### 5. Change the login shell

``` bash
sudo chsh -s /bin/bash ali
```

Alternative:

``` bash
sudo usermod -s /bin/bash ali
```

### 6. Verify

``` bash
su - ali
echo $SHELL
echo $0
```

Expected:

``` text
/bin/bash
-bash
```

------------------------------------------------------------------------

## Troubleshooting Flow

``` text
User logs in
   ↓
Check user exists
   ↓
Check /etc/passwd
   ↓
Check echo $SHELL
   ↓
Verify Bash exists
   ↓
Change shell to /bin/bash
   ↓
Log in again
   ↓
Verify
```

------------------------------------------------------------------------

## RHCSA Tip

Always verify the configured login shell in `/etc/passwd` before
changing it.

## Interview Tip

Explain your troubleshooting process before giving the command.

## Roman Urdu Summary

Agar `echo $SHELL` ka output `/bin/sh` aaye to user ki default shell
Bash nahi hai. Use:

``` bash
sudo chsh -s /bin/bash ali
```

phir dobara login karke verify karein.

## One-Line Summary

Restore `/bin/bash`, verify the shell, and test the login.
