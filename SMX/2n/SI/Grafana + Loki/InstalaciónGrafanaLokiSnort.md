# 🛠️ Guía Técnica: Despliegue de SOC + IDS (Snort + Loki + Grafana)

## 1. Configuración del Alumno C (El Servidor del SOC)

Este alumno centraliza todo. Primero instalaremos Docker y luego configuraremos la "escucha".

### A. Instalar Docker y herramientas

```bash
sudo apt update && sudo apt install docker.io docker-compose -y
sudo systemctl enable --now docker

```

### B. Crear el entorno de visualización

Crea una carpeta llamada `lab-soc` y entra en ella:

```bash
mkdir lab-soc && cd lab-soc

```

Crea el archivo `docker-compose.yml`:

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

Crea el archivo de configuración para Promtail (`config.yml`) en la misma carpeta:

```yaml
server:
  http_listen_port: 9080
clients:
  - url: http://loki:3100/loki/api/v1/push
scrape_configs:
- job_name: system
  static_configs:
  - targets: [localhost]
    labels:
      job: varlogs
      __path__: /var/log/remotos/*/*.log

```

**Lanzar todo:** `sudo docker-compose up -d`

### C. Abrir el puerto de recepción en Rsyslog

1. Edita: `sudo nano /etc/rsyslog.conf`
2. Descomenta estas líneas:
```bash
module(load="imudp")
input(type="imudp" port="514")

```


3. Al final del archivo, añade esto para organizar los logs por carpetas:
```bash
$template RemoteLogs,"/var/log/remotos/%HOSTNAME%/%PROGRAMNAME%.log"
*.* ?RemoteLogs

```


4. Reinicia: `sudo systemctl restart rsyslog`
5. Ajusta el Firewall: `sudo ufw allow 3000/tcp && sudo ufw allow 514/udp`

---

## 2. Configuración de Alumnos A y B (Los Clientes con IDS)

### A. Configurar el envío de logs

1. Edita: `sudo nano /etc/rsyslog.conf`
2. Al final, añade (reemplaza con la IP del Alumno C):
`*.* @IP_DEL_ALUMNO_C:514`
3. Reinicia: `sudo systemctl restart rsyslog`

### B. Instalar y configurar Snort (IDS)

1. Instala: `sudo apt install snort -y` (En la ventana azul, pon la IP de tu red, ej: `192.168.1.0/24`).
2. Crea tu primera regla:
`sudo nano /etc/snort/rules/local.rules`
Añade:
`alert icmp any any -> any any (msg:"[IDS] PING DETECTADO"; sid:1000001; rev:1;)`
`alert tcp any any -> any 22 (msg:"[IDS] INTENTO CONEXION SSH"; flags:S; sid:1000002; rev:1;)`
3. **Lanzar Snort en modo alerta:**
`sudo snort -A console -q -c /etc/snort/snort.conf -s`
*(La opción `-s` hace que la alerta se mande al syslog local, y de ahí Rsyslog la mandará al Alumno C).*

---

## 3. Visualización en Grafana (Alumno C)

1. Entra en `http://IP_ALUMNO_C:3000` (admin/admin).
2. Ve a **Connections** > **Data Sources** > **Loki**.
3. En **URL** pon `http://localhost:3100` y pulsa **Save & Test**.
4. Ve a **Explore** (icono brújula) y escribe esta consulta en el buscador de LogQL:
`{job="varlogs"} |= "IDS"`

---

## 4. Prueba de Fuego (Prueba de estrés)

Para que los alumnos vean que funciona, deben hacerse esto entre ellos:

* **Prueba 1 (Ping):** Alumno B hace `ping IP_ALUMNO_A`.
* *Resultado esperado:* Aparece mensaje en Grafana: `[IDS] PING DETECTADO`.


* **Prueba 2 (Nmap):** Alumno B hace `nmap IP_ALUMNO_A`.
* *Resultado esperado:* Lluvia de alertas de conexión SSH en el dashboard.


* **Prueba 3 (Sudo):** Alumno A hace `sudo su`.
* *Resultado esperado:* Ver el log de elevación de privilegios en tiempo real.
