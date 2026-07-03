# Networking From Scratch to Hero — Study Notes for DevOps

## Purpose
These notes explain networking from beginner level to practical DevOps level using the **What, Why, and How** method. They are designed for Linux, DevOps, AWS, troubleshooting, interviews, and real-world practice.

Sources used:
- Uploaded `networking-short-notes.pdf`
- Uploaded `network-cheatsheet.pdf`
- CIDR practice tool: https://cidr.xyz/

---

# 0. Important Networking Full Forms and One-Line Meanings

This section is useful for interviews, troubleshooting, and reading DevOps documentation. First remember the **full form**, then remember the **simple job** of each term.

| Short Name | Full Form | Simple Meaning / Job | Example / DevOps Use |
|---|---|---|---|
| CIDR | Classless Inter-Domain Routing | A modern way to write IP networks using `/` notation. | `192.168.1.0/24` means one network with 256 total addresses. |
| OSI | Open Systems Interconnection | A 7-layer model used to understand how network communication works. | Helps troubleshoot: cable issue, IP issue, TCP issue, DNS issue, HTTP issue. |
| TCP | Transmission Control Protocol | Reliable connection-based communication. | Web apps, SSH, databases, APIs. |
| UDP | User Datagram Protocol | Faster but connectionless communication. | DNS, video calls, streaming, some monitoring tools. |
| IP | Internet Protocol | Gives addresses to devices and moves packets between networks. | Server IP, container IP, pod IP, public/private IP. |
| IPv4 | Internet Protocol version 4 | 32-bit IP address format. | `192.168.1.10` |
| IPv6 | Internet Protocol version 6 | 128-bit IP address format. | `2001:db8::1` |
| HTTP | HyperText Transfer Protocol | Web communication protocol without encryption. | Website/API running on port `80`. |
| HTTPS | HyperText Transfer Protocol Secure | HTTP with encryption using TLS. | Secure website/API running on port `443`. |
| DNS | Domain Name System | Converts domain names into IP addresses. | `google.com` -> server IP address. |
| DHCP | Dynamic Host Configuration Protocol | Automatically gives IP address, gateway, and DNS to devices. | Laptop gets IP from home router. |
| ARP | Address Resolution Protocol | Finds MAC address from an IP address inside a local network. | `arp -a` shows IP-to-MAC mapping. |
| ICMP | Internet Control Message Protocol | Used for network messages and testing reachability. | `ping google.com` uses ICMP. |
| TLS | Transport Layer Security | Modern encryption protocol used by HTTPS. | SSL certificate setup in Nginx/Apache/Load Balancer. |
| SSL | Secure Sockets Layer | Older name/protocol for encryption; commonly people still say SSL certificate. | In practice, modern systems use TLS. |
| FTP | File Transfer Protocol | Transfers files over network, usually not secure by default. | Legacy file server. |
| SFTP | SSH File Transfer Protocol | Secure file transfer over SSH. | Upload files to Linux server securely. |
| SSH | Secure Shell | Secure remote login to a server. | `ssh user@server-ip` uses port `22`. |
| SMTP | Simple Mail Transfer Protocol | Sends emails between mail servers. | Linux mail alerts, SMTP relay. |
| NAT | Network Address Translation | Converts private IP to public IP or public IP to private IP. | AWS NAT Gateway lets private subnet access internet. |
| VPN | Virtual Private Network | Secure tunnel between networks or users. | Connect laptop to company private network. |
| LAN | Local Area Network | Small local network. | Home, office, lab network. |
| WAN | Wide Area Network | Large network across locations. | Internet or branch-to-branch network. |
| VPC | Virtual Private Cloud | Private network inside cloud provider. | AWS VPC with subnets, route tables, IGW, NAT Gateway. |
| MAC | Media Access Control | Hardware address of network interface. | Used inside LAN switching and ARP. |
| URL | Uniform Resource Locator | Complete web address. | `https://example.com/login` |
| API | Application Programming Interface | A way for applications to communicate. | CI/CD calling GitHub API, app calling payment API. |
| CDN | Content Delivery Network | Caches content near users to make websites faster. | CloudFront, Cloudflare. |
| WAF | Web Application Firewall | Protects web apps from common attacks. | Blocks malicious HTTP requests. |
| ACL | Access Control List | Rules that allow or deny traffic/access. | AWS Network ACL, firewall ACL. |
| MTU | Maximum Transmission Unit | Maximum packet size allowed on a network link. | MTU mismatch can cause slow/broken connections. |
| TTL | Time To Live | Limits how many hops a packet can travel. | Used by `traceroute` to discover path. |
| LB | Load Balancer | Distributes traffic across multiple servers. | Nginx, HAProxy, AWS ALB/NLB. |

