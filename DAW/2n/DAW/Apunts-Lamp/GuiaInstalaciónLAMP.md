## Guía de Instalación: Pila LAMP en Ubuntu (Manual)

Esta guía detalla el proceso de instalación y configuración de un entorno **LAMP** (Linux, Apache, MySQL, PHP) sobre un sistema base Ubuntu.

---

### 1. Actualización de Repositorios

Antes de cualquier instalación, es fundamental sincronizar los índices de paquetes para asegurar que se descarguen las versiones más recientes.

```bash
sudo apt update && sudo apt upgrade -y

```

---

### 2. Instalación de Apache

El servidor web Apache es el encargado de gestionar las peticiones HTTP.

1. **Instalar el paquete:**
```bash
sudo apt install apache2 -y

```


2. **Configurar el Firewall (UFW):**
Si el firewall está activo, se debe permitir el tráfico en el puerto 80.
```bash
sudo ufw allow in "Apache"

```


3. **Comprobación:**
Acceder mediante el navegador a la dirección `http://localhost` o la IP del servidor.

> **Nota:** El directorio raíz por defecto donde se alojan los archivos web es `/var/www/html/`.

---

### 3. Instalación de MySQL

Sistema de gestión de bases de datos relacional para el almacenamiento de información.

1. **Instalar el servidor de base de datos:**
```bash
sudo apt install mysql-server -y

```


2. **Asegurar la instalación:**
Ejecutar el script de seguridad para configurar el nivel de complejidad de contraseñas y eliminar accesos inseguros.
```bash
sudo mysql_secure_installation

```


3. **Acceso a la consola:**
```bash
sudo mysql

```



> **Advertencia:** En versiones recientes de Ubuntu, el usuario `root` de MySQL utiliza el plugin `auth_socket` por defecto (se accede vía `sudo` desde el sistema), en lugar de contraseña.

---

### 4. Instalación de PHP

Motor de procesamiento para ejecutar aplicaciones dinámicas y conectar con la base de datos.

1. **Instalar PHP y módulos de integración:**
```bash
sudo apt install php libapache2-mod-php php-mysql -y

```


2. **Verificar instalación:**
```bash
php -v

```



---

### 5. Configuración de Prioridades y Permisos

Por defecto, Apache prioriza la carga de archivos `index.html` sobre los `index.php`.

1. **Cambiar el orden de carga (Opcional):**
Editar el archivo de configuración:
```bash
sudo nano /etc/apache2/mods-enabled/dir.conf

```


Mover `index.php` a la primera posición después de `DirectoryIndex`. Luego, reiniciar el servicio:
```bash
sudo systemctl restart apache2

```


2. **Gestión de permisos:**
Para editar archivos en `/var/www/html` sin requerir permisos de superusuario constantemente:
```bash
sudo chown -R $USER:$USER /var/www/html

```



---

### 6. Verificación de la Pila LAMP

Creación de un script de diagnóstico para confirmar que Apache procesa PHP y detecta los módulos de MySQL.

1. **Crear el archivo de prueba:**
```bash
nano /var/www/html/info.php

```


2. **Añadir el código:**
```php
<?php
phpinfo();
?>

```


3. **Acceso:** Navegar a `http://dirección_ip/info.php`.

> **Recordar:** Una vez confirmada la instalación, es una buena práctica de seguridad borrar el archivo `info.php`, ya que expone detalles sensibles de la configuración del servidor.

---

### Resumen de comandos de gestión

| Servicio | Iniciar | Detener | Reiniciar | Estado |
| --- | --- | --- | --- | --- |
| **Apache** | `sudo systemctl start apache2` | `sudo systemctl stop apache2` | `sudo systemctl restart apache2` | `sudo systemctl status apache2` |
| **MySQL** | `sudo systemctl start mysql` | `sudo systemctl stop mysql` | `sudo systemctl restart mysql` | `sudo systemctl status mysql` |
