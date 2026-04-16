# Inception

Proyecto preparado para el **subject de Inception de 42** en su parte obligatoria: una pequeña infraestructura Docker con **Nginx + WordPress + MariaDB**, cada servicio en su **propio contenedor**, orquestados con **Docker Compose**.

## Estructura

inception/
├── Makefile
├── README.md
└── srcs/
    ├── .env
    ├── .env.example
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/
        │   │   └── 50-server.conf
        │   └── tools/
        │       └── setup.sh
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/
        │   │   └── default.conf
        │   └── tools/
        │       └── setup.sh
        └── wordpress/
            ├── Dockerfile
            ├── conf/
            │   └── www.conf
            └── tools/
                └── setup.sh
```

## Qué cumple este proyecto

- **Tres contenedores separados**: `nginx`, `wordpress`, `mariadb`.
- **Imágenes propias** construidas con `Dockerfile` a partir de **Debian Bullseye**.
- **Nginx con TLS** en el puerto **443**.
- **WordPress con php-fpm** (sin Nginx dentro del contenedor de WordPress).
- **MariaDB** como base de datos.
- **Volúmenes persistentes** montados en:
  - `/home/$USER/data/wordpress`
  - `/home/$USER/data/mariadb`
- **Red dedicada** para la comunicación entre contenedores.
- **Variables de entorno** centralizadas en `srcs/.env`.
- **Makefile** con comandos simples para construir, levantar, parar y limpiar.

## Antes de usarlo

1. Copia y edita las variables de entorno:

```bash
cp srcs/.env.example srcs/.env
```

2. Cambia los valores sensibles dentro de `srcs/.env`.

3. Añade tu dominio local al archivo `/etc/hosts`, por ejemplo:

```bash
127.0.0.1 login.42.fr
```

> Sustituye `login.42.fr` por el valor de `DOMAIN_NAME`.

## Comandos

### Construir imágenes

```bash
make build
```

### Levantar toda la infraestructura

```bash
make
```

### Ver logs

```bash
make logs
```

### Ver estado de contenedores

```bash
make ps
```

### Parar la infraestructura

```bash
make down
```

### Limpiar contenedores e imágenes

```bash
make clean
```

### Limpiar también volúmenes y datos persistentes

```bash
make fclean
```

## Notas importantes

- El acceso al sitio se hace por **HTTPS**.
- `nginx` sirve los archivos de WordPress y reenvía PHP a `wordpress:9000`.
- `wordpress` instala y configura WordPress automáticamente usando **wp-cli**.
- `mariadb` crea la base de datos y el usuario automáticamente en el primer arranque.
- Los datos permanecen aunque se destruyan los contenedores, porque están en volúmenes bind persistentes.
