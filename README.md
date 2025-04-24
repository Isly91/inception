# 🐳 Inception - 42 Codam

Welcome to **Inception**.
This project is focused on understanding the fundamentals of containerization using **Docker**, building a secure and scalable infrastructure from the ground up.

---

## 🚀 Project Objective

The goal of this project is to **set up a personal virtual server** using **Docker**. You'll configure several Docker containers and services such as:

- Nginx (reverse proxy)
- WordPress
- MariaDB

All containers must be built using **Dockerfiles only**, with no use of pre-built images (except Debian), and managed with **Docker Compose**.

---

## 📦 Stack & Services

| Service   | Description                        |
|-----------|------------------------------------|
| Nginx     | Reverse proxy with SSL (TLSv1.2+)  |
| WordPress | CMS app running with PHP-FPM       |
| MariaDB   | WordPress database backend         |
| Redis     | Caching layer for WordPress        |
| Adminer   | Lightweight DB management tool     |
| Static    | PHP classic webpage (Blog)         |

---

## 🔐 Security Highlights

- All containers run as **non-root** users
- TLS encryption with **self-signed certificates**
- Proper file permissions & volumes
- Exposed services limited to what's necessary

---

## 🛠 Usage

- Sign in
- Comments for blog

### 1. Clone the repository
```bash
git clone https://github.com/Isly91/inception.git
cd inception
