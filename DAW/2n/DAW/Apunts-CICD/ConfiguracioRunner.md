# Parte 1: Gitea Runner

### 1. ¿Qué es el Runner?

Imagina que **Gitea** es el "Director de Orquesta": él lee el código y sabe cuándo hay que trabajar. Pero Gitea no ensucia sus manos ejecutando comandos. Para eso usa al **Runner**.

El Runner es un agente (un proceso) que vive en un servidor y se queda "escuchando" a Gitea. Cuando Gitea detecta un cambio en el código, le envía una señal al Runner para que este descargue el repositorio y ejecute los pasos que tú hayas definido.

### 2. Infraestructura Necesaria

Para montar este sistema de forma profesional, necesitamos:

* **Un Servidor Independiente:** Aunque podrías instalarlo junto a Gitea, lo ideal es que el Runner esté en su propio servidor (o VM) para que el consumo de recursos (CPU/RAM) al compilar o desplegar no ralentice tu repositorio.
* **Docker Instalado:** El Runner utiliza Docker para levantar "micro-entornos" de trabajo limpios cada vez que ejecutas una tarea.
* **Conectividad:** El servidor del Runner debe poder llegar a la IP y puerto de tu servidor de Gitea (en tu caso, `http://192.168.201.6:3000`).

---

### 3. Activación y Obtención del Token

Gitea no acepta conexiones de cualquier Runner por seguridad. Debes "presentarlos":

1. Entra en tu **Gitea**.
2. Ve a **Configuración de la instancia** (icono de herramientas arriba a la derecha) -> **Acciones** -> **Nodos**.
3. Haz clic en el botón azul **"Crear nuevo nodo"**.
4. Te aparecerá una ventana con el **Registration Token**. Cópialo; es la "llave" que usaremos en el Docker Compose para que Gitea reconozca a nuestro servidor como un trabajador autorizado.

---

### 4. Las Etiquetas (Labels): El lenguaje de comunicación

Aquí es donde mucha gente se confunde. Las etiquetas sirven para dos cosas:

1. **Identificación:** En tu archivo `deploy.yaml` pones `runs-on: ubuntu-latest`. Gitea buscará qué Runner tiene esa etiqueta para darle el trabajo.
2. **El Motor de Ejecución:** El Runner necesita saber qué sistema operativo usar para trabajar. Por eso, en la etiqueta definimos qué imagen de Docker se descargará para procesar tus comandos.
* Usamos `docker://catthehacker/ubuntu:act-24.04` porque es una imagen "vitaminada" que ya trae **Docker y Docker Compose instalado** dentro, permitiéndote gestionar tus propios contenedores de la web.



---

### 5. Configuración del Runner (`docker-compose.yml`)

Este es el archivo que pondrás en tu servidor de Runner:

```yaml
services:
  gitea-runner:
    image: gitea/act_runner:latest
    container_name: gitea-act_runner
    restart: always
    volumes:
      # CRUCIAL: Esto permite al runner usar el Docker del servidor host
      - /var/run/docker.sock:/var/run/docker.sock
      # Persistencia de configuración
      - ./data:/data
    environment:
      # URL donde está tu Gitea
      - GITEA_INSTANCE_URL=http://192.168.201.6:3000
      # Nombre descriptivo que verás en la web
      - GITEA_RUNNER_NAME=ubuntu-runner-prod
      # Vinculamos la etiqueta con el contenedor de gestión (CatTheHacker)
      - GITEA_RUNNER_LABELS=ubuntu-latest:docker://catthehacker/ubuntu:act-24.04
      # El token que copiamos en el paso anterior
      - GITEA_RUNNER_REGISTRATION_TOKEN=L1Ljn3J3mOYlpuu3uHTmShvbmTWcEEY46riXsXxQ

```

---

### 6. ¡Cuidado con la carpeta `data`! (Paso Crítico)

Antes de lanzar el comando `docker compose up -d`, debes preparar el terreno.

**Docker no debe crear la carpeta `data` por ti.** Si lo hace, la creará con el usuario `root` y el Runner (que suele correr con un usuario interno de menor privilegio) no podrá escribir su archivo de registro `.runner`.

**Pasos correctos en la terminal del servidor:**

1. Crea la carpeta a mano: `mkdir data`
2. Dale permisos totales para la primera conexión: `chmod 777 data` (Esto garantiza que el Runner pueda generar sus credenciales sin errores de "Permission Denied").

Una vez hecho esto, ya puedes ejecutar:
`docker compose up -d`

Al volver a Gitea, verás que el nodo aparece en **Verde**, listo para recibir órdenes y desplegar tu web automáticamente.
