# 🛠️ Guía Técnica: Despliegue del Mini-SOC

### 🏗️ Roles del Grupo (3 Personas)

* **Alumno A (Servidor 1):** Ubuntu Server (Genera logs).
* **Alumno B (Servidor 2):** Ubuntu Server (Genera logs).
* **Alumno C (Analista SOC):** Ubuntu Server con **Docker** (Recibe y visualiza).

---

## PASO 1: Configurar los Clientes (Alumnos A y B)

*El objetivo es que todo lo que pase en estas máquinas se envíe por red al Alumno C.*

1. Editar el archivo de configuración de Rsyslog:
`sudo nano /etc/rsyslog.conf`
2. Ir al final del archivo y añadir la siguiente línea (sustituye `IP_ALUMNO_C` por la IP real de tu compañero):
`*.* @IP_ALUMNO_C:514`
*(El símbolo `@` significa UDP. Si usas `@@` sería TCP)*.
3. Reiniciar el servicio para aplicar cambios:
`sudo systemctl restart rsyslog`

---

## PASO 2: Preparar el Servidor del SOC (Alumno C)

*Este alumno necesita instalar Docker para levantar la infraestructura rápidamente.*

1. **Instalar Docker** (resumen rápido):
`sudo apt update && sudo apt install docker.io docker-compose -y`
2. **Crear el archivo de despliegue**:
Crea una carpeta llamada `soc` y dentro un archivo llamado `docker-compose.yml`:
`nano docker-compose.yml`
3. **Pegar este contenido** (Configuración optimizada para vuestra clase):

```yaml
version: "3"
services:
  loki:
    image: grafana/loki:2.9.0
    ports:
      - "3100:3100"
    command: -config.file=/etc/loki/local-config.yaml

  promtail:
    image: grafana/promtail:2.9.0
    volumes:
      - /var/log:/var/log
    command: -config.file=/etc/promtail/config.yml

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin

```

4. **Lanzar el SOC**:
`sudo docker-compose up -d`

---

## PASO 3: Configurar Rsyslog en el Servidor (Alumno C)

*Para que el servidor del Alumno C pueda "escuchar" los logs que le envían sus compañeros.*

1. Editar rsyslog en el servidor: `sudo nano /etc/rsyslog.conf`
2. **Descomentar** estas líneas (quitar el `#`):
```bash
module(load="imudp")
input(type="imudp" port="514")

```


3. Reiniciar rsyslog: `sudo systemctl restart rsyslog`

---

## PASO 4: ¡Las luces de colores! (En el navegador)

*Ahora toca ver los datos.*

1. Desde cualquier PC de la red, abre el navegador e ve a: `http://IP_ALUMNO_C:3000`
2. Entra con usuario `admin` y contraseña `admin`.
3. **Añadir Fuente de Datos**:
* Ve a **Connections** -> **Data Sources**.
* Busca **Loki**.
* En URL pon: `http://localhost:3100`
* Dale a **Save & Test**.


4. **Explorar los logs**:
* Ve al icono de la brújula (**Explore**).
* Selecciona Loki y escribe en la barra: `{job="varlogs"}`.
* ¡Deberías ver los mensajes de tus compañeros!



---

## 🚩 El Reto Final para los Alumnos

Una vez todo funcione, pídeles que hagan lo siguiente para generar "acción":

1. **Ataque de fuerza bruta:** Que el Alumno A intente hacer SSH al Alumno B fallando la contraseña a propósito 10 veces seguidas.
2. **Detección:** El Alumno C debe buscar en Grafana la frase `"Failed password"` y crear un panel de tipo **Stat** que cuente esos fallos.
3. **Rastro de Sudo:** Que alguien ejecute `sudo apt update` y el analista busque quién ha usado el comando `sudo`.
