```markdown
*This project was created as part of the 42 curriculum by **kapinarc**.*

# Inception - 42 School Project

![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)
![WordPress](https://img.shields.io/badge/WordPress-%21117D.svg?style=for-the-badge&logo=wordpress&logoColor=white)
![MariaDB](https://img.shields.io/badge/MariaDB-003545?style=for-the-badge&logo=mariadb&logoColor=white)

---

## 📝 Description# User Documentation — Inception

This document provides simple instructions for administrators or end users to manage, access, and verify the Inception infrastructure.

---

## 1. Provided Services

The infrastructure runs three main isolated services:

* **NGINX**: Acts as the sole entry point (TLS/SSL Reverse Proxy) exposed on port `443`.
* **WordPress**: Runs the PHP-FPM application server hosting the website.
* **MariaDB**: Operates the database storing WordPress site data and configuration.

---

## 2. Starting and Stopping the Project

All service management commands are executed from the root of the project repository via the `Makefile`.

* **Start the project**:
  ```
  make
  ```
* **Stop the project**:
  ```
  make stop
  ```
* **Restart the project**:
  ```
  make start
  ```
* **Completely stop and purge containers and networks**:
  ```
  make clean
  ```

---

## 3. Accessing the Website and Administration Panel

Open your web browser and navigate to:

* **Public Website**: [https://kapinarc.42.fr](https://kapinarc.42.fr)
* **WordPress Admin Panel**: [https://kapinarc.42.fr/wp-admin](https://kapinarc.42.fr/wp-admin)

> **Note**: Because the project uses a self-signed TLS certificate, your browser will display a security warning. Click **Advanced** $\rightarrow$ **Proceed to site (unsafe)** to continue.

---

## 4. Credentials Location & Management

Credentials and environment parameters are stored in the configuration file located at:

```text
srcs/.env
```

To view or update credentials:

```
nano srcs/.env
```

Key credentials defined in `.env`:
* **WordPress Administrator**: `WP_ADMIN_USER` / `WP_ADMIN_PASSWORD`
* **MariaDB Database User**: `MYSQL_USER` / `MYSQL_PASSWORD`
* **MariaDB Root Account**: `MYSQL_ROOT_PASSWORD`

---

## 5. Checking Service Status

To verify that all services are up and running properly:

1. **Check container states**:
   ```
   docker ps
   ```
   *All three containers (`nginx`, `wordpress`, `mariadb`) should display a status of `Up`.*

2. **Inspect service logs**:
   ```bash
   docker logs nginx
   docker logs wordpress
   docker logs mariadb
   ```

The goal of the **Inception** project is to broaden system administration knowledge by building a complete web infrastructure using **Docker** and **Docker Compose**. 

The project requires setting up a multi-container architecture running a LEMP stack (Linux, NGINX, MariaDB, WordPress) inside a dedicated Debian Virtual Machine. Every service runs in its own isolated container and is built using tailored Dockerfiles from a bare Debian stable base image.

### 🔑 Key Rules & Requirements
* **No pre-built images** from Docker Hub (except the bare Debian base image).
* **HTTPS only** on port `443` with TLS v1.2 or TLS v1.3.
* **Data persistence** configured via Docker volumes stored directly on the host machine.
* **Custom domain redirection** using `kapinarc.42.fr`.

---

## 🛠️ Architecture & Design Choices

```text
                     [ Client / Browser ]
                               │
                    Port 443 (TLS v1.2/v1.3)
                               ▼
               ┌──────────────────────────────┐
               │       NGINX Container        │
               │  (Reverse Proxy / SSL TLS)   │
               └──────────────┬───────────────┘
                              │ Port 9000 (FastCGI)
                              ▼
               ┌──────────────────────────────┐
               │     WordPress Container      │
               │        (PHP-FPM)             │
               └──────────────┬───────────────┘
                              │ Port 3306 (MySQL)
                              ▼
               ┌──────────────────────────────┐
               │      MariaDB Container       │
               │          (Database)          │
               └──────────────────────────────┘