## Best Learning Order

```text
Network basics
-> OSI and TCP/IP models
-> IP address, subnet, CIDR
-> Ports and protocols
-> DNS, HTTP, HTTPS
-> Routing, gateway, NAT
-> Firewalls and security
-> Load balancers
-> Linux troubleshooting commands
-> AWS/VPC/Docker/Kubernetes networking
```

## Easy Example

When you open a website:

```text
1. DNS converts domain name to IP.
2. TCP creates a reliable connection.
3. TLS secures the connection for HTTPS.
4. HTTP/HTTPS sends the web request.
5. Load balancer forwards traffic to a healthy server.
6. Server sends response back to your browser.
```

---

# 1. What is a Computer Network?

## 
A **computer network** is a group of computers, servers, phones, routers, switches, or cloud resources connected together so they can share data.

## 
Without networking:
- Websites cannot open.
- Servers cannot talk to databases.
- DevOps pipelines cannot deploy applications.
- Users cannot access cloud applications.
- Monitoring, SSH, DNS, APIs, and load balancers will not work.

## 
A device sends data in small pieces called **packets**. These packets travel through cables, Wi-Fi, switches, routers, firewalls, and the internet until they reach the destination.

Simple flow:

```text
User Laptop -> Wi-Fi Router -> ISP -> Internet -> Cloud Load Balancer -> Web Server -> App -> Database
```

---

# 2. Why Networking is Important for DevOps

DevOps engineers need networking because most DevOps work depends on communication between systems.

## Main DevOps Use Cases

| Area | Why Networking Matters |
|---|---|
| Infrastructure Design | Design VPCs, subnets, routing, firewalls, NAT, VPNs, and load balancers. |
| Application Deployment | Connect web servers, app servers, databases, containers, Kubernetes services, and external APIs. |
| Automation | Automate server/network setup using Ansible, Terraform, Puppet, or cloud tools. |
| Monitoring | Troubleshoot downtime, latency, packet loss, DNS issues, and service health. |
| Security | Control access using firewalls, security groups, TLS, SSH, VPNs, and network policies. |
| CI/CD | Connect GitHub Actions, Docker registries, cloud services, and deployment targets. |

---

# 3. Basic Network Devices

| Device | One-Line Definition |
|---|---|
| NIC | Network Interface Card; connects a machine to a network. |
| Switch | Connects devices inside the same LAN. |
| Router | Connects different networks together. |
| Modem | Connects home/office network to ISP. |
| Firewall | Allows or blocks network traffic based on rules. |
| Load Balancer | Distributes traffic across multiple backend servers. |
| DNS Server | Converts domain names into IP addresses. |
| DHCP Server | Automatically gives IP addresses to devices. |
| Gateway | Exit point from one network to another network. |

---

# 4. How the Internet Works

## 
The internet is a huge network of networks connected globally.

## 
It allows devices anywhere in the world to communicate using common protocols such as IP, TCP, UDP, HTTP, HTTPS, DNS, and TLS.

## 
When you open a website like `https://example.com`:

```text
1. Browser checks DNS for example.com IP address.
2. DNS returns an IP address.
3. Browser opens TCP connection to the server.
4. TLS handshake secures the connection.
5. Browser sends HTTP request.
6. Server sends HTTP response.
7. Browser displays the page.
```

---

# 5. OSI Model

