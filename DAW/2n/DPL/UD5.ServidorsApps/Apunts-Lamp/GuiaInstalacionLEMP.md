## Guía de Instalación: Pila LEMP en Ubuntu (Manual)

La pila **LEMP** sustituye Apache por **N**GINX (pronunciado *Engine-X*). El proceso requiere un paso adicional para comunicar el servidor web con el motor de PHP.

### 1. Actualización del Sistema

```bash
sudo apt update && sudo apt upgrade -y
```

---

### 2. Instalación de NGINX

1. **Instalar el servidor:**
```bash
sudo apt install nginx -y
```


2. **Configurar el Firewall (UFW):**
```bash
sudo ufw allow 'Nginx HTTP'
```


3. **Comprobación:** Acceder a `http://localhost`. Debería aparecer el mensaje "Welcome to nginx!".

---

### 3. Instalación de MySQL

1. **Instalar el servidor:**
```bash
sudo apt install mysql-server -y
```

2. **Asegurar la instalación:**
```bash
sudo mysql_secure_installation
```

---

### 4. Instalación de PHP-FPM

A diferencia de LAMP, aquí instalamos `php-fpm`, que se ejecuta como un servicio independiente.

1. **Instalar PHP y el módulo de MySQL:**
```bash
sudo apt install php-fpm php-mysql -y
```

2. **Verificar estado:**
```bash
systemctl status php8.3-fpm
```

*(Nota: La versión exacta, como 8.1, 8.2 o 8.3, dependerá de tu versión de Ubuntu).*

---

### 5. Configuración de NGINX para PHP

NGINX no sabe qué hacer con los archivos `.php` por defecto. Debemos indicarle que los envíe a PHP-FPM.

1. **Editar el archivo de configuración predeterminado:**
```bash
sudo nano /etc/nginx/sites-available/default
```


2. **Modificar el bloque `server`:**
Busca la sección `index` y añade `index.php` antes de `index.html`. Luego, localiza la sección de PHP y déjala así (asegúrate de que la versión de PHP coincida con la instalada):
```nginx
server {
    listen 80;
    root /var/www/html;
    index index.php index.html index.htm;

    server_name _;

    location / {
        try_files $uri $uri/ =404;
    }

    # Pasar scripts PHP a FastCGI
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
    }
}
```


3. **Validar y Reiniciar:**
```bash
sudo nginx -t
sudo systemctl restart nginx
```
---

### 6. Verificación de la Pila LEMP

1. **Crear el archivo de prueba:**
```bash
sudo nano /var/www/html/info.php
```
*(Añadir `<?php phpinfo(); ?>`)*

2. **Acceso:** Navegar a `http://dirección_ip/info.php`.

---

### Recordatorios y Tips

* **Permisos:** Al igual que con Apache, es recomendable ajustar el propietario de la web: `sudo chown -R $USER:$USER /var/www/html`.
* **Sockets:** La comunicación entre NGINX y PHP se hace mediante un "socket Unix" (`.sock`). Es el punto donde suelen ocurrir la mayoría de errores (error 502 Bad Gateway).
* **Diferencia clave:** Recordar que en NGINX, si cambias algo en la configuración de PHP, a veces debes reiniciar tanto `php-fpm` como `nginx`.
