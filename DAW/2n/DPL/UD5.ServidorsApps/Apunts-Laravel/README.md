# 🚀 Proyecto Laravel con Docker

Bienvenido a tu entorno de desarrollo profesional. Este sistema utiliza **Docker** para asegurar que el proyecto funcione exactamente igual en tu ordenador, en el de tu compañero y en el servidor de producción.

## 🛠️ Requisitos previos

* Tener instalado **Docker Desktop** o **Docker Engine**.
* Un editor de código (recomendamos **VS Code**).

---

## 🏁 Inicio Rápido

### 1. Levantar el entorno

Abre una terminal en la raíz del proyecto y ejecuta:

```bash
docker compose up -d
```

*Este comando equivale al botón **"Start"** de Laragon. Levanta Nginx, PHP 8.2 y MySQL 8.0.*

### 2. El Atajo "Mágico" (Alias)

Para no escribir comandos largos, activa este alias en tu terminal:

```bash
alias art='docker compose exec app php artisan'
```

*Ahora, en lugar de `php artisan`, solo tendrás que escribir `art`.*

### 3. Instalación inicial (Solo la primera vez)

```bash
art migrate
```

---

## 💻 Flujo de Trabajo Diario

### ¿Dónde programo?

Todo tu código de Laravel está dentro de la carpeta `/src`. **No necesitas entrar al contenedor para programar**. Abre VS Code en `/src` y cualquier cambio que guardes se reflejará al instante en el navegador.

### ¿Cómo veo mi web?

Accede a: **`http://localhost:8000`**

### Comandos frecuentes (usando el alias `art`)

| Acción | Comando |
| --- | --- |
| Crear un Modelo y Migración | `art make:model Nombre -m` |
| Crear un Controlador | `art make:controller NombreController` |
| Ejecutar migraciones | `art migrate` |
| Ver rutas registradas | `art route:list` |

---

## 📂 Estructura del Proyecto (Ops Info)

* **`.env` (Raíz)**: Configuración de la infraestructura (Passwords de DB, puertos, etc.).
* **`src/`**: Tu código fuente de Laravel. Aquí está el `.env` propio de la aplicación.
* **`docker-compose.yml`**: Define los servicios (app, web, db).

---

## ⚠️ Notas Importantes

* **Persistencia**: La base de datos se guarda en un volumen llamado `db_data`. Aunque detengas los contenedores, tus datos seguirán ahí.
* **Errores de Base de Datos**: Si cambias algo en el `.env` de la raíz relativo a MySQL, debes resetear los volúmenes con `docker compose down -v` para que los cambios surtan efecto.
* **Logs**: Si algo falla (Error 500), revisa los logs en tiempo real con:
```bash
docker compose logs -f
```



---

## 🛑 Detener el entorno

Al terminar tu jornada, puedes apagar los servicios:

```bash
docker compose stop
```

