## Guía de Despliegue: Laravel con Docker Compose

> Nota: Desplegar **Laravel** con Docker Compose es un paso adelante natural. A diferencia de un script PHP simple, Laravel requiere herramientas adicionales como **Composer** (gestor de dependencias) y algunas extensiones específicas de PHP para funcionar correctamente.


### 1. Estructura del proyecto

Para esta guía, asumiremos que ya tienes el código de Laravel en una carpeta llamada `src` o que vas a crear un proyecto nuevo.

```text
proyecto-laravel/
├── docker-compose.yml
├── php.Dockerfile
├── nginx.conf
└── src/              # Aquí irá el código de Laravel
```

---

### 2. El archivo `php.Dockerfile`

Laravel necesita varias extensiones de PHP y la herramienta Composer. Usaremos este Dockerfile para preparar el entorno:

```dockerfile
FROM php:8.2-fpm

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Limpiar caché de apt
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalar extensiones de PHP necesarias para Laravel
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Instalar Composer desde la imagen oficial
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www
```

---

### 3. Configuración de NGINX (`nginx.conf`)

Laravel redirige todas las peticiones a un archivo llamado `index.php` dentro de la carpeta `public`.

```nginx
server {
    listen 80;
    index index.php index.html;
    server_name localhost;
    root /var/www/public; # Importante: apunta a la carpeta public de Laravel

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass app:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
```

---

### 4. El archivo `docker-compose.yml`

Orquestamos los servicios, asegurando que el código fuente sea accesible para NGINX y PHP.

```yaml
services:
  # Aplicación Laravel (PHP-FPM)
  app:
    build:
      context: .
      dockerfile: php.Dockerfile
    container_name: laravel-app
    volumes:
      - ./src:/var/www
    networks:
      - laravel-net

  # Servidor Web NGINX
  web:
    image: nginx:alpine
    container_name: laravel-nginx
    ports:
      - "8080:80"
    volumes:
      - ./src:/var/www
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      - app
    networks:
      - laravel-net

  # Base de Datos MySQL
  db:
    image: mysql:8.0
    container_name: laravel-db
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root_password
      MYSQL_DATABASE: laravel_db
      MYSQL_USER: laravel_user        # Usuario específico para la app
      MYSQL_PASSWORD: laravel_password # Contraseña para el usuario
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

### 5. Pasos para el primer despliegue

Si no tienes un proyecto de Laravel todavía, sigue estos comandos después de levantar los contenedores:

1. **Levantar servicios:**
```bash
docker compose up -d --build

```


2. **Instalar Laravel (si la carpeta `src` está vacía):**
```bash
docker compose exec app composer create-project laravel/laravel .

```


3. **Ajustar permisos (Crucial en Linux):**
Laravel necesita escribir en las carpetas `storage` y `bootstrap/cache`.
```bash
docker compose exec app chown -R www-data:www-data storage bootstrap/cache
```

4. **Configurar el archivo `.env`:**
En el archivo `.env` dentro de `src/`, ajusta la base de datos para que coincida con el servicio de Docker:
```env
DB_CONNECTION=mysql
DB_HOST=db             # Importante: nombre del servicio en el docker-compose
DB_PORT=3306
DB_DATABASE=laravel_db
DB_USERNAME=laravel_user
DB_PASSWORD=laravel_password
```

---

### Recordatorios y Tips

* **Comandos Artisan:** Para ejecutar cualquier comando de Laravel (migraciones, controladores, etc.), se debe hacer a través del contenedor: `docker compose exec app php artisan migrate`.
* **Carpeta Public:** Recordar que NGINX apunta a `/var/www/public`, pero el contenedor PHP trabaja sobre `/var/www`. Ambos deben tener montado el mismo volumen.
* **Composer:** Al haber incluido Composer en el Dockerfile, los alumnos no necesitan tenerlo instalado en su máquina física.
