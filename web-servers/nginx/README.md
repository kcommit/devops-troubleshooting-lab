# NGINX MCQ Quiz

This project contains an interactive **25-question MCQ quiz on NGINX** for learning, revision, and student practice.

## Purpose

The purpose of this quiz is to help students test their understanding of NGINX from beginner to practical DevOps/System Admin level.

NGINX is commonly used as a:

- Web server
- Reverse proxy
- Load balancer
- SSL/TLS termination point
- Cache server
- TCP/UDP proxy
- Mail proxy

## Files Included

| File | Description |
|---|---|
| `nginx-25-mcqs.html` | Interactive HTML quiz with 25 NGINX MCQs |
| `README.md` | Project explanation and usage guide |

## Quiz Features

- 25 multiple-choice questions
- Timer included
- Score calculation
- Instant result after submission
- Correct answer review
- Explanation for each question
- Beginner-friendly interface
- Useful for students, DevOps learners, and Linux/System Admin practice

## Topics Covered

The quiz covers important NGINX concepts such as:

- What is NGINX?
- Web server basics
- Reverse proxy
- Load balancing
- SSL/TLS termination
- Caching
- NGINX configuration files
- Server block and location block
- `proxy_pass`
- Logs and troubleshooting
- Common errors like 403, 404, and 502
- Docker and NGINX basics
- Kubernetes Ingress basics

## How to Use

### Option 1: Open Directly

Download the file and open it in any browser:

```text
nginx-25-mcqs.html
```

You can use:

- Google Chrome
- Microsoft Edge
- Firefox
- Brave

### Option 2: Run with VS Code Live Server

If you are using VS Code:

1. Open the folder in VS Code.
2. Install the **Live Server** extension.
3. Right-click `nginx-25-mcqs.html`.
4. Click **Open with Live Server**.

## Recommended Practice Method

1. First study the NGINX notes.
2. Attempt all 25 MCQs without checking answers.
3. Submit the quiz.
4. Review wrong answers.
5. Repeat the quiz after revision.

## Learning Goal

After completing this quiz, students should be able to explain the main role of NGINX and identify how it is used in real-world DevOps and production environments.

## Important NGINX Commands for Revision

```bash
sudo nginx -t
sudo systemctl status nginx
sudo systemctl reload nginx
sudo systemctl restart nginx
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

## Simple NGINX Flow

```text
User Browser
     |
     v
   NGINX
     |
     v
Backend Application / Static Website
```

## Author

Created for NGINX learning and DevOps study practice.