```

### 💡 Technical Comparisons & Concepts

#### 1. Virtual Machines vs Docker
* **Virtual Machines (VMs)**: Hypervisors emulate full hardware systems. Each VM runs a complete guest operating system, consuming significant memory, disk space, and CPU overhead.
* **Docker Containers**: Containers share the host OS kernel and isolate application processes at the user-space level. They are lightweight, start in seconds, and consume minimal resources compared to full VMs.

#### 2. Secrets vs Environment Variables
* **Environment Variables (`.env`)**: Passed directly into process environments. They are simple to set up but can accidentally be leaked via process inspection (`docker inspect`), debugging logs, or shell histories.
* **Docker Secrets**: Encrypted at rest and in transit (in Swarm mode), secrets are mounted into containers as in-memory files (typically under `/run/secrets/`). They prevent credentials from being exposed in environment outputs or image layers.

#### 3. Docker Network vs Host Network
* **Host Network (`--net=host`)**: The container shares the network stack directly with the host machine. There is no network isolation, and container ports bind directly to host ports.
* **Docker Network (Bridge / Private Driver)**: Creates an isolated virtual network bridge. Containers communicate securely using internal IP addresses or service aliases (DNS), exposing only strictly defined ports to the host or outside world.

#### 4. Docker Volumes vs Bind Mounts
* **Bind Mounts**: Mount an exact file or directory from the host filesystem into the container. Performance depends on host paths, and permission mismatches between host and container users can easily occur.
* **Docker Volumes**: Managed directly by Docker within storage areas (`/var/lib/docker/volumes/`). They decouple container storage from the host structure, offer better performance on non-Linux hosts, and support easier backup/migration workflows.

---

## 🚀 Getting Started

### Prerequisites
* A working **Debian / Linux** machine.
* **Docker** and **Docker Compose** installed.
* `sudo` access or your user added to the `docker` group.

### 1. Local Domain Setup
Add the required domain name to your host `/etc/hosts` file:
```bash
echo "127.0.0.1 kapinarc.42.fr" | sudo tee -a /etc/hosts
```

### 2. Environment Configuration
Create a `.env` file in the `srcs/` directory containing your credentials:
```bash
cp srcs/.env.example srcs/.env
vim srcs/.env
```

---

## ⚙️ Management Commands (Makefile)

| Command | Description |
| :--- | :--- |
| `make` / `make all` | Builds and starts all infrastructure containers |
| `make stop` | Stops running containers without removing them |
| `make start` | Starts existing stopped containers |
| `make clean` | Stops and removes containers, networks, and images |
| `make fclean` | Complete cleanup: removes containers, networks, images, and **volumes** |
| `make re` | Rebuilds the entire infrastructure from scratch |

---

## 🗄️ Database Management

To connect to the MariaDB container and inspect your database:

```
# 1. Connect to the MariaDB container
docker exec -it mariadb mariadb -u kapinarc -p -h 127.0.0.1
```

Once connected to the MariaDB shell:

```
-- Show all available databases
SHOW DATABASES;

-- Select the WordPress database
USE wordpress;

-- Display all tables in the current database
SHOW TABLES;

-- Describe the structure of a specific table (e.g., wp_users)
DESCRIBE wp_users;

-- Retrieve registered user data
SELECT * FROM wp_users;

-- Exit the MariaDB shell
EXIT;
```

---

## 🌐 Accessing the Application

Once launched, access the application via your web browser:

* **Website**: [https://kapinarc.42.fr](https://kapinarc.42.fr)
* **WordPress Admin Panel**: [https://kapinarc.42.fr/wp-admin](https://kapinarc.42.fr/wp-admin)

*(Note: You must accept the browser safety warning regarding self-signed TLS certificates).*

---

## 📚 Resources & Documentation

* [Docker Official Documentation](https://docs.docker.com/)
* [Docker Compose Specification](https://docs.docker.com/compose/)
* [NGINX Administration Guide](https://nginx.org/en/docs/)
* [MariaDB Knowledge Base](https://mariadb.com/kb/en/)
* [WP-CLI Command Reference](https://developer.wordpress.org/cli/commands/)

---

## 🤖 Use of Artificial Intelligence (AI)

In accordance with 42 evaluation policies, AI assistance was utilized during this project for the following tasks:

* **Debugging Configuration Errors**: Assisted in identifying missing closing brackets and directive syntax in `nginx.conf` logs.
* **Troubleshooting Runtime Errors**: Used to diagnose disk quota issues (`VERR_DISK_FULL`) and container lifecycle behaviors (`Restarting` statuses).
* **Documentation & Formatting**: Aided in generating structured Markdown documentation and README templates.
```