The **OSI model** is a 7-layer conceptual model that explains how data travels across a network.

## OSI Layers Table

| Layer | Name | What It Does | Example |
|---|---|---|---|
| 7 | Application | User-facing network services | HTTP, DNS, FTP, SMTP, SSH |
| 6 | Presentation | Data format, encryption, compression | TLS/SSL, encoding |
| 5 | Session | Starts, manages, and ends sessions | Login session, RPC session |
| 4 | Transport | End-to-end delivery using ports | TCP, UDP |
| 3 | Network | IP addressing and routing | IP, ICMP, routers |
| 2 | Data Link | MAC addressing and local delivery | Ethernet, switches, ARP |
| 1 | Physical | Physical signal and media | Cable, fiber, Wi-Fi signal |

## Easy Memory

```text
Application -> Presentation -> Session -> Transport -> Network -> Data Link -> Physical
```

From user to wire: **Layer 7 down to Layer 1**  
From wire to user: **Layer 1 up to Layer 7**

---

# 6. TCP/IP Model

The **TCP/IP model** is the practical model used on real networks and the internet.

| TCP/IP Layer | Related OSI Layers | Examples |
|---|---|---|
| Application | OSI 5, 6, 7 | HTTP, HTTPS, DNS, SSH, SMTP, FTP |
| Transport | OSI 4 | TCP, UDP |
| Internet | OSI 3 | IP, ICMP |
| Network Access | OSI 1, 2 | Ethernet, Wi-Fi, MAC, ARP |

---

# 7. IP Address

## 
An **IP address** is a logical address used to identify a device on a network.

Example:

```text
192.168.1.10
```

## 
Devices need addresses so packets know where to go.

## IPv4 Format
IPv4 has 4 parts called **octets**.

```text
192 . 168 . 1 . 10
```

Each octet has 8 bits and can be from 0 to 255.

---

# 8. Private vs Public IP

| Type | Meaning | Example |
|---|---|---|
| Private IP | Used inside local/private networks | 192.168.1.10 |
| Public IP | Used on the internet | 8.8.8.8 |

## Common Private IP Ranges with Class A, B, and C

| Class / Type | Range / Example | CIDR | Easy Memory / Use |
|---|---|---|---|
| Class A Private | 10.0.0.0 - 10.255.255.255 | 10.0.0.0/8 | Big private networks |
| Class B Private | 172.16.0.0 - 172.31.255.255 | 172.16.0.0/12 | Medium private networks |
| Class C Private | 192.168.0.0 - 192.168.255.255 | 192.168.0.0/16 | Small/home/lab private networks |
| Localhost / Loopback | 127.0.0.1 | 127.0.0.0/8 | Your own machine; used to test local services |
| Network IP | Example: 192.168.1.0 | Example: 192.168.1.0/24 | First address of a subnet; identifies the network itself |
| Broadcast IP | Example: 192.168.1.255 | Example: 192.168.1.0/24 | Last address of a subnet; sends traffic to all hosts in that subnet |

> Important: These are **private IP ranges**, not full public class ranges.
> Historically they are commonly explained as Class A, Class B, and Class C private ranges, but modern networking mostly uses **CIDR** instead of old classful addressing.
>
> **Network IP and Broadcast IP depend on the subnet mask/CIDR.** For example, in `192.168.1.0/24`, the network IP is `192.168.1.0`, usable hosts are `192.168.1.1 - 192.168.1.254`, and the broadcast IP is `192.168.1.255`.

---

# 9. Subnetting and CIDR

## What is CIDR?
**CIDR** means **Classless Inter-Domain Routing**. It is a compact way to write an IP network and its subnet size.

Example:

```text
192.168.1.0/24
```

Here:
- `192.168.1.0` = network address
- `/24` = first 24 bits are network bits
- remaining 8 bits are host bits

## Why CIDR is Important for DevOps

CIDR is used in:
- AWS VPCs
- AWS subnets
- Kubernetes pod/service CIDRs
- Docker bridge networks
- VPNs
- Firewalls and security groups
- Routing tables

