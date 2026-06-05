# Developer Documentation

## Environment Setup

This project must run inside a virtual machine with Docker and Docker Compose installed.

Required host preparation:

```bash
sudo mkdir -p /home/natferna/data/mariadb
sudo mkdir -p /home/natferna/data/wordpress
sudo chown -R "$USER:$USER" /home/natferna/data
```

Add the domain to `/etc/hosts`:

```bash
sudo sh -c 'echo "127.0.0.1 natferna.42.fr" >> /etc/hosts'
```

## Configuration Files

Main files:

- `Makefile`: project commands.
- `srcs/docker-compose.yml`: service, network, volume, and secret definitions.
- `srcs/.env`: non-sensitive configuration.
- `secrets/*.txt`: confidential values.

Service files:

- `srcs/requirements/mariadb/Dockerfile`
- `srcs/requirements/wordpress/Dockerfile`
- `srcs/requirements/nginx/Dockerfile`

## Secrets

Create the secrets before launching the stack:

```bash
printf 'your-root-password\n' > secrets/db_root_password.txt
printf 'your-database-password\n' > secrets/db_password.txt
printf 'your-wordpress-owner-password\n' > secrets/wp_admin_password.txt
printf 'your-wordpress-user-password\n' > secrets/wp_user_password.txt
```

The Dockerfiles do not contain passwords. Containers read secrets from `/run/secrets`.

## Build and Launch

Build images and launch containers:

```bash
make
```

Build only:

```bash
make build
```

Stop containers:

```bash
make down
```

Rebuild from scratch:

```bash
make re
```

## Container and Volume Management

List containers:

```bash
make ps
```

View logs:

```bash
make logs
```

Remove containers and Docker volumes:

```bash
make clean
```

Remove containers, volumes, images, and host data:

```bash
make fclean
```

## Data Persistence

MariaDB data is stored in:

```text
/home/natferna/data/mariadb
```

WordPress files are stored in:

```text
/home/natferna/data/wordpress
```

The containers can be removed and recreated while keeping the data, as long as these directories and their Docker volumes are not deleted.

## Defense Notes

NGINX is the only public entrypoint because the subject requires access only through port 443. WordPress and MariaDB are isolated on the internal Docker network.

Each container runs one main foreground process:

- NGINX runs with `daemon off`.
- WordPress runs `php-fpm8.2 -F`.
- MariaDB runs `mariadbd --console`.

No container is kept alive with an infinite loop such as `tail -f`, `sleep infinity`, or `while true`.
