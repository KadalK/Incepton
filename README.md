*This project has been created as part of the 42 curriculum by kapinarc.*

# Inception - 42 School Project

![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)
![WordPress](https://img.shields.io/badge/WordPress-%21117D.svg?style=for-the-badge&logo=wordpress&logoColor=white)
![MariaDB](https://img.shields.io/badge/MariaDB-003545?style=for-the-badge&logo=mariadb&logoColor=white)

---

## Description

The goal of the **Inception** project is to broaden system administration knowledge by building a complete web infrastructure using **Docker** and **Docker Compose**. 

The project requires setting up a multi-container architecture running a LEMP stack (Linux, NGINX, MariaDB, WordPress) inside a dedicated Debian Virtual Machine. Every service runs in its own isolated container and is built using tailored Dockerfiles from a bare Debian stable base image.

### Key Rules & Requirements
* **No pre-built images** from Docker Hub (except the bare Debian base image).
* **HTTPS only** on port `443` with TLS v1.2 or TLS v1.3.
* **Data persistence** configured via Docker volumes stored directly on the host machine.
* **Custom domain redirection** using `kapinarc.42.fr`.

---

## Architecture & Design Choices

                     [ Client / Browser ]
                               │
                         Port 443 (TLS v1.2/v1.3)
                               ▼
               ┌──────────────────────────────┐
               │        NGINX Container       │
               │  (Reverse Proxy / SSL TLS)   │
               └──────────────┬───────────────┘
                              │ Port 9000 (FastCGI)
                              ▼
               ┌──────────────────────────────┐
               │     WordPress Container      │
               │        (PHP-FPM 8.2)         │
               └──────────────┬───────────────┘
                              │ Port 3306 (MySQL)
                              ▼
               ┌──────────────────────────────┐
               │      MariaDB Container       │
               │         (Database)           │
               └──────────────────────────────┘



### Technical Comparisons & Concepts

#### 1. Virtual Machines vs Docker
* **Virtual Machines (VMs)**: Hypervisors emulate full hardware systems. Each VM runs a complete guest operating system, which consumes significant memory, disk space, and CPU overhead.
* **Docker Containers**: Containers share the host OS kernel and isolate application processes at the user space level. They are lightweight, start in seconds, and consume minimal resources compared to full VMs.

#### 2. Secrets vs Environment Variables
* **Environment Variables (`.env`)**: Passed directly into process environments. They are simple to set up but can accidentally be leaked via process inspection (`docker inspect`), debugging logs, or shell histories.
* **Docker Secrets**: Encrypted at rest and in transit (in Swarm mode), secrets are mounted into containers as in-memory files (typically under `/run/secrets/`). They prevent credentials from exposing in environment outputs or image layers.

#### 3. Docker Network vs Host Network
* **Host Network (`--net=host`)**: The container shares the network stack directly with the host machine. There is no network isolation, and container ports bind directly to host ports.
* **Docker Network (Bridge / Private Driver)**: Creates an isolated virtual network bridge. Containers communicate securely using internal IP addresses or service aliases (DNS), exposing only strictly defined ports to the host or outside world.

#### 4. Docker Volumes vs Bind Mounts
* **Bind Mounts**: Mount an exact file or directory from the host filesystem into the container. Performance depends on host paths, and permission mismatches between host and container users can easily occur.
* **Docker Volumes**: Managed directly by Docker within storage areas (`/var/lib/docker/volumes/`). They decouple container storage from the host structure, offer better performance on non-Linux hosts, and support easier backup/migration workflows.

---

## 🚀 Instructions

### Prerequisites
* A working **Debian / Linux** machine.
* **Docker** and **Docker Compose** installed.
* `sudo` access or your user added to the `docker` group.

### 1. Local Domain Setup
Add the required domain name to your host `/etc/hosts` file:
```bash
echo "127.0.0.1 kapinarc.42.fr" | sudo tee -a /etc/hosts

## ENVIRONEMENT CONFIGURATION

create a .env file in srcs/ dir containing your credentials:

cp srcs/.env.example srcs/.env
vim srcs/.env

## EXECUTION COMMANDE (Makefile)

Build and start all services:
make
Stop running containers:
make stop
Start stopped containers:
make start
Clean up containers ans networks:
make clean
FUll cleanup:
make fclean
Rebuild the entire infrastructure:
make re

## COMMANDS FOR EXPLORE DATABASES AND TABLES
Enter into the docker:
docker exec -it mariadb mariadb -u kapinarc -p
Show all databases:
SHOW DATABASES;
Enter in the database of your choice (ex: wordpress):
USE wordpress;
Display all tables:
SHOW TABLES;
For see columns ans type of tables (ex: wp_users):
Describe wp_users;
For see all datas register in this table:
SELECT * FROM wp_users;
and "EXIT;" for quit


## ACCESSING THE APPLICATION
Once lauched, acces the application via your browser:
- Website: https://kapinarc.42.fr
- Wordpress Admin Panel: https://kapinarc.42.fr/wp-admin
(Note: You must accespt the browser safety warning regarding self-signed TLS certif).

## RESOURCES
Documentation & References:

Docker Official Documentation
Docker Compose Specification
NGINX Administration Guide
MariaDB Knowledge Base
WP-CLI Command Reference


## USE OF ARTIFICIAL INTELLIGENCE (AI)
In accordance with 42 evaluation policies, AI assistance was utilized during this project for the following tasks:

Debugging Configuration Errors: Assisted in identifying missing closing brackets and directive syntax in nginx.conf logs.

Troubleshooting Runtime Errors: Used to diagnose disk quota issues (VERR_DISK_FULL) and container lifecycle behaviors (Restarting statuses).

Documentation & Formatting: Aided in generating structured Markdown documentation and README templates.
