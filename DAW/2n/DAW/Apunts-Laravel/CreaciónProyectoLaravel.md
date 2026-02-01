## Guía de Verificación del Entorno Laravel

> Nota: Esta guía permite verificar la correcta integración de la pila **LEMP** optimizada para **Laravel** (NGINX, PHP-FPM y MySQL) mediante un script de prueba que valida la comunicación entre servicios.

### 1. Preparación de la Estructura de Archivos

Para que el servidor NGINX funcione según la configuración previa, es necesario respetar la estructura de directorios, especialmente la carpeta `public`.

```bash
mkdir -p src/public
```

---

### 2. Creación del Script de Conexión (`src/conexion.php`)

Este archivo contiene la lógica de conexión mediante PDO. Se debe asegurar que las variables coincidan estrictamente con las declaradas en el archivo `docker-compose.yml`.

```php
<?php
$host = 'db'; // Nombre del servicio en docker-compose
$db   = 'laravel_db';
$user = 'laravel_user';
$pass = 'laravel_password';
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
     $pdo = new PDO($dsn, $user, $pass, $options);
     $estado_db = "✅ Conexión exitosa a MySQL";
} catch (\PDOException $e) {
     $estado_db = "❌ Error de conexión: " . $e->getMessage();
}
```

---

### 3. Creación del Punto de Entrada (`src/public/index.php`)

Este archivo simula el comportamiento de Laravel al procesar las peticiones desde la carpeta `public`.

```php
<?php
require_once '../conexion.php';
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Comprobación de Sistema</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background: #f0f2f5; color: #1c1e21; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
        .card { background: white; padding: 2rem; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.1); width: 100%; max-width: 400px; }
        h1 { font-size: 1.5rem; margin-bottom: 1.5rem; border-bottom: 2px solid #eee; padding-bottom: 0.5rem; }
        .status { margin: 10px 0; padding: 10px; border-radius: 6px; background: #f8f9fa; }
        .label { font-weight: bold; display: block; font-size: 0.8rem; text-transform: uppercase; color: #65676b; }
    </style>
</head>
<body>
    <div class="card">
        <h1>Estado del Stack</h1>
        <div class="status">
            <span class="label">Servidor Web:</span> NGINX Alpine
        </div>
        <div class="status">
            <span class="label">Motor PHP:</span> Versión <?php echo phpversion(); ?> (FPM)
        </div>
        <div class="status">
            <span class="label">Base de Datos:</span> <?php echo $estado_db; ?>
        </div>
    </div>
</body>
</html>
```

---

### 4. Despliegue y Validación

Una vez creados los archivos, se procede a levantar la infraestructura:

1. **Ejecutar el despliegue:**
```bash
docker compose up -d --build
```

2. **Verificar contenedores:**
```bash
docker compose ps
```


3. **Acceso Web:** Navegar a `http://localhost:8000`.

---

### 5. Advertencias y Notas de Funcionamiento

* **Nota sobre el Host:** En el archivo `conexion.php`, el valor de `$host` debe ser `db` porque Docker resuelve los nombres de los servicios mediante su propio DNS interno.
* **Nota sobre Permisos:** Si el servidor web devuelve un error "403 Forbidden", es necesario revisar los permisos de la carpeta `src` en el sistema anfitrión:
```bash
chmod -R 755 src/
```


* **Recordatorio de Puerto:** El acceso se realiza por el puerto `8000` (mapeado en el `docker-compose.yml`), no por el puerto `80` estándar.

---

### 6. Transición a Laravel Real

Para sustituir esta prueba por un proyecto Laravel completo:

1. Eliminar el contenido de `src/`.
2. Ejecutar: `docker compose exec app composer create-project laravel/laravel .`.
3. Configurar el archivo `.env` del nuevo proyecto con las credenciales definidas en el YAML.
