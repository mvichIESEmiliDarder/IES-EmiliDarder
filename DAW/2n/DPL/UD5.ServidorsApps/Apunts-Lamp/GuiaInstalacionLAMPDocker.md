## Guía de Despliegue: Pila LAMP con Docker Compose

Esta guía describe cómo empaquetar y ejecutar la misma infraestructura (Apache, MySQL y PHP) utilizando contenedores, garantizando un entorno aislado y reproducible.

### 1. Requisitos Previos

Es necesario tener instalados Docker y el plugin de Docker Compose en el sistema.

```bash
# Actualizar índices e instalar Docker
sudo apt update
sudo apt install docker.io docker-compose-v2 -y

# Asegurar que el servicio esté activo
sudo systemctl enable --now docker

```

> **Nota:** Se recomienda añadir el usuario actual al grupo `docker` para ejecutar comandos sin `sudo`: `sudo usermod -aG docker $USER` (requiere cerrar y abrir sesión).

---

### 2. Estructura del Proyecto

Para mantener el orden y la persistencia de datos, se debe crear una carpeta de proyecto y los directorios necesarios para el contenido web.

```bash
mkdir proyecto-lamp && cd proyecto-lamp
mkdir www

```

---

### 3. Creación del archivo `docker-compose.yml`

Este archivo define los servicios, redes y volúmenes de la infraestructura.

1. **Crear el archivo:** `nano docker-compose.yml`
2. **Añadir el siguiente contenido:**

```yaml
services:
  # Servicio de Base de Datos
  db:
    image: mysql:8.0
    container_name: lamp-mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root_password
      MYSQL_DATABASE: mi_base_de_datos
      MYSQL_USER: usuario_web
      MYSQL_PASSWORD: user_password
    volumes:
      - db_data:/var/lib/mysql

  # Servicio de Servidor Web y PHP
  web:
    image: php:8.2-apache
    container_name: lamp-apache-php
    restart: always
    ports:
      - "8080:80"
    volumes:
      - ./www:/var/www/html
    depends_on:
      - db

volumes:
  db_data:

```

> **Recordar:** En este entorno, el "host" de la base de datos para las conexiones PHP no es `localhost`, sino el nombre del servicio definido en el YAML: `db`.

---

### 4. Instalación de extensiones PHP (Opcional pero recomendado)

La imagen oficial de PHP en Docker es mínima. Si se requiere conexión a MySQL, se debe habilitar la extensión dentro del contenedor o usar un `Dockerfile`. Para una prueba rápida, se puede verificar la carga básica primero.

---

### 5. Despliegue de los Contenedores

Una vez configurado el archivo YAML, el despliegue se realiza con un solo comando.

1. **Lanzar la infraestructura:**
```bash
sudo docker compose up -d

```


*El flag `-d` (detached) ejecuta los contenedores en segundo plano.*
2. **Verificar el estado:**
```bash
sudo docker compose ps

```



---

### 6. Verificación y Pruebas

1. **Crear archivo de prueba:**
```bash
nano www/info.php

```


*(Añadir `<?php phpinfo(); ?>` al archivo).*
2. **Acceso:**
Abrir el navegador en `http://localhost:8080/info.php`.

> **Advertencia:** Se utiliza el puerto `8080` para evitar conflictos con el Apache instalado manualmente en la sesión anterior que ocupa el puerto `80`.

---

### 7. Gestión del Ciclo de Vida

Comandos esenciales para administrar el despliegue:

* **Ver logs en tiempo real:** `sudo docker compose logs -f`
* **Detener los servicios:** `sudo docker compose stop`
* **Eliminar los contenedores y redes:** `sudo docker compose down`
* **Eliminar todo incluyendo datos (volúmenes):** `sudo docker compose down -v`

---

### Tips de Comparativa (Manual vs Docker)

* **Tiempo de despliegue:** Una vez descargadas las imágenes, el levantamiento es casi instantáneo (segundos).
* **Limpieza:** Al ejecutar `docker compose down`, el sistema anfitrión queda limpio, a diferencia de la instalación `apt` que deja archivos de configuración y dependencias.
* **Persistencia:** Explicar que aunque el contenedor se borre, los datos en `db_data` (volumen) y la carpeta `www` permanecen intactos.