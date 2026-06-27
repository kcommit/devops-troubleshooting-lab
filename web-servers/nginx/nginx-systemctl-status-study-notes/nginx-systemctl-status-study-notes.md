# Nginx `systemctl status` Study Notes

## Topic
How to read the output of:

```bash
sudo systemctl status nginx
```

---

## 1. Correct Command Format

The correct format is:

```bash
systemctl <action> <service-name>
```

For Nginx status:

```bash
sudo systemctl status nginx
```

Common examples:

```bash
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx
sudo systemctl reload nginx
sudo systemctl enable nginx
sudo systemctl disable nginx
sudo systemctl status nginx
```

---

## 2. Your Output

```text
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; preset: enabled)
     Active: active (running) since Sat 2026-06-27 08:43:00 CDT; 4min 49s ago
       Docs: man:nginx(8)
    Process: 179 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
    Process: 198 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
   Main PID: 209 (nginx)
      Tasks: 13 (limit: 9239)
     Memory: 10.5M (peak: 11.1M)
        CPU: 48ms
     CGroup: /system.slice/nginx.service
             ├─209 "nginx: master process /usr/sbin/nginx -g daemon on; master_process on;"
             ├─210 "nginx: worker process"
             ├─212 "nginx: worker process"
             ├─213 "nginx: worker process"
             ├─214 "nginx: worker process"
             ├─215 "nginx: worker process"
             ├─216 "nginx: worker process"
             ├─217 "nginx: worker process"
             ├─218 "nginx: worker process"
             ├─219 "nginx: worker process"
             ├─221 "nginx: worker process"
             ├─222 "nginx: worker process"
             └─223 "nginx: worker process"

Jun 27 08:43:00 Khalid-laptop systemd[1]: Starting nginx.service - A high performance web server and a reverse proxy server...
Jun 27 08:43:00 Khalid-laptop systemd[1]: Started nginx.service - A high performance web server and a reverse proxy server.
```

---

## 3. Main Meaning

This output means:

```text
Nginx is installed.
Nginx service file is loaded.
Nginx is enabled.
Nginx is currently running.
Nginx started successfully.
There are no errors in this output.
```

---

## 4. Read Line by Line

### Service Name and Description

```text
● nginx.service - A high performance web server and a reverse proxy server
```

Meaning:

```text
nginx.service = service name
A high performance web server and a reverse proxy server = service description
```

Nginx can work as:

- Web server
- Reverse proxy
- Load balancer
- SSL/TLS termination point
- Cache server

---

### Loaded Line

```text
Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; preset: enabled)
```

Meaning:

| Part | Meaning |
|---|---|
| `Loaded: loaded` | systemd found the Nginx service file |
| `/usr/lib/systemd/system/nginx.service` | location of the Nginx service unit file |
| `enabled` | Nginx will start automatically when the system boots |
| `preset: enabled` | default system policy also allows it to be enabled |

Simple meaning:

```text
The Nginx service file exists and Nginx is configured to start automatically on boot.
```

---

### Active Line

```text
Active: active (running) since Sat 2026-06-27 08:43:00 CDT; 4min 49s ago
```

This is the most important line.

| Part | Meaning |
|---|---|
| `active (running)` | Nginx is currently running |
| `since Sat 2026-06-27 08:43:00 CDT` | Nginx started at this time |
| `4min 49s ago` | Nginx has been running for almost 5 minutes |

Simple meaning:

```text
Nginx is working right now.
```

---

### Docs Line

```text
Docs: man:nginx(8)
```

Meaning:

```text
You can read the Nginx manual page using the man command.
```

Command:

```bash
man nginx
```

---

### ExecStartPre Line

```text
Process: 179 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
```

Meaning:

Before starting Nginx, systemd tested the Nginx configuration.

Important part:

```text
status=0/SUCCESS
```

Meaning:

```text
The configuration test passed successfully.
```

The command used here is similar to:

```bash
sudo nginx -t
```

If this test fails, Nginx usually will not start.

---

### ExecStart Line

```text
Process: 198 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
```

Meaning:

systemd started Nginx using `/usr/sbin/nginx`.

Important part:

```text
status=0/SUCCESS
```

Meaning:

```text
Nginx started successfully.
```

---

### Main PID Line

```text
Main PID: 209 (nginx)
```

Meaning:

```text
PID = Process ID
209 = main Nginx process ID
```

The main process controls the Nginx service.

---

### Tasks Line

```text
Tasks: 13 (limit: 9239)
```

Meaning:

```text
Nginx is running 13 tasks/processes.
The system limit is 9239 tasks.
```

This is normal.

---

### Memory Line

```text
Memory: 10.5M (peak: 11.1M)
```

Meaning:

