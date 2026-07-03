# Advanced Networking MCQs Quiz — README

## Overview

This HTML quiz is an advanced practice test for the **Networking From Scratch to Hero** study notes.

It is designed for Linux, DevOps, cloud, Docker, Kubernetes, and troubleshooting practice.

## Main File

| File | Description |
|---|---|
| `advanced-networking-mcqs-quiz.html` | Advanced networking MCQs quiz with timer, score, answer checking, and explanations |

## Quiz Features

| Feature | Description |
|---|---|
| Advanced MCQs | Covers beginner to advanced networking topics |
| Timer | 40-minute countdown timer |
| Score | Shows final score after submission |
| Answer Checking | Marks answers correct or wrong |
| Short Explanations | Each question includes a short explanation |
| Show Answers | Allows quick revision after practice |
| Reset Button | Restarts the quiz |
| Print Option | Allows printing or saving as PDF |
| Mobile Friendly | Works on laptop, desktop, tablet, and phone |

## Topics Covered

| Topic | Details |
|---|---|
| Networking Basics | What networking is and why it is needed |
| OSI Model | Physical, Data Link, Network, Transport, Session, Presentation, Application |
| TCP/IP Model | Practical internet communication model |
| CIDR | Classless Inter-Domain Routing and prefix notation |
| Subnetting | Network IP, usable IP range, broadcast IP |
| Private IP Ranges | Class A, Class B, Class C private ranges |
| Localhost | 127.0.0.1 and loopback testing |
| TCP and UDP | Reliable vs fast connectionless communication |
| HTTP and HTTPS | Web traffic and secure web traffic |
| DNS | Domain name resolution |
| DHCP | Automatic IP configuration |
| ARP | IP address to MAC address mapping |
| ICMP | Ping and network error messages |
| Routing | Default gateway and routing table |
| NAT | Private IP to public IP translation |
| Firewall | Packet filtering and access control |
| Load Balancer | Distributing traffic across servers |
| Linux Commands | `ip`, `ss`, `ping`, `dig`, `nslookup`, `traceroute`, `curl`, `tcpdump` |
| AWS Networking | VPC, Internet Gateway, NAT Gateway, Security Groups |
| Docker Networking | Bridge networking basics |
| Kubernetes Networking | Service and Pod access basics |
| Troubleshooting | Practical step-by-step network diagnosis |

## How to Use

1. Open the file:

```text
advanced-networking-mcqs-quiz.html
```

2. The quiz will start automatically with a timer.

3. Select one answer for each question.

4. Click:

```text
Submit Quiz
```

5. Review your score, correct answers, wrong answers, and explanations.

## Recommended Practice Method

Use this quiz in three rounds:

| Round | Goal |
|---|---|
| Round 1 | Try without looking at notes |
| Round 2 | Review explanations and weak topics |
| Round 3 | Retake and aim for 90% or higher |

## Passing Target

| Score | Level |
|---|---|
| 90% or higher | Excellent |
| 75% - 89% | Very good |
| 60% - 74% | Good start |
| Below 60% | Review notes and practice again |

## Suggested Study Order Before Quiz

```text
1. Networking basics
2. OSI and TCP/IP models
3. IP addressing
4. CIDR and subnetting
5. Network IP and broadcast IP
6. Ports and protocols
7. DNS, HTTP, HTTPS
8. Routing and gateway
9. NAT and firewall
10. Load balancer
11. Linux networking commands
12. AWS VPC networking
13. Docker and Kubernetes networking
14. Troubleshooting labs
```

## Practice Website for CIDR

Use this website for subnetting and CIDR practice:

```text
https://cidr.xyz/
```

Practice examples:

| CIDR | What to Check |
|---|---|
| `192.168.1.0/24` | Network IP, usable range, broadcast IP |
| `192.168.1.0/25` | Splitting one network into two |
| `192.168.1.0/26` | Splitting one network into four |
| `10.0.0.0/8` | Large private network |
| `172.16.0.0/12` | Class B private range |
| `192.168.0.0/16` | Class C private range |
| `127.0.0.1/8` | Localhost / loopback |

## Basic Linux Commands to Practice

```bash
ip addr
ip route
ping 8.8.8.8
ping google.com
dig google.com
nslookup google.com
traceroute google.com
ss -tuln
curl -I https://google.com
tcpdump -i eth0
```

## Best For

- DevOps interview preparation
- Linux networking practice
- AWS VPC basic understanding
- Docker and Kubernetes networking foundation
- Troubleshooting practice
- CIDR and subnetting revision
- Classroom and student testing

## Final Note

Do not only memorize answers. Try to understand **why** each answer is correct.

Networking becomes strong when you practice this flow:

```text
IP
-> Subnet
-> Gateway
-> DNS
-> Port
-> Protocol
-> Firewall
-> Application
```

Repeat the quiz after reviewing mistakes.