## Formula

```text
Total IPs = 2^(32 - CIDR prefix)
Usable hosts = Total IPs - 2
```

Usually we subtract 2 because:
- One IP is the network address.
- One IP is the broadcast address.

## Common CIDR Table

| CIDR | Subnet Mask | Total IPs | Usable Hosts | Common Use |
|---|---|---:|---:|---|
| /32 | 255.255.255.255 | 1 | 1 host route | Single host |
| /30 | 255.255.255.252 | 4 | 2 | Point-to-point links |
| /29 | 255.255.255.248 | 8 | 6 | Very small subnet |
| /28 | 255.255.255.240 | 16 | 14 | Small subnet |
| /27 | 255.255.255.224 | 32 | 30 | Small office subnet |
| /26 | 255.255.255.192 | 64 | 62 | Medium subnet |
| /25 | 255.255.255.128 | 128 | 126 | Half of /24 |
| /24 | 255.255.255.0 | 256 | 254 | Common LAN subnet |
| /16 | 255.255.0.0 | 65,536 | 65,534 | Large private network |
| /8 | 255.0.0.0 | 16,777,216 | 16,777,214 | Very large private network |

## Practice with CIDR.xyz

Use this link:

```text
https://cidr.xyz/
```

Practice examples:

```text
192.168.1.0/24
10.0.0.0/16
172.16.10.0/24
10.0.1.0/26
192.168.1.128/25
```

When you enter a CIDR block, observe:
- Network address
- Broadcast address
- First usable IP
- Last usable IP
- Total addresses
- Subnet mask
- Binary network/host bits

## Example: 192.168.1.0/24

```text
Network:        192.168.1.0
Subnet Mask:    255.255.255.0
Broadcast:      192.168.1.255
Usable Range:   192.168.1.1 - 192.168.1.254
Total IPs:      256
Usable Hosts:   254
```

## Example: 10.0.1.0/26

```text
CIDR:           10.0.1.0/26
Total IPs:      2^(32-26) = 64
Usable Hosts:   62
Subnet Mask:    255.255.255.192
```

/26 subnets inside 10.0.1.0/24:

```text
10.0.1.0/26      usable: 10.0.1.1 - 10.0.1.62
10.0.1.64/26     usable: 10.0.1.65 - 10.0.1.126
10.0.1.128/26    usable: 10.0.1.129 - 10.0.1.190
10.0.1.192/26    usable: 10.0.1.193 - 10.0.1.254
```

---

# 10. MAC Address and ARP

## MAC Address
A **MAC address** is a physical address of a network interface.

Example:

```text
00:1A:2B:3C:4D:5E
```

## ARP
**ARP** means **Address Resolution Protocol**.

## What ARP Does
ARP maps an IP address to a MAC address inside the local network.

Example:

```text
Who has 192.168.1.20?
Tell 192.168.1.10
```

The device with `192.168.1.20` replies with its MAC address.

## Useful Commands

```bash
ip neigh
arp -a
arp -n
```

---

# 11. Ports

## 
A **port** identifies an application/service running on a machine.

IP address finds the machine.  
Port finds the application on that machine.

Example:

```text
192.168.1.10:22
```

- `192.168.1.10` = server IP
- `22` = SSH service

## Common Ports

| Port | Protocol | Service |
|---:|---|---|
| 20/21 | TCP | FTP |
| 22 | TCP | SSH |
| 25 | TCP | SMTP |
| 53 | TCP/UDP | DNS |
| 67/68 | UDP | DHCP |
| 80 | TCP | HTTP |
| 110 | TCP | POP3 |
| 123 | UDP | NTP |
| 143 | TCP | IMAP |
| 443 | TCP | HTTPS |
| 3306 | TCP | MySQL |
| 5432 | TCP | PostgreSQL |
| 6379 | TCP | Redis |
| 8080 | TCP | Common web app/testing port |

---

# 12. TCP vs UDP

