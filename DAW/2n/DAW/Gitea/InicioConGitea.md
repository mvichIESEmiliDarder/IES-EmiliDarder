# Uso diario: Gestionando tu nuevo universo Git

Con Gitea instalado y configurado, es hora de sumergirse en el flujo de trabajo diario. La belleza de Gitea reside en su interfaz familiar e intuitiva, que hace que la transición desde otras plataformas como GitHub sea prácticamente transparente.

## 1. Creando tu primer repositorio

Lo primero que querrás hacer es crear un espacio para tu código:

1. **Inicia sesión** con tu cuenta de administrador.
2. En la esquina superior derecha, haz clic en el icono **+** y selecciona **«Nuevo repositorio»**.
3. **Rellena el formulario**:
* **Propietario**: Elige el propietario (tú mismo o una organización).
* **Nombre del repositorio**: Ej: `mi-proyecto-web`.
* **Visibilidad**: Público o Privado.
* **Inicializar repositorio**: Es recomendable marcar las casillas para incluir un `README.md`, `.gitignore` y una licencia.


4. Haz clic en **«Crear repositorio»**.

---

## 2. El flujo de trabajo de Git: Clonar, Push y Pull

Gitea soporta tanto HTTPS como SSH para interactuar con tus repositorios.

### Métodos de Clonación

* **HTTPS (Más sencillo al inicio):**
```bash
git clone http://git.mi-empresa.com:3000/tu_usuario/mi-proyecto-web.git

```


*Nota: La URL será `https://` si has configurado un proxy inverso con SSL.*
* **SSH (Recomendado para uso frecuente):**
```bash
git clone ssh://git@git.mi-empresa.com:2222/tu_usuario/mi-proyecto-web.git

```



### Comandos básicos en el terminal

Una vez clonado, el flujo de trabajo es el estándar de Git:

```bash
# Entrar al directorio
cd mi-proyecto-web

# Crear un archivo de prueba
echo "Hola, Gitea" > hola.txt

# Flujo básico de Git
git add hola.txt
git commit -m "Mi primer commit en Gitea"
git push origin main

```

---

## 3. Gestión de usuarios y colaboración

Gitea no es solo un almacén de código; es una plataforma de colaboración completa.

### Estructura de colaboración

* **Usuarios:** Gestión de cuentas desde el Panel de Administración.
* **Organizaciones:** Ideales para agrupar proyectos y múltiples usuarios de una empresa.
* **Equipos:** Permiten asignar permisos granulares (lectura, escritura, admin) a grupos de personas dentro de una organización.

### Herramientas integradas

* **Issues (Incidencias):** Reportar bugs, solicitar características y seguir el progreso con etiquetas e hitos.
* **Pull Requests:** El corazón del trabajo en equipo para la revisión de código y fusión de ramas.
* **Wikis:** Documentación técnica integrada en cada proyecto.

---

## 4. Configurando claves SSH

Para una autenticación segura y sin contraseñas:

1. **Genera la clave localmente:**
```bash
ssh-keygen -t ed25519 -C "tu_email@ejemplo.com"

```


2. **Copia la clave pública:**
```bash
cat ~/.ssh/id_ed25519.pub

```


3. **Añádela a Gitea:** Ve a `Configuración` -> `Claves SSH / GPG` -> `Añadir clave` y pega el contenido.

---

## 5. Configuración avanzada y producción

Para un entorno profesional, debes considerar estos tres pilares:

### El archivo `app.ini`

Es el centro neurálgico de Gitea.

* **Docker:** `/data/gitea/conf/app.ini`
* **Binario:** `/etc/gitea/app.ini`

### Proxy Inverso con Nginx y HTTPS

Configuración básica de Nginx:

```nginx
server {
    listen 443 ssl http2;
    server_name git.mi-empresa.com;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

```

### Integraciones y Personalización

* **Autenticación:** Soporte para **LDAP/Active Directory** y **OAuth2** (Google, GitHub).
* **Webhooks:** Conecta Gitea con Slack, Discord o sistemas de CI/CD externos.
* **Apariencia:** Personaliza logos y CSS en el directorio `/custom`.

---

## 6. Mantenimiento y Copias de Seguridad

> **Regla de oro:** Una copia de seguridad que no ha sido probada no existe.

### Realizar un respaldo (Backup)

Utiliza el comando `dump` para generar un archivo ZIP con la base de datos, repositorios y configuración:

* **Docker:** `docker exec -u git gitea gitea dump -c /data/gitea/conf/app.ini`
* **Binario:** `sudo -u git /usr/local/bin/gitea dump -c /etc/gitea/app.ini`

### Actualización de Gitea

1. **Leer las notas de versión.**
2. **Hacer copia de seguridad.**
3. **Actualizar imagen (Docker)** o **Reemplazar binario**. Gitea migrará la base de datos automáticamente al iniciar.

---

## 7. CI/CD con Gitea Actions

Gitea Actions es compatible con el formato de **GitHub Actions**, permitiendo automatizar pruebas y despliegues.

### Conceptos Clave

1. **Workflows:** Archivos YAML en `.gitea/workflows/`.
2. **Runners:** Agentes externos que ejecutan las tareas.

### Cómo habilitarlo

En el archivo `app.ini`:

```ini
[actions]
ENABLED = true

```

Luego, registra un **runner** (ejecutor) descargando el binario `act_runner` y vinculándolo con tu token de administrador.

```bash
# Registro del runner
./act_runner register
# Ejecución del daemon
./act_runner daemon

```
