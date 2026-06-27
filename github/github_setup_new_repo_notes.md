# 🚀 GitHub Setup & New Repo Study Notes

## 🧠 Overview
This document explains the complete setup of Git + GitHub on a new Windows machine, including SSH authentication and first repository push.

---

## 🖥️ 1. Git Installation Check

```bash
git version
```

✔ Confirms Git is installed on system

---

## 👤 2. Git Identity Setup

```bash
git config --global user.name "kcommit"
git config --global user.email "your-email@gmail.com"
```

### Verify:
```bash
git config --global --list
```

---

## 🔑 3. SSH Key Setup (GitHub Authentication)

### Generate SSH key:
```bash
ssh-keygen -t ed25519 -C "your-email@gmail.com"
```

### Start SSH agent:
```powershell
Start-Service ssh-agent
ssh-add $env:USERPROFILE\.ssh\id_ed25519
```

### Copy SSH key:
```powershell
type $env:USERPROFILE\.ssh\id_ed25519.pub
```

---

## 🌐 4. Add SSH Key to GitHub

Go to:
```
GitHub → Settings → SSH and GPG keys → New SSH Key
```

Paste key and save.

---

## 🧪 5. Test GitHub Connection

```bash
ssh -T git@github.com
```

### Success Output:
```
Hi kcommit! You've successfully authenticated
```

---

## 📁 6. Create New Repository (Local)

```bash
cd /c/Linux/your-project
git init
```

---

## 🔗 7. Connect Remote Repository

```bash
git remote add origin git@github.com:username/repo-name.git
```

Check:
```bash
git remote -v
```

---

## 🚀 8. First Push to GitHub

```bash
git add .
git commit -m "Initial commit"
git branch -M main
git push -u origin main
```

---

## ⚠️ Common Issues

### ❌ Permission denied (publickey)
- SSH key not added to GitHub

### ❌ src refspec main does not match any
- No commit made yet

### ❌ remote not found
- Wrong repo URL

---

## 🧠 Key Concepts

| Component | Meaning |
|----------|--------|
| Git | Version control system |
| GitHub | Remote repository platform |
| SSH Key | Secure authentication |
| Commit | Snapshot of code |
| Push | Upload to GitHub |

---

## 🎯 Final Result

After setup you can:
- Push code to GitHub
- Clone repositories
- Manage DevOps projects
- Work like a professional engineer

---

## 👨‍💻 Author
Khalid Khan  
DevOps & Linux System Administrator (Learning Path)