```text
Nginx is currently using 10.5 MB memory.
The highest memory usage was 11.1 MB.
```

This is very light memory usage.

---

### CPU Line

```text
CPU: 48ms
```

Meaning:

```text
Nginx has used very little CPU time.
```

This is normal.

---

### CGroup Line

```text
CGroup: /system.slice/nginx.service
```

Meaning:

```text
systemd is managing Nginx under this control group.
```

CGroup helps Linux manage resources like CPU, memory, and processes.

---

## 5. Master Process and Worker Processes

```text
├─209 "nginx: master process /usr/sbin/nginx -g daemon on; master_process on;"
├─210 "nginx: worker process"
├─212 "nginx: worker process"
...
```

Meaning:

| Process Type | Meaning |
|---|---|
| Master process | Main controller process |
| Worker process | Handles user/web requests |

Simple explanation:

```text
The master process controls Nginx.
The worker processes handle website traffic.
```

Usually Nginx has:

```text
1 master process
multiple worker processes
```

This is normal behavior.

---

## 6. Log Lines at the Bottom

```text
Jun 27 08:43:00 Khalid-laptop systemd[1]: Starting nginx.service - A high performance web server and a reverse proxy server...
Jun 27 08:43:00 Khalid-laptop systemd[1]: Started nginx.service - A high performance web server and a reverse proxy server.
```

Meaning:

```text
systemd started the Nginx service successfully.
```

There is no error here.

---

## 7. Quick Summary Table

| Output Line | Meaning |
|---|---|
| `nginx.service` | Nginx service name |
| `Loaded: loaded` | Service file exists |
| `enabled` | Starts automatically on boot |
| `Active: active (running)` | Nginx is running now |
| `status=0/SUCCESS` | Command completed successfully |
| `Main PID` | Main Nginx process ID |
| `Tasks` | Number of running tasks/processes |
| `Memory` | Memory used by Nginx |
| `CPU` | CPU time used by Nginx |
| `master process` | Main controlling process |
| `worker process` | Handles web requests |
| `Started nginx.service` | Nginx started successfully |

---

## 8. Final Result of Your Output

Your Nginx service status is good:

```text
Nginx is running perfectly.
No error found.
Service is enabled.
It will start automatically after reboot.
Configuration test passed.
```

---

## 9. How to Test Nginx

### Test from terminal

```bash
curl localhost
```

Expected result:

```text
You should see Nginx welcome page HTML.
```

### Test from browser

Open:

```text
http://localhost
```

Expected result:

```text
Nginx welcome page should appear.
```

---

## 10. Useful Nginx Commands

### Check status

```bash
sudo systemctl status nginx
```

### Start Nginx

```bash
sudo systemctl start nginx
```

### Stop Nginx

```bash
sudo systemctl stop nginx
```

### Restart Nginx

```bash
sudo systemctl restart nginx
```

### Reload Nginx after config change

```bash
sudo systemctl reload nginx
```

### Enable Nginx on boot

```bash
sudo systemctl enable nginx
```

### Disable Nginx on boot

```bash
sudo systemctl disable nginx
```

### Test Nginx configuration

```bash
sudo nginx -t
```

### Check Nginx version

```bash
nginx -v
```

---

## 11. Common Status Meanings

| Status | Meaning |
|---|---|
| `active (running)` | Service is running successfully |
| `inactive (dead)` | Service is stopped |
| `failed` | Service tried to start but failed |
| `enabled` | Service starts automatically at boot |
| `disabled` | Service does not start automatically at boot |
| `status=0/SUCCESS` | Command completed without error |
| `status=1/FAILURE` | Command failed |

---

## 12. WSL Note

If you are using WSL and `systemctl` does not work, try the older service command:

```bash
sudo service nginx status
sudo service nginx start
sudo service nginx restart
sudo service nginx stop
```

But in your output, `systemctl` is working correctly.

---

## 13. One-Line Definition

```text
systemctl status nginx shows whether the Nginx service is loaded, enabled, running, failed, and what processes/logs are related to it.
```

---

## 14. Interview-Style Answer

If someone asks, “How do you check if Nginx is running?”

Answer:

```text
I use sudo systemctl status nginx. If it shows Active: active (running), then Nginx is currently running. I also check status=0/SUCCESS to confirm that the service started successfully, and I can test it with curl localhost or by opening http://localhost in a browser.
```

---

## 15. Practice Commands

Run these commands for practice:

```bash
sudo systemctl status nginx
sudo nginx -t
curl localhost
nginx -v
ps aux | grep nginx
```

---

## 16. Important Point to Remember

The most important line in `systemctl status nginx` is:

```text
Active: active (running)
```

If you see this, Nginx is running successfully.
