# Nginx MCQ HTML Quiz Instructions

## File Name

```text
nginx-systemctl-rhel-25-mcqs.html
```

## Topic

This HTML quiz contains 25 multiple-choice questions about:

- Reading `sudo systemctl status nginx`
- Nginx service status meanings
- Nginx master and worker processes
- Ubuntu/Debian Nginx user: `www-data`
- RHEL/Rocky/AlmaLinux Nginx user: `nginx`
- Checking `/etc/passwd`, `/etc/group`, `/etc/shadow`
- Checking the Nginx user directive in `/etc/nginx/nginx.conf`

---

## How to Open the HTML File

### Method 1: Double Click

1. Download the HTML file.
2. Find the file on your computer.
3. Double-click:

```text
nginx-systemctl-rhel-25-mcqs.html
```

4. It will open in your default browser.

---

## Method 2: Open With Browser

1. Right-click the HTML file.
2. Select:

```text
Open with
```

3. Choose a browser such as:

```text
Google Chrome
Microsoft Edge
Firefox
```

---

## Method 3: Open from VS Code

1. Open the folder in VS Code.
2. Right-click the HTML file.
3. Select:

```text
Open with Live Server
```

> Note: This requires the Live Server extension in VS Code.

---

## How to Take the Quiz

1. Read each question carefully.
2. Select one answer for each question.
3. Click:

```text
Check Answers
```

4. The quiz will show:

```text
Correct
Incorrect
Not answered
```

5. Your score will appear at the top.

---

## How to Reset the Quiz

Click:

```text
Reset
```

This will clear all selected answers and restart the score.

---

## Recommended Study Method

1. Read your Nginx study notes first.
2. Take the quiz without looking at the notes.
3. Check your score.
4. Review the wrong answers.
5. Repeat the quiz again.

---

## Important Commands to Remember

```bash
sudo systemctl status nginx
sudo nginx -t
curl localhost
ps aux | grep nginx
grep nginx /etc/passwd
grep nginx /etc/group
sudo grep nginx /etc/shadow
grep user /etc/nginx/nginx.conf
```

---

## Quick Goal

By the end of this quiz, you should be able to explain:

```text
How to check if Nginx is running, how to read systemctl status output, and how to identify the Nginx service account on RHEL.
```