| Feature | TCP | UDP |
|---|---|---|
| Connection | Connection-oriented | Connectionless |
| Reliability | Reliable | Best effort |
| Speed | Slower than UDP | Faster than TCP |
| Ordering | Maintains order | No guaranteed order |
| Error Handling | Retransmission | No retransmission by default |
| Examples | HTTP, HTTPS, SSH, FTP, SMTP | DNS, DHCP, VoIP, streaming |

## TCP Example
TCP is like a phone call: connection is established, both sides communicate, and lost data can be resent.

## UDP Example
UDP is like sending a quick announcement: fast, but no guarantee that every packet arrives.

---

# 13. Important Protocols

| Protocol | Full Form | Purpose |
|---|---|---|
| HTTP | HyperText Transfer Protocol | Web traffic without encryption |
| HTTPS | HTTP Secure | Secure web traffic using TLS |
| TCP | Transmission Control Protocol | Reliable transport |
| UDP | User Datagram Protocol | Fast transport |
| TLS | Transport Layer Security | Encryption and secure communication |
| SSL | Secure Sockets Layer | Older encryption protocol; mostly replaced by TLS |
| ICMP | Internet Control Message Protocol | Ping and network error messages |
| FTP | File Transfer Protocol | File transfer |
| SFTP | SSH File Transfer Protocol | Secure file transfer over SSH |
| SMTP | Simple Mail Transfer Protocol | Sending email |
| DNS | Domain Name System | Domain name to IP resolution |
| DHCP | Dynamic Host Configuration Protocol | Automatically assigns IP addresses |
| SSH | Secure Shell | Secure remote login |

---

# 14. DNS

## 
DNS converts domain names into IP addresses.

Example:

```text
google.com -> IP address
```

## 
Humans remember names better than numbers.

## How DNS Works

```text
Browser -> DNS Resolver -> Root DNS -> TLD DNS -> Authoritative DNS -> IP Address
```

## DNS Record Types

| Record | Purpose |
|---|---|
| A | Domain to IPv4 address |
| AAAA | Domain to IPv6 address |
| CNAME | Alias to another domain name |
| MX | Mail server record |
| TXT | Text record, often used for verification/SPF/DKIM |
| NS | Name server record |
| PTR | Reverse DNS: IP to hostname |

## DNS Commands

```bash
nslookup example.com
dig example.com
host example.com
```

---

# 15. HTTP and HTTPS

## HTTP
HTTP is the protocol used by browsers and web servers.

Example request:

```http
GET / HTTP/1.1
Host: example.com
```

## HTTPS
HTTPS is HTTP plus TLS encryption.

```text
HTTP + TLS = HTTPS
```

## Common HTTP Status Codes

| Code | Meaning |
|---:|---|
| 200 | OK |
| 301/302 | Redirect |
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 500 | Internal Server Error |
| 502 | Bad Gateway |
| 503 | Service Unavailable |
| 504 | Gateway Timeout |

## DevOps curl Examples

```bash
curl -I https://example.com
curl -L -s -o /dev/null -w "%{http_code}\n" https://example.com
curl -v https://example.com
```

---

# 16. Routing

## 
Routing decides where packets should go next.

## 
If the destination is not in the local network, traffic must go through a router/gateway.

## Important Terms

| Term | Meaning |
|---|---|
| Route | Path to a network |
| Gateway | Next hop router |
| Default Route | Route used when no specific route matches |
| Routing Table | List of known routes |

## Linux Commands

```bash
ip route
ip route show
route -n
```

Example default route:

```text
default via 192.168.1.1 dev eth0
```

Meaning:
Traffic for unknown destinations goes to gateway `192.168.1.1` through interface `eth0`.

---

# 17. NAT

## 
**NAT** means **Network Address Translation**.

## 
Private IPs cannot directly communicate on the public internet. NAT translates private IP traffic to a public IP.

## Example

```text
Laptop private IP: 192.168.1.10
Router public IP:  76.x.x.x
Internet sees:     76.x.x.x
```

## AWS Example
Private subnets use a NAT Gateway or NAT instance to access the internet for updates, package downloads, or external APIs.

---

