## Guía de Despliegue: Pila LAMP con Docker (Completa)

En esta versión, creamos una imagen personalizada de PHP para instalar las extensiones `mysqli` y `pdo_mysql`, necesarias para hablar con la base de datos.

### 1. Estructura del proyecto

```text
proyecto-lamp/
├── docker-compose.yml
├── php.Dockerfile
└── www/
    └── index.php
```

---

### 2. El archivo `php.Dockerfile`

Este archivo toma la imagen base de PHP con Apache y le añade las herramientas de conexión a base de datos.

```dockerfile
# Usamos la imagen oficial de PHP con Apache
FROM php:8.2-apache

# Instalamos las extensiones necesarias para MySQL
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Habilitamos el módulo rewrite de Apache (común en aplicaciones PHP)
RUN a2enmod rewrite
```

---

### 3. El archivo `docker-compose.yml`

En lugar de descargar una imagen directa para el servidor web, le indicaremos a Docker que la **construya** usando el archivo anterior.

```yaml
services:
  # Servidor Web + PHP (Personalizado)
  web:
    build:
      context: .
      dockerfile: php.Dockerfile
    container_name: lamp-apache-php
    ports:
      - "8080:80"
    volumes:
      - ./www:/var/www/html
    depends_on:
      - db

  # Base de Datos
  db:
    image: mysql:8.0
    container_name: lamp-mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: password_maestro
      MYSQL_DATABASE: mi_app_db
      MYSQL_USER: user_alumno
      MYSQL_PASSWORD: password_alumno
    volumes:
      - db_data:/var/lib/mysql

volumes:
  db_data:
```
---

### 4. Prueba de conexión (`www/index.php`)

Para comprobar que el Dockerfile ha funcionado y los servicios se comunican, usa este script en tu carpeta `www`:

```php
<?php
$host = 'db'; // Nombre del servicio en docker-compose
$user = 'user_alumno';
$pass = 'password_alumno';
$db   = 'mi_app_db';

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die("❌ Error de conexión: " . $conn->connect_error);
}
echo "✅ Conexión exitosa a MySQL dentro de Docker!";
?>
```
---

### 5. Despliegue

Debido a que hemos añadido un Dockerfile, la primera vez debemos "construir" el entorno:

1. **Construir y levantar:**
```bash
docker compose up -d --build
```

*Nota: El flag `--build` asegura que Docker lea los cambios en tu Dockerfile si decides añadir más extensiones después.*

2. **Verificación:** Accede a `http://localhost:8080/index.php`.

---

### Recordatorios clave:

* **Persistencia:** La base de datos se guarda en el volumen `db_data`. Si borras el contenedor, los datos siguen vivos.
* **DNS Interno:** Recordar que el host de conexión siempre es el nombre del servicio definido en el YAML (`db`), no `localhost` ni `127.0.0.1`.
* **Seguridad:** En el Dockerfile estamos instalando solo lo mínimo. Para producción se suelen añadir más capas de seguridad, pero para clase esto es el estándar de oro.
