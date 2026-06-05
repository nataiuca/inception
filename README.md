*This project has been created as part of the 42 curriculum by natferna.*

# Inception

## Description

Inception is a system administration project based on Docker. The goal is to build a small infrastructure composed of independent services running in dedicated containers.

The mandatory stack contains:

- NGINX as the only public entrypoint, exposed only on port 443 with TLSv1.2/TLSv1.3.
- WordPress with PHP-FPM, without NGINX.
- MariaDB, without NGINX.
- A private Docker network shared by the services.
- Two Docker named volumes for persistent data.

The domain used by this project is:

```text
natferna.42.fr
```

## Instructions

Before starting the project, make sure Docker and Docker Compose are installed on the virtual machine.

Add the local domain to `/etc/hosts`:

```bash
sudo sh -c 'echo "127.0.0.1 natferna.42.fr" >> /etc/hosts'
```

Create the data directories:

```bash
sudo mkdir -p /home/natferna/data/mariadb
sudo mkdir -p /home/natferna/data/wordpress
sudo chown -R "$USER:$USER" /home/natferna/data
```

Create the secret files in the `secrets` directory before launching the stack:

```bash
printf 'your-root-password\n' > secrets/db_root_password.txt
printf 'your-database-password\n' > secrets/db_password.txt
printf 'your-wordpress-owner-password\n' > secrets/wp_admin_password.txt
printf 'your-wordpress-user-password\n' > secrets/wp_user_password.txt
```

Start the project:

```bash
make
```

Check running containers:

```bash
make ps
```

Stop the project:

```bash
make down
```

Remove containers and volumes:

```bash
make clean
```

Remove containers, volumes, images, and host data:

```bash
make fclean
```

## Project Description

### Docker and Project Sources

Each service has its own Dockerfile and is built from `debian:bookworm`, without using ready-made service images. Docker Compose builds the images and starts the containers.

The source tree is organized under `srcs/requirements`, with one directory per service:

- `mariadb`: database installation, configuration, and initialization script.
- `wordpress`: PHP-FPM, WordPress installation, and WordPress user creation.
- `nginx`: TLS certificate generation and HTTPS reverse proxy configuration.

### Virtual Machines vs Docker

A virtual machine runs a complete guest operating system with its own kernel. Docker containers share the host kernel and isolate processes using Linux features such as namespaces and cgroups. Containers are lighter, faster to start, and better suited for splitting services into small units.

### Secrets vs Environment Variables

Environment variables are useful for non-sensitive configuration, such as domain names, database names, and usernames. Secrets are better for confidential values because they are mounted as files at runtime and are not written directly into Dockerfiles.

### Docker Network vs Host Network

The project uses a custom Docker bridge network. Containers can communicate by service name, for example WordPress connects to `mariadb`. The host network is not used because it would reduce isolation and is forbidden by the subject.

### Docker Volumes vs Bind Mounts

Docker volumes persist data after containers are removed. This project uses named volumes for MariaDB data and WordPress files. The volumes are configured to store their data under `/home/natferna/data`, as required by the subject.

## Resources

- Docker documentation: https://docs.docker.com/
- Docker Compose documentation: https://docs.docker.com/compose/
- Debian documentation: https://www.debian.org/doc/
- MariaDB documentation: https://mariadb.com/kb/en/documentation/
- NGINX documentation: https://nginx.org/en/docs/
- WordPress documentation: https://wordpress.org/documentation/
- WP-CLI documentation: https://wp-cli.org/

AI was used to help structure the project, explain Docker concepts, draft documentation, and prepare defense questions. The generated material was reviewed and adapted to match the project subject and the `natferna` configuration.
