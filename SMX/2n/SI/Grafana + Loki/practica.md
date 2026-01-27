# 🚀 Práctica: "Misión SOC: Cazadores de Intrusos"

## 1. El Escenario (El "Gancho")

Imagina que acabas de ser contratado en el equipo de ciberseguridad de una gran empresa. Tu jefe te da una noticia preocupante: **"Creemos que alguien está intentando entrar en nuestros servidores, pero no tenemos ojos en la red"**.

Tu misión es construir un **Centro de Mando (Dashboard)** profesional. No vas a leer archivos de texto infinitos; vas a crear un sistema de monitorización visual donde los ataques "brillen" en rojo en el momento en que ocurran. Si alguien intenta forzar una contraseña, tú serás el primero en saberlo.

---

## 2. El Objetivo Tecnológico

Montar un **Stack PLG** (Promtail + Loki + Grafana) alimentado por **Rsyslog**. Al finalizar la clase, vuestro servidor central mostrará:

* **Gráficos de barras** con intentos de acceso fallidos.
* **Alertas visuales** cuando alguien use privilegios de administrador (`sudo`).
* **Logs en tiempo real** de todas las máquinas de vuestros compañeros.

---

## 3. Vuestra "Armería" (Herramientas)

1. **Rsyslog:** El "mensajero". Se encarga de recoger los secretos del sistema y enviarlos por la red.
2. **Loki:** La "base de datos". El cerebro que organiza los logs sin consumir apenas RAM.
3. **Grafana:** El "artista". La herramienta que convertirá los datos aburridos en paneles con luces y colores.

---

## 4. Fases de la Operación

### Fase 1: El Chivato (Rsyslog)

Configuraremos el archivo `/etc/rsyslog.conf` de vuestras máquinas cliente para que todo lo que pase se envíe por el **puerto 514** hacia vuestro servidor central.

> *Reto:* ¿Podéis hacer que el servidor reciba logs de la máquina de vuestro compañero de al lado?

### Fase 2: El Almacén (Loki & Promtail)

Usaremos **Docker** para levantar el motor de logs. Es la tecnología que usan empresas como Netflix o Spotify para gestionar sus sistemas.

* Lanzaremos un `docker-compose.yml` que pondrá en marcha toda la infraestructura en segundos.

### Fase 3: ¡Que se haga la luz! (Grafana)

Entraremos en el panel web (puerto 3000) y conectaremos el "grifo" de datos.

* **El desafío final:** Crea un panel (Dashboard) que cuente cuántas veces aparece la palabra **"Failed password"**. Si el número sube de 5 en un minuto... ¡estamos bajo ataque!

---

## 5. ¿Qué aprenderás hoy?

* A centralizar logs de múltiples servidores (¡No más ir máquina por máquina!).
* A usar **Docker**, la herramienta más demandada hoy en día.
* A crear visualizaciones profesionales que dejan a cualquier jefe con la boca abierta.

---

### Notas para ti el profesor:

* **Preparación:** Te recomiendo tener preparado el archivo `docker-compose.yml` que levante Loki y Grafana.
* **El "momento WOW":** Pídeles que, una vez montado el Grafana, lancen un ataque de fuerza bruta con un script simple o intenten hacer `ssh` con contraseña errónea muchas veces. Ver cómo las gráficas suben de golpe en Grafana es lo que realmente les hace entender la utilidad de la monitorización.
