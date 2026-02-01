## Checklist de Verificación: Conexión Laravel-Docker

Si la aplicación muestra un error de base de datos o un "500 Server Error", revisa estos 5 puntos en orden:

### 1. El Host en el `.env`

* **Error típico:** Usar `DB_HOST=127.0.0.1` o `localhost`.
* **Corrección:** El host debe ser exactamente el nombre del servicio definido en el `docker-compose.yml`. En nuestra guía es `db`.

> `DB_HOST=db`


### 2. Sincronía de Credenciales

* **Verificación:** Compara línea a línea el archivo `docker-compose.yml` y el `.env`.
* **Check:** ¿`MYSQL_DATABASE` coincide con `DB_DATABASE`? ¿`MYSQL_USER` con `DB_USERNAME`? ¿`MYSQL_PASSWORD` con `DB_PASSWORD`?

### 3. Estado de los Servicios

* **Comando:** `docker compose ps`
* **Check:** Asegúrate de que los tres contenedores (`laravel-app`, `laravel-nginx`, `laravel-db`) tengan el estado **Up** o **Running**. Si el de la base de datos está en "Restarting", hay un error en su configuración (posiblemente una contraseña demasiado corta o falta de RAM).

### 4. Caché de Configuración

* **Problema:** Laravel a veces "recuerda" la configuración antigua aunque hayas editado el `.env`.
* **Comando:**
```bash
docker compose exec app php artisan config:clear
```

### 5. Migraciones Exitosas

* **Prueba definitiva:** Para saber si PHP realmente habla con MySQL, intenta crear las tablas del sistema.
* **Comando:**
```bash
docker compose exec app php artisan migrate
```

* **Resultado:** Si las tablas se crean, la conexión es 100% correcta.

---

### Nota sobre la persistencia

**Recordatorio:** Si cambias las credenciales en el `docker-compose.yml` **después** de haber levantado los contenedores por primera vez, MySQL no las actualizará automáticamente porque el volumen ya está creado. Para forzar el cambio, deberás ejecutar:
`docker compose down -v` (esto borrará los datos) y luego `docker compose up -d`.
