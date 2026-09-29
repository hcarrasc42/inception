This project was built as part of the 42 cursus by hcarrasc42.

# Inception

> _One service per container, built from scratch, wired together by hand._

A small infrastructure built entirely with **Docker**: a WordPress site served
over TLS, backed by its own database, with each service in its own container —
all defined by hand-written Dockerfiles and a single `docker-compose` file.

![Tooling](https://img.shields.io/badge/docker-compose-2496ED?style=flat-square)
![Base](https://img.shields.io/badge/base-Debian%20bullseye-A81D33?style=flat-square)
![TLS](https://img.shields.io/badge/TLS-1.3-green?style=flat-square)

## 📖 About

Inception is a system-administration project about containerization done
properly. The rules are strict: every service runs in its **own** container,
built from a **custom Dockerfile** (no pulling ready-made application images),
based on a chosen stable OS image; containers must restart on failure, talk to
each other over a dedicated network, and persist their data in volumes.

The result is a classic three-tier web stack:

```
        HTTPS :443 (TLS 1.3)
                │
             ┌──▼───┐      ┌───────────┐      ┌──────────┐
  client ───►│ nginx│─────►│ wordpress │─────►│ mariadb  │
             │ (TLS)│ php  │ (php-fpm) │ sql  │ (db)     │
             └──────┘      └───────────┘      └──────────┘
                    inception bridge network
```

## ✨ Key Features

- **Three custom-built containers**, each from its own Dockerfile on `debian:bullseye`:
  - **NGINX** — the only entry point, exposed on `443` only, serving over
    **TLS 1.3** with a self-signed certificate.
  - **WordPress + php-fpm** — the application tier, with no exposed port; only
    NGINX talks to it.
  - **MariaDB** — the database tier, initialized on first run.
- **`docker-compose` orchestration:** services, build contexts, dependencies
  (`depends_on`), the shared network, and volumes all declared in one file.
- **Persistent storage** via named volumes bind-mounted to the host, so the
  WordPress files and the database survive container restarts.
- **Isolated bridge network** (`inception`) — containers reach each other by
  service name, and nothing is exposed except the HTTPS port.
- **`restart: always`** on every service for resilience.
- **No secrets in images:** configuration and credentials are injected at runtime
  through an `.env` file (not committed).
- **A `Makefile`** wrapping the common lifecycle (`build`, `up`, `down`, `clean`).

## 🛠 Technologies

| Component | Detail |
|-----------|--------|
| Containerization | Docker, `docker-compose` |
| Base image | `debian:bullseye` (all three services) |
| Web server | NGINX (TLS 1.3, self-signed cert) |
| Application | WordPress served through php-fpm |
| Database | MariaDB |
| Config | `.env` file + per-service `conf/` and entrypoint `tools/*.sh` |

## 🏗 Architecture

Each service directory follows the same layout — a `Dockerfile`, a `conf/` folder
with its configuration, and a `tools/` entrypoint script that prepares and then
launches the service in the foreground (so the container's main process stays
alive and Docker can supervise it):

```
srcs/
├── docker-compose.yml
└── requirements/
    ├── nginx/       Dockerfile · conf/default        · tools/nginx.sh
    ├── wordpress/   Dockerfile · conf/www.conf       · tools/wordpress.sh
    └── mariadb/     Dockerfile · conf/{my.cnf,init.sql} · tools/mariadb.sh
```

Data flow: the client reaches **only** NGINX over HTTPS; NGINX forwards PHP
requests to WordPress via php-fpm; WordPress persists content in MariaDB over the
private network. WordPress files and MySQL data live in host-bound volumes.

## 🚀 How to Run

> Requires Docker and `docker-compose`, and an `.env` file in `srcs/` providing
> the domain and the database/WordPress credentials.

```sh
make          # set up data dirs, build the images, and start the stack
make down     # stop the containers
make fclean   # stop and clean up
```

Then browse to `https://<your-domain>` (accept the self-signed certificate).

## 📂 Project Structure

```
inception/
└── Inception/
    ├── Makefile
    └── srcs/
        ├── docker-compose.yml
        └── requirements/
            ├── nginx/
            ├── wordpress/
            └── mariadb/
```

## 💡 What This Project Demonstrates

- **Containerization fundamentals:** writing Dockerfiles from a base OS image,
  keeping one process per container, and using proper entrypoints.
- **Multi-service orchestration** with `docker-compose`: networks, volumes,
  service dependencies, and restart policies.
- **Web-stack administration:** NGINX as a TLS-terminating reverse proxy in front
  of php-fpm/WordPress and a MariaDB backend.
- **Secure-by-default choices:** TLS-only ingress, a private network, secrets kept
  out of images and injected via environment.
- **Reproducible infrastructure** described entirely as code.
