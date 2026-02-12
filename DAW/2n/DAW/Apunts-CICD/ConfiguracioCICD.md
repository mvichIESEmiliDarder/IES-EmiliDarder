# Guía implementación de CI/CD con Gitea, Docker y Act Runner

Esta guía detalla el flujo de trabajo para desplegar una aplicación web estática de forma automática cada vez que se realiza un `push` al repositorio.

## 1. Estructura de Directorios del Proyecto

Para que el proceso funcione, la jerarquía de archivos debe ser exacta. El Runner necesita encontrar el `Dockerfile` y la carpeta `html` en la raíz para construir la imagen correctamente.

```text
.
├── .gitea/
│   └── workflows/
│       └── deploy.yaml      # Configuración de la automatización
├── html/
│   ├── index.html           # Tu contenido web
│   └── style.css            # Tus estilos
├── Dockerfile               # Instrucciones de empaquetado
└── docker-compose.yml       # Orquestación del contenedor

```

---

## 2. Definición del Empaquetado (`Dockerfile`)

En lugar de depender de volúmenes externos que pueden dar problemas de permisos, inyectamos el código directamente en la imagen. Esto hace que el despliegue sea atómico y portable.

```dockerfile
FROM nginx:alpine
# Copiamos el contenido de nuestra carpeta local 'html' 
# al directorio por defecto donde Nginx sirve archivos
COPY ./html /usr/share/nginx/html

```

---

## 3. Orquestación del Servicio (`docker-compose.yml`)

El archivo de Compose define cómo se debe ejecutar el contenedor. La clave aquí es la instrucción `build`, que vincula el Compose con nuestro Dockerfile.

```yaml
services:
  mi-web:
    build: .                 # Obliga a Docker a construir la imagen local
    container_name: web-nginx
    restart: always
    ports:
      - "8080:80"            # Acceso externo por el puerto 8080

```

---

## 4. Automatización del Despliegue (`deploy.yaml`)

Ubicado en `.gitea/workflows/`, este archivo es el cerebro que le dice al **Act Runner** qué hacer cuando detecta cambios.

```yaml
name: CI-CD-Despliegue-Local
on:
  push:
    branches:
      - main

jobs:
  despliegue:
    runs-on: ubuntu-latest  # Debe coincidir con la etiqueta de tu Runner
    steps:
      - name: 1. Obtener codigo del repo
        uses: actions/checkout@v4

      - name: 2. Levantar servidor Nginx
        run: |
          # --build asegura que se cree una imagen nueva con los cambios del commit
          docker compose down
          docker compose up -d --build

```

---

## 5. Resumen de Pasos para el Éxito (Checklist)

1. **Preparación del Runner**: Asegurarse de que el `act_runner` de Gitea esté registrado y en estado "Verde" (En línea).
2. **Permisos del Socket**: El runner debe tener acceso a `/var/run/docker.sock` para poder levantar otros contenedores.
3. **Configuración del Repo**: Los archivos estáticos (HTML/CSS) deben estar obligatoriamente dentro de la carpeta `html`.
4. **El Comando Mágico**: En el workflow, usar siempre `docker compose up -d --build`. Sin el `--build`, Docker reutilizará la imagen antigua y nunca verás tus cambios actualizados.

