# Apache HTTP Server MCQ Quiz

This project contains an interactive **Apache HTTP Server MCQ quiz** for students, Linux administrators, and DevOps learners.

The quiz is based on the topic:

```text
Apache From Scratch to Hero
```

It helps learners revise Apache basics, configuration, virtual hosts, modules, SSL, reverse proxy, logs, troubleshooting, and common interview concepts.

---

## Files

| File Name | Description |
|---|---|
| `apache-25-mcqs.html` | Interactive HTML quiz with 25 Apache MCQs |
| `README.md` | Project explanation and usage guide |

---

## Quiz Features

- 25 multiple-choice questions
- Browser-based quiz
- No installation required
- Built-in countdown timer
- Automatic score calculation
- Correct and incorrect answer highlighting
- Explanation for each question
- Print or save as PDF option
- Good for classroom practice and self-study

---

## Topics Covered

The quiz covers important Apache concepts such as:

```text
Apache HTTP Server basics
Ubuntu/Debian apache2 package
RHEL/CentOS httpd package
Virtual Hosts
DocumentRoot
Directory blocks
.htaccess
Apache modules
mod_rewrite
mod_ssl
mod_proxy
Reverse proxy
ProxyPass
ProxyPassReverse
Apache logs
403 Forbidden
404 Not Found
500 Internal Server Error
Apache commands
```

---

## How to Use

### Option 1: Open Directly

Open the HTML file in any browser:

```text
apache-25-mcqs.html
```

You can double-click the file or right-click and choose:

```text
Open with browser
```

---

### Option 2: Open from VS Code

If you are using VS Code:

1. Open the project folder.
2. Right-click `apache-25-mcqs.html`.
3. Select **Open with Live Server** if the Live Server extension is installed.

---

### Option 3: Use with GitHub Pages

You can also publish this quiz using GitHub Pages.

Example repo structure:

```text
apache-mcq-quiz/
├── apache-25-mcqs.html
└── README.md
```

Then enable GitHub Pages from repository settings.

---

## Passing Score

Recommended passing score:

```text
70% or higher
```

Since the quiz has 25 questions:

```text
18 correct answers or more = Pass
```

---

## Recommended Learning Flow

Before taking the quiz, review these Apache topics:

1. What is Apache?
2. Apache vs NGINX
3. Apache installation on Ubuntu and RHEL
4. Important Apache files and directories
5. Virtual Host configuration
6. DocumentRoot
7. Directory permissions
8. `.htaccess`
9. Apache modules
10. Reverse proxy
11. SSL/HTTPS
12. Logs and troubleshooting

---

## Useful Apache Commands

### Ubuntu/Debian

```bash
sudo systemctl status apache2
sudo systemctl start apache2
sudo systemctl stop apache2
sudo systemctl restart apache2
sudo systemctl reload apache2
sudo apache2ctl configtest
sudo apache2ctl -S
apache2ctl -M
```

### RHEL/CentOS/Rocky/AlmaLinux

```bash
sudo systemctl status httpd
sudo systemctl start httpd
sudo systemctl stop httpd
sudo systemctl restart httpd
sudo systemctl reload httpd
sudo apachectl configtest
sudo apachectl -S
httpd -M
```

---

## Common Troubleshooting Practice

| Error | Meaning |
|---|---|
| `403 Forbidden` | Access denied due to permission or config issue |
| `404 Not Found` | Requested file or route not found |
| `500 Internal Server Error` | Server-side issue such as bad `.htaccess` or PHP/app error |
| `502 Bad Gateway` | Backend app is not responding correctly |

---

## Best For

This quiz is useful for:

```text
Linux System Admin practice
DevOps interview preparation
Apache revision
Web server troubleshooting practice
Classroom teaching
Hands-on lab review
```

---

## Final Note

Apache is a very important web server for Linux administration and DevOps.

Focus especially on:

```text
Virtual Hosts
DocumentRoot
.htaccess
Modules
SSL
Reverse proxy
Logs
Troubleshooting
```

These topics are commonly used in real production environments and interviews.