# 18. Firewall

## 
A firewall allows or blocks traffic based on rules.

## 
It protects systems from unwanted access.

## Linux Firewall Tools

| Tool | Purpose |
|---|---|
| iptables | Traditional Linux firewall tool |
| nftables | Modern Linux packet filtering framework |
| ufw | Simple firewall wrapper, common on Ubuntu |
| firewalld | Common on RHEL/CentOS/Fedora |

## Example Rules Concept

```text
Allow SSH from admin IP
Allow HTTP/HTTPS from internet
Block everything else
```

---

# 19. Load Balancers

## 
A load balancer distributes traffic across multiple backend servers.

## 
Load balancers improve:
- Availability
- Scalability
- Performance
- Fault tolerance

## Layer 4 vs Layer 7

| Type | Works At | Decision Based On | Example |
|---|---|---|---|
| Layer 4 Load Balancer | Transport layer | IP + Port | TCP/UDP load balancing |
| Layer 7 Load Balancer | Application layer | HTTP host/path/header | `/api` to app1, `/web` to app2 |

## Example

```text
User -> Load Balancer -> Web Server 1
                    -> Web Server 2
                    -> Web Server 3
```

## AWS Examples

| AWS Load Balancer | Layer | Use Case |
|---|---|---|
| ALB | Layer 7 | HTTP/HTTPS, path-based routing |
| NLB | Layer 4 | High performance TCP/UDP/TLS |
| GWLB | Layer 3/4 style appliance routing | Firewalls/security appliances |

---

# 20. Network Topologies

| Topology | Meaning | Common Use |
|---|---|---|
| Bus | All devices connected to one main cable | Old networks |
| Ring | Each device connects to two neighbors | Token ring style networks |
| Star | Devices connect to central switch/hub | Common LAN |
| Mesh | Devices connect to many/all others | High redundancy networks |
| Tree | Hierarchical network structure | Enterprise networks |
| Hybrid | Mix of multiple topologies | Real-world networks |

---

# 21. Linux Networking Commands

## Interface and IP Commands

```bash
ip addr
ip addr show
ip link
ip link show
ip link set eth0 down
ip link set eth0 up
```

Older command:

```bash
ifconfig
```

## Add IP Address Temporarily

```bash
sudo ip addr add 192.168.1.50/24 dev eth0
```

## Routing Commands

```bash
ip route
ip route show
route -n
```

## DNS Commands

```bash
nslookup google.com
dig google.com
host google.com
```

## Connectivity Commands

```bash
ping google.com
traceroute google.com
tracepath google.com
mtr google.com
```

## Socket/Port Commands

```bash
ss -tuln
netstat -tuln
lsof -i :80
```

## Download/Test Commands

```bash
curl https://example.com
curl -I https://example.com
wget https://example.com/file.zip
```

## Packet Capture

```bash
sudo tcpdump -i eth0
sudo tcpdump -i eth0 port 80
sudo tcpdump -n -i eth0
```

## Bandwidth/Monitoring

```bash
iftop
vnstat
bwm-ng
iperf
```

---

# 22. SSH and Remote Access

## SSH
SSH securely connects to a remote server.

```bash
ssh user@server-ip
ssh -i key.pem ubuntu@server-ip
```

## SCP
SCP securely copies files.

```bash
scp file.txt user@server-ip:/home/user/
scp -i key.pem file.txt ubuntu@server-ip:/home/ubuntu/
```

## SFTP
SFTP securely transfers files interactively.

```bash
sftp user@server-ip
```

---

# 23. Practical DevOps Troubleshooting Flow

## Problem: Website is Not Opening

Follow this order:

```text
1. Is my machine connected to network?
2. Can I ping gateway?
3. Can I resolve DNS?
4. Can I reach server IP?
5. Is the port open?
6. Is firewall/security group allowing traffic?
7. Is load balancer healthy?
8. Is application running?
9. Are logs showing errors?
```

## Commands

