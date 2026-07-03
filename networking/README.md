# Networking From Scratch to Hero — README

## Overview

This folder contains study notes for learning **Networking from scratch to hero**, especially for Linux, DevOps, cloud, and troubleshooting practice.

The main study notes explain networking concepts in a simple way, starting from the basics and moving toward practical DevOps-level topics.

## Main File

| File | Description |
|---|---|
| `networking-from-scratch-to-hero-study-notes.md` | Complete networking study notes from beginner to advanced level |

## What You Will Learn

| Topic | What It Covers |
|---|---|
| Networking Basics | What networking is, why we need it, and how devices communicate |
| OSI Model | 7 layers of networking and their purpose |
| TCP/IP Model | Practical internet communication model |
| IP Addressing | IPv4, IPv6, private IPs, public IPs, localhost |
| CIDR and Subnetting | Network IP, usable host range, broadcast IP, subnet masks |
| Class A, B, C | Private IP ranges and easy memory table |
| Ports and Protocols | TCP, UDP, HTTP, HTTPS, DNS, SSH, FTP, SMTP, and more |
| DNS | Domain name to IP address resolution |
| Routing | Gateway, routing table, default route |
| NAT | Private IP to public IP translation |
| Firewall | Basic packet filtering and security |
| Load Balancer | Distributing traffic across servers |
| Linux Commands | `ip`, `ping`, `ss`, `netstat`, `dig`, `nslookup`, `traceroute`, `tcpdump`, etc. |
| DevOps Networking | AWS VPC, Docker networking, Kubernetes networking basics |
| Troubleshooting | Step-by-step commands to diagnose network issues |

## Suggested Learning Order

```text
1. Networking basics
2. OSI and TCP/IP models
3. IP address, subnet, CIDR
4. Private IP ranges and classes A, B, C
5. Localhost, network IP, broadcast IP
6. Ports and protocols
7. DNS, HTTP, HTTPS
8. Routing, gateway, NAT
9. Firewalls and security
10. Load balancers
11. Linux networking commands
12. AWS, VPC, Docker, Kubernetes networking
13. Troubleshooting labs
```

## Important Practice Website

Use this website for CIDR and subnetting practice:

```text
https://cidr.xyz/
```

It helps you visually understand:

- Network address
- Broadcast address
- First usable IP
- Last usable IP
- Subnet mask
- Number of usable hosts
- CIDR notation

## Recommended Practice

Try these examples in CIDR.xyz:

| CIDR | Practice Goal |
|---|---|
| `192.168.1.0/24` | Understand normal home/lab subnet |
| `192.168.1.0/25` | Split `/24` into two networks |
| `192.168.1.0/26` | Split `/24` into four networks |
| `10.0.0.0/8` | Understand large private network |
| `172.16.0.0/12` | Understand private Class B range |
| `127.0.0.1/8` | Understand localhost/loopback |

## Quick Revision Table

| Term | Full Form / Meaning |
|---|---|
| CIDR | Classless Inter-Domain Routing |
| OSI | Open Systems Interconnection |
| TCP | Transmission Control Protocol |
| UDP | User Datagram Protocol |
| IP | Internet Protocol |
| HTTP | HyperText Transfer Protocol |
| HTTPS | HyperText Transfer Protocol Secure |
| DNS | Domain Name System |
| DHCP | Dynamic Host Configuration Protocol |
| ARP | Address Resolution Protocol |
| ICMP | Internet Control Message Protocol |
| SSH | Secure Shell |
| FTP | File Transfer Protocol |
| NAT | Network Address Translation |
| VPN | Virtual Private Network |
| LAN | Local Area Network |
| WAN | Wide Area Network |
| VPC | Virtual Private Cloud |

## How to Study These Notes

1. Read one section at a time.
2. Write the command examples by hand.
3. Practice CIDR examples using `https://cidr.xyz/`.
4. Run Linux networking commands in WSL, Ubuntu, RHEL, or an EC2 instance.
5. Create small troubleshooting scenarios and fix them step by step.

## Basic Lab Commands

```bash
ip addr
ip route
ping google.com
ping 8.8.8.8
dig google.com
nslookup google.com
traceroute google.com
ss -tuln
curl -I https://google.com
```

## Good For

- Linux administration
- DevOps interviews
- AWS networking basics
- Docker and Kubernetes networking foundation
- Troubleshooting real network issues
- Building strong subnetting and CIDR understanding

## Final Note

Networking becomes easy when you learn it in this order:

```text
Device
-> IP Address
-> Subnet
-> Gateway
-> DNS
-> Port
-> Protocol
-> Route
-> Firewall
-> Load Balancer
-> Application
```

Practice slowly and repeatedly. Networking is not memorization only; it becomes strong through labs and troubleshooting.
