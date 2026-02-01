
## Estructura del Proyecto

> Nota: Esta guía detalla el procedimiento para configurar un entorno de desarrollo profesional para **Laravel** utilizando **Docker**. Este entorno está diseñado para garantizar que el desarrollo local sea idéntico al de producción, facilitando el despliegue continuo mediante Gitea.

### 1. Estructura del proyecto

Se debe organizar el directorio de trabajo de la siguiente forma para separar la lógica de infraestructura del código fuente:

```text
mi-proyecto-laravel/
├── docker-compose.yml
├── php.Dockerfile
├── nginx.conf
├── .gitignore
└── src/              # Directorio raíz de Laravel
```

---

## 2. Configuración de la Imagen PHP (`php.Dockerfile`)

Laravel requiere extensiones específicas y el gestor de dependencias Composer. Utilizaremos un Dockerfile personalizado para construir el motor de la aplicación.

```dockerfile
FROM php:8.2-fpm

# Instalación de dependencias del sistema y herramientas de compresión
RUN apt-get update && apt-get install -y \
    git curl libpng-dev libonig-dev libxml2-dev zip unzip

# Instalación de extensiones PHP oficiales para Laravel y MySQL
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Incorporación de Composer desde su imagen oficial
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www
```

---

## 3. Configuración del Servidor Web (`nginx.conf`)

NGINX actuará como proxy inverso, enviando las peticiones PHP al contenedor correspondiente y sirviendo archivos estáticos desde la carpeta `public`.

```nginx
server {
    listen 80;
    index index.php index.html;
    server_name localhost;
    root /var/www/public; # Carpeta pública de Laravel

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

## 4. Orquestación de Servicios (`docker-compose.yml`)

El archivo define la red interna y los volúmenes necesarios para la persistencia de datos.

```yaml
services:
  # Servicio de Aplicación (PHP-FPM)
  app:
    build:
      context: .
      dockerfile: php.Dockerfile
    container_name: laravel-app
    volumes:
      - ./src:/var/www
    networks:
      - laravel-net

  # Servidor Web (NGINX)
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

  # Base de Datos (MySQL)
  db:
    image: mysql:8.0
    container_name: laravel-db
    environment:
      MYSQL_ROOT_PASSWORD: root_password
      MYSQL_DATABASE: laravel_db
      MYSQL_USER: laravel_user
      MYSQL_PASSWORD: laravel_password
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

## 5. Instalación y Puesta en Marcha

1. **Construir y levantar el entorno:**
```bash
docker compose up -d --build
```


2. **Instalar Laravel (si el directorio `src` está vacío):**
```bash
docker compose exec app composer create-project laravel/laravel .
```


3. **Configurar permisos de escritura:**
Laravel requiere que el usuario del servidor web (`www-data`) tenga permisos sobre las carpetas de caché y logs.
```bash
docker compose exec app chown -R www-data:www-data storage bootstrap/cache

```


4. **Vincular la Base de Datos en el archivo `.env`:**
Localizar el archivo `src/.env` y actualizar los valores para que coincidan con el servicio de Docker:
```env
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=laravel_db
DB_USERNAME=laravel_user
DB_PASSWORD=laravel_password
```

---

## 6. Preparación para Gitea (Control de Versiones)

Antes de realizar el primer *push* a Gitea, es fundamental configurar el archivo `.gitignore` en la raíz del proyecto para evitar subir archivos innecesarios o sensibles.

1. **Crear `.gitignore` en la raíz:**
```text
/src/vendor
/src/.env
/src/storage/*.key
docker-compose.override.yml (si existiera)
```


2. **Inicializar repositorio y subir:**
```bash
git init
git add .
git commit -m "Initial commit: Laravel Docker environment"
git remote add origin http://tu-gitea/usuario/repo.git
git push origin main
```

---

## Notas de mantenimiento y depuración

* **Comandos Artisan:** Cualquier comando de Laravel debe ejecutarse mediante `docker compose exec app php artisan [comando]`.
* **Reconstrucción:** Si se añade una nueva extensión de PHP al `php.Dockerfile`, se debe ejecutar `docker compose up -d --build` para aplicar los cambios.
* **Logs en tiempo real:** Para monitorizar errores de conexión o de PHP, utilizar `docker compose logs -f app`.