```bash
ip addr
ip route
ping 8.8.8.8
nslookup example.com
curl -I https://example.com
ss -tuln
sudo firewall-cmd --list-all
sudo ufw status
sudo journalctl -u nginx
```

---

# 24. Common Troubleshooting Scenarios

## Scenario 1: Server Has No Internet

Check IP:

```bash
ip addr
```

Check route:

```bash
ip route
```

Check DNS:

```bash
cat /etc/resolv.conf
nslookup google.com
```

Check direct IP connectivity:

```bash
ping 8.8.8.8
```

If ping to `8.8.8.8` works but DNS fails, the problem is likely DNS.

---

## Scenario 2: DNS Fails

```bash
nslookup google.com
dig google.com
cat /etc/resolv.conf
```

Possible fixes:

```bash
sudo nano /etc/resolv.conf
```

Add temporary DNS:

```text
nameserver 8.8.8.8
nameserver 1.1.1.1
```

---

## Scenario 3: Port Not Open

Check listening ports:

```bash
ss -tuln
```

Check specific port:

```bash
sudo lsof -i :80
```

Test remotely:

```bash
nc -vz server-ip 80
curl -I http://server-ip
```

---

## Scenario 4: SSH Not Working

Check:

```bash
ping server-ip
nc -vz server-ip 22
sudo systemctl status ssh
sudo systemctl status sshd
sudo ufw status
sudo firewall-cmd --list-all
```

Possible causes:
- Wrong IP
- SSH service stopped
- Port 22 blocked
- Wrong key permissions
- Security group/firewall issue
- Wrong username

---

## Scenario 5: Load Balancer Shows 502/503

Check:

```text
1. Are backend servers running?
2. Is app listening on correct port?
3. Is health check path correct?
4. Is security group/firewall allowing LB traffic?
5. Are logs showing app crash?
```

Commands:

```bash
curl -I http://backend-ip:port/health
ss -tuln
sudo journalctl -u app-service
```

---

# 25. Networking in AWS DevOps

## Important AWS Networking Concepts

| Concept | Meaning |
|---|---|
| VPC | Your private network in AWS |
| Subnet | Smaller network inside VPC |
| Public Subnet | Subnet with route to Internet Gateway |
| Private Subnet | Subnet without direct internet inbound access |
| Internet Gateway | Allows VPC resources to access internet publicly |
| NAT Gateway | Allows private subnet resources to access internet outbound |
| Route Table | Controls traffic paths |
| Security Group | Instance/load balancer level virtual firewall |
| NACL | Subnet level stateless firewall |
| ALB | Application Load Balancer |
| NLB | Network Load Balancer |
| VPC Peering | Connects two VPCs |
| VPN | Secure connection between networks |

## Example AWS VPC Design

```text
VPC: 10.0.0.0/16

Public Subnet 1:  10.0.1.0/24  -> Load Balancer, Bastion
Public Subnet 2:  10.0.2.0/24  -> Load Balancer
Private Subnet 1: 10.0.11.0/24 -> App Servers
Private Subnet 2: 10.0.12.0/24 -> App Servers
DB Subnet 1:      10.0.21.0/24 -> Database
DB Subnet 2:      10.0.22.0/24 -> Database
```

Traffic flow:

```text
User -> Internet -> ALB in Public Subnet -> App in Private Subnet -> DB in DB Subnet
```

---

# 26. Docker and Kubernetes Networking

## Docker Networking

| Network Type | Meaning |
|---|---|
| bridge | Default network for containers on one host |
| host | Container uses host network stack |
| none | No networking |
| overlay | Multi-host container networking, used in Swarm |

Useful commands:

```bash
docker network ls
docker network inspect bridge
docker run -p 8080:80 nginx
```

## Kubernetes Networking

Kubernetes networking connects:
- Pod to Pod
- Pod to Service
- Service to external users
- Ingress to Services

Key terms:

| Term | Meaning |
|---|---|
| Pod IP | IP assigned to a pod |
| ClusterIP | Internal service IP |
| NodePort | Exposes service on node port |
| LoadBalancer | Creates cloud load balancer |
| Ingress | HTTP/HTTPS routing into cluster |
| NetworkPolicy | Firewall-like rules for pods |

