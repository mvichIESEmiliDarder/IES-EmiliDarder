## Paso 0: Preparación e Instalación del Runner

Antes de que Gitea pueda ejecutar tus archivos de despliegue, necesita un "agente" (Runner) escuchando peticiones.

### 1. Preparación de la infraestructura (Crucial)

Docker no siempre gestiona bien los permisos de las carpetas creadas automáticamente. Por ello, es obligatorio crear la carpeta de persistencia manualmente para evitar errores de escritura (`Permission Denied`).

En la terminal de tu servidor, ejecuta:

```bash
mkdir data
chmod 777 data  # Esto asegura que el proceso interno del runner pueda escribir el registro

```

### 2. Configuración del Runner (`docker-compose.yml`)

Crea un archivo independiente para el runner. Este servicio debe estar siempre corriendo en segundo plano.

```yaml
services:
  gitea-runner:
    image: gitea/act_runner:latest
    container_name: gitea-act_runner
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock  # Permite al runner crear otros contenedores
      - ./data:/data                               # Guarda el registro y certificados
    environment:
      - GITEA_INSTANCE_URL=http://192.168.201.6:3000
      - GITEA_RUNNER_NAME=ubuntu-runner-prod
      # Las LABELS son las que Gitea usa para asignar tareas
      - GITEA_RUNNER_LABELS=ubuntu-latest:docker://catthehacker/ubuntu:act-24.04
      - GITEA_RUNNER_REGISTRATION_TOKEN=TU_TOKEN_GENERADO_EN_GITEA

```

---

## 3. Entendiendo las Labels (Etiquetas)

Este es el concepto más importante para que el CI/CD no falle. Las etiquetas funcionan como un sistema de **"Oferta y Demanda"**:

* **En el Runner:** La variable `GITEA_RUNNER_LABELS` define qué es capaz de hacer el runner.
* `ubuntu-latest`: Es el nombre corto que usaremos en nuestros archivos YAML.
* `docker://catthehacker/ubuntu:act-24.04`: Es la imagen real de Docker que se descargará para ejecutar los comandos. Usamos imágenes de "CatTheHacker" porque ya vienen preparadas con herramientas como `docker-compose` y `git`.


* **En el Workflow (`deploy.yaml`):** La línea `runs-on: ubuntu-latest` le dice a Gitea: *"Busca cualquier runner que tenga la etiqueta ubuntu-latest y dale este trabajo"*.

**Si la etiqueta en el Runner y en el Workflow no coinciden exactamente, la tarea se quedará eternamente en "Waiting to run".**

---

## 4. Activación en la Interfaz de Gitea

1. Ve a **Configuración de la instancia** (o del repositorio) -> **Acciones** -> **Nodos**.
2. Haz clic en **Crear nuevo nodo**.
3. Copia el **Registration Token**.
4. Pega ese token en tu `docker-compose.yml` del runner.
5. Levanta el runner: `docker compose up -d`.
6. Refresca Gitea; verás el nodo en **Verde (Inactivo/En línea)**.

---

### Resumen del Flujo Completo

Una vez el Runner está en verde, el ciclo de vida es:

1. Haces **Push** de tu código.
2. Gitea busca un runner con la etiqueta `ubuntu-latest`.
3. El Runner descarga la imagen de **CatTheHacker**.
4. Dentro de esa imagen, se ejecutan tus pasos de **Checkout** y **Docker Compose**.
5. Tu web se despliega en el puerto **8080**.

¡Con esto ya tienes el mapa completo del sistema! ¿Deseas que unifiquemos todo esto en un solo documento PDF o Markdown para tu documentación técnica?