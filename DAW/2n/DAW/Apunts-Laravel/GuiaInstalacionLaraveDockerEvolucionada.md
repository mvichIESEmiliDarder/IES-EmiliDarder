# Guía de Entorno Profesional: Laravel + Docker

Esta guía describe la configuración de un entorno de desarrollo basado en microservicios, optimizado para evitar conflictos de permisos y facilitar la colaboración mediante Gitea.

## 1. Arquitectura de Directorios

Mantendremos la infraestructura separada del código fuente para una mayor limpieza.

```text
mi-proyecto/
├── docker-compose.yml
├── .env.docker          # Variables de entorno para Docker
├── nginx.conf
├── php.Dockerfile
└── src/                 # Código fuente de Laravel

```

---

## 2. Dockerfile Dinámico (`php.Dockerfile`)

Para evitar el error de "Permission denied", configuramos el contenedor para que use tu mismo **UID** y **GID**.

```dockerfile
FROM php:8.2-fpm

# Argumentos para sincronizar el usuario con el host
ARG USER_ID=1000
ARG GROUP_ID=1000

# Instalación de dependencias
RUN apt-get update && apt-get install -y \
    git curl libpng-dev libonig-dev libxml2-dev zip unzip

# Extensiones PHP
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Crear usuario con los mismos IDs que el usuario de Linux local
RUN useradd -G www-data,root -u $USER_ID -d /home/dev dev
RUN mkdir -p /home/dev/.composer && chown -R dev:dev /home/dev

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Cambiar al usuario no-root
USER dev

```

---

## 3. Orquestación (`docker-compose.yml`)

Configuramos los servicios asegurando que el volumen de la base de datos sea persistente y la red esté aislada.

```yaml
services:
  app:
    build:
      context: .
      dockerfile: php.Dockerfile
      args:
        USER_ID: ${UID:-1000}
        GROUP_ID: ${GID:-1000}
    container_name: laravel-app
    volumes:
      - ./src:/var/www
    networks:
      - laravel-net

  web:
    image: nginx:alpine
    container_name: laravel-nginx
    ports:
      - "8000:80"
    volumes:
      - ./src:/var/www
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      - app
    networks:
      - laravel-net

  db:
    image: mysql:8.0
    container_name: laravel-db
    environment:
      MYSQL_ROOT_PASSWORD: ${DB_PASSWORD}
      MYSQL_DATABASE: ${DB_DATABASE}
      MYSQL_USER: ${DB_USER}  
      MYSQL_PASSWORD: ${DB_USER_PASSWORD}
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - laravel-net

networks:
  laravel-net:
    driver: bridge

volumes:
  db_data:

```

---

## 4. Puesta en marcha automática

Para evitar ejecutar comandos uno a uno, sigue este flujo lógico:

### A. Preparar el entorno local

Crea un archivo `.env` en la raíz (fuera de `src/`) para Docker:

```env
DB_DATABASE=laravel_db
DB_PASSWORD=root_password  # Esta es la de root
DB_USER=laravel_user       # Usuario para la app
DB_USER_PASSWORD=user_pass # Contraseña para el usuario
UID=1000
GID=1000

```

### B. Inicializar el Proyecto

Ejecuta estos comandos en orden para levantar el entorno y crear el proyecto sin errores de base de datos:

1. **Levantar contenedores:**
```bash
docker compose up -d --build

```


2. **Instalar Laravel (solo la primera vez):**
```bash
docker compose exec app composer create-project laravel/laravel .

```


3. **Configurar la aplicación:**
Laravel generará su propio `.env` dentro de `src/`. Asegúrate de que los valores coincidan con los de Docker:
```env
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=laravel_db
DB_USERNAME=root
DB_PASSWORD=root_password

```


4. **Migraciones y Key:**
```bash
docker compose exec app php artisan key:generate
docker compose exec app php artisan migrate

```



---

## 5. Mantenimiento y Buenas Prácticas

* **Comandos Artisan:** Ejecútalos siempre a través del contenedor: `docker compose exec app php artisan make:controller MiControlador`.
* **Permisos:** Gracias al Dockerfile con `USER_ID`, cualquier archivo que cree Laravel dentro del contenedor será editable por ti en VS Code o tu editor sin usar `sudo`.
* **Logs:** Si algo falla, el primer paso es `docker compose logs -f web` o `app`.