---

# 27. Interview Quick Answers

## What is a network?
A network is a group of connected devices that communicate and share data.

## What is an IP address?
An IP address is a logical address used to identify a device on a network.

## What is a subnet?
A subnet is a smaller part of a larger network.

## What is CIDR?
CIDR is a way to write IP networks using slash notation, such as `192.168.1.0/24`.

## What is DNS?
DNS converts domain names into IP addresses.

## What is TCP?
TCP is a reliable, connection-oriented transport protocol.

## What is UDP?
UDP is a faster, connectionless transport protocol without guaranteed delivery.

## What is a port?
A port identifies a specific service or application on a machine.

## What is a gateway?
A gateway is the exit point from one network to another.

## What is a load balancer?
A load balancer distributes traffic across multiple backend servers.

## What is NAT?
NAT translates private IP addresses to public IP addresses for internet communication.

## What is ARP?
ARP maps an IP address to a MAC address in a local network.

---

# 28. Daily Practice Lab

## Lab 1: Check Your IP

```bash
ip addr
```

## Lab 2: Check Default Gateway

```bash
ip route
```

## Lab 3: Test Internet Connectivity

```bash
ping 8.8.8.8
```

## Lab 4: Test DNS

```bash
nslookup google.com
```

## Lab 5: Test HTTP

```bash
curl -I https://google.com
```

## Lab 6: Check Open Ports

```bash
ss -tuln
```

## Lab 7: Trace Path

```bash
tracepath google.com
```

## Lab 8: Use CIDR.xyz

Open:

```text
https://cidr.xyz/
```

Try:

```text
192.168.1.0/24
192.168.1.0/25
192.168.1.0/26
10.0.0.0/16
10.0.1.0/24
```

Write down:
- Network address
- Broadcast address
- First usable IP
- Last usable IP
- Total IPs
- Usable hosts
- Subnet mask

---

# 29. Scratch to Hero Roadmap

| Level | Learn | Practice |
|---|---|---|
| Scratch | Network, IP, port, DNS, gateway | `ip addr`, `ping`, `nslookup` |
| Beginner | OSI, TCP/IP, TCP vs UDP | `curl`, `ss`, `ip route` |
| Intermediate | Subnetting, CIDR, NAT, firewall | CIDR.xyz, ufw/firewalld |
| DevOps | Load balancer, AWS VPC, subnets | Build VPC design |
| Advanced | tcpdump, mtr, iperf, troubleshooting | Packet capture and analysis |
| Hero | Kubernetes networking, service mesh, zero trust | Ingress, NetworkPolicy, TLS, observability |

---

# 30. One-Page Cheat Sheet

| Topic | Command/Concept |
|---|---|
| Show IP | `ip addr` |
| Show interfaces | `ip link` |
| Show routes | `ip route` |
| Show DNS config | `cat /etc/resolv.conf` |
| DNS lookup | `nslookup domain`, `dig domain` |
| Test connectivity | `ping host` |
| Trace route | `traceroute host`, `tracepath host`, `mtr host` |
| Show listening ports | `ss -tuln` |
| Test HTTP | `curl -I URL` |
| Test port | `nc -vz host port` |
| Capture packets | `tcpdump -i eth0` |
| Secure login | `ssh user@host` |
| Secure copy | `scp file user@host:/path` |
| Firewall Ubuntu | `ufw status` |
| Firewall RHEL | `firewall-cmd --list-all` |
| CIDR practice | `https://cidr.xyz/` |

---

# Final Summary

Networking is the foundation of DevOps. A DevOps engineer should understand how devices communicate, how IP addresses and ports work, how DNS resolves names, how routing moves packets, how firewalls protect systems, how load balancers distribute traffic, and how to troubleshoot issues using Linux commands. Start with `ip addr`, `ip route`, `ping`, `nslookup`, `curl`, and `ss`, then move to subnetting, CIDR, AWS VPC design, tcpdump, and Kubernetes networking.
