# Developer Documentation — Inception

This document outlines the setup procedure, container management commands, and data architecture for developers maintaining or expanding the Inception project.

---

## 1. Setting Up the Environment from Scratch

### Prerequisites
* A clean **Debian / Linux** environment.
* Installed software: **Docker Engine** and **Docker Compose**.
* `sudo` privileges (or user added to the `docker` group).

### Domain Name Configuration
Map the local domain name to `localhost` in `/etc/hosts`:

```
echo "127.0.0.1 kapinarc.42.fr" | sudo tee -a /etc/hosts
```

### Environment Configuration & Secrets
Create the `.env` file inside the `srcs/` directory before building the stack:

```
cp srcs/.env.example srcs/.env
vim srcs/.env
```

Mandatory variables required in `srcs/.env`:

```env
DOMAIN_NAME=kapinarc.42.fr

# MariaDB
MYSQL_ROOT_PASSWORD=your_root_password
MYSQL_DATABASE=wordpress
MYSQL_USER=your_user
MYSQL_PASSWORD=your_user_password

# WordPress
WP_TITLE=Inception
WP_ADMIN_USER=admin_user
WP_ADMIN_PASSWORD=admin_password
WP_ADMIN_EMAIL=admin@student.42.fr
```

---

## 2. Building and Launching the Infrastructure

All build and execution commands are centralized in the `Makefile` located at the repository root.

* **Build images and launch containers**:
  ```
  make
  ```
* **Rebuild the entire infrastructure from scratch**:
  ```
  make re
  ```
* **Full cleanup (removes containers, networks, images, and persistent volumes)**:
  ```
  make fclean
  ```

---

## 3. Useful Developer Commands

### Interacting with Containers
* **Execute a shell in a running container**:
  ```
  docker exec -it wordpress bash
  docker exec -it mariadb bash
  docker exec -it nginx bash
  ```

* **Inspect database tables directly**:
  ```
  docker exec -it mariadb mariadb -u kapinarc -p -h 127.0.0.1
  ```

### Network Debugging
* **Test inter-container connectivity**:
  ```
  docker exec -it wordpress ping -c 2 mariadb
  docker exec -it nginx ping -c 2 wordpress
  ```

---

## 4. Data Storage and Persistence

Data persistence is handled via **Docker Volumes** bound to specific paths on the VM host machine, ensuring data is retained even if containers are destroyed.

* **WordPress Site Files**:
  * **Container Path**: `/var/www/wordpress`
  * **Host Path**: `/home/kapinarc/data/wordpress`
* **MariaDB Database Files**:
  * **Container Path**: `/var/lib/mysql`
  * **Host Path**: `/home/kapinarc/data/mariadb`

### Volume Inspection Commands
To list and inspect active Docker volumes:

```
docker volume ls
docker volume inspect srcs_wordpress_data
docker volume inspect srcs_mariadb_data
```