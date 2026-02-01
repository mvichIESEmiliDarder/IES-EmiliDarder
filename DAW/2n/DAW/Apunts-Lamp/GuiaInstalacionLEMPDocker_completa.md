
## Guía de Despliegue: Pila LEMP con Docker (Completa)

> Nota: Para la pila **LEMP** con Docker, el proceso es un poco más sofisticado porque necesitamos que el contenedor de **PHP-FPM** tenga los controladores de MySQL instalados, mientras que el contenedor de **NGINX** actúa solo como pasarela.


### 1. Estructura del proyecto

Es fundamental organizar los archivos para que cada contenedor reciba su configuración:

```text
proyecto-lemp/
├── docker-compose.yml
├── php.Dockerfile
├── nginx.conf
└── www/
    └── index.php
```

---

### 2. El archivo `php.Dockerfile`

Al igual que en LAMP, la imagen oficial de PHP-FPM no trae los conectores de base de datos. Debemos crearlos:

```dockerfile
# Usamos la versión FPM (FastCGI Process Manager)
FROM php:8.2-fpm

# Instalamos las extensiones necesarias para MySQL
RUN docker-php-ext-install mysqli pdo pdo_mysql
```

---

### 3. Configuración de NGINX (`nginx.conf`)

Este archivo es el "mapa" que le dice a NGINX cómo enviar los archivos `.php` al contenedor de PHP.

```nginx
server {
    listen 80;
    index index.php index.html;
    server_name localhost;
    root /var/www/html;

    location / {
        try_files $uri $uri/ =404;
    }

    # Conexión con el contenedor PHP-FPM
    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass app:9000; # "app" es el servicio en docker-compose
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
```

---

### 4. El archivo `docker-compose.yml`

Aquí orquestamos los tres servicios. Nota que tanto `web` como `app` comparten la carpeta `www`.

```yaml
services:
  # Motor PHP (Construido desde nuestro Dockerfile)
  app:
    build:
      context: .
      dockerfile: php.Dockerfile
    container_name: lemp-php
    volumes:
      - ./www:/var/www/html

  # Servidor Web NGINX
  web:
    image: nginx:alpine
    container_name: lemp-nginx
    ports:
      - "8080:80"
    volumes:
      - ./www:/var/www/html
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      - app

  # Base de Datos MySQL
  db:
    image: mysql:8.0
    container_name: lemp-mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root_password
      MYSQL_DATABASE: lemp_db
      MYSQL_USER: user_lemp
      MYSQL_PASSWORD: password_lemp
    volumes:
      - db_data:/var/lib/mysql

volumes:
  db_data:
```
---

### 5. Prueba de conexión (`www/index.php`)

Crea este archivo para verificar que el "triángulo" NGINX-PHP-MySQL funciona:

```php
<?php
$host = 'db'; // Nombre del servicio MySQL en el compose
$user = 'user_lemp';
$pass = 'password_lemp';
$db   = 'lemp_db';

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die("❌ Error: " . $conn->connect_error);
}
echo "✅ Pila LEMP funcionando correctamente con Docker!";
?>
```

---

### 6. Ejecución

1. **Construir y arrancar:**
```bash
docker compose up -d --build
```

2. **Acceso:** `http://localhost:8080/index.php`

---

### Notas Técnicas y Recordatorios:

* **Separación de responsabilidades:** En esta guía, NGINX solo sirve estáticos y PHP-FPM solo ejecuta código. Es la forma más eficiente y profesional de desplegar aplicaciones web.
* **Puerto 9000:** Es el puerto por defecto donde PHP-FPM escucha las peticiones FastCGI. No hace falta abrirlo al exterior en el `docker-compose.yml`, ya que los contenedores se comunican por la red interna de Docker.
* **Error 502 Bad Gateway:** Si aparece este error, suele significar que el contenedor `app` no está corriendo o que el nombre en `fastcgi_pass` no coincide con el nombre del servicio en el archivo YAML.
