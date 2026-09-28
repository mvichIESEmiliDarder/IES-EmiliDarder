## Ejemplo de una TaskList en Laravel

### Paso 1: "Encender" el entorno

Antes de tocar código, hay que arrancar el servidor. En la terminal de tu ordenador (en la raíz del proyecto) ejecuta:

```bash
# Equivale al botón "Start" de Laragon
docker compose up -d
```

### Paso 2: El truco de la velocidad (El Alias)

Para no escribir comandos largos, podéis copiar y pegar en vuestra terminal (solo una vez por sesión):

```bash
alias art='docker compose exec app php artisan'
```

*A partir de ahora, usaremos `art` para todo.*

### Paso 3: Crear la estructura (Desde la terminal local)

Aunque los comandos se ejecutan "dentro del contenedor", los archivos serán editables desde VS Code:

1. **Crear el Modelo y la Migración:**
```bash
art make:model Task -m
```

*(El `-m` crea el archivo de base de datos y el modelo a la vez).*
2. **Crear el Controlador:**
```bash
art make:controller TaskController
```

---

### Paso 4: Programar (Desde VS Code)

Aquí es donde nos olvidamos de Docker. Abre VS Code y edita los archivos que acaban de aparecer en la carpeta `src/`.

#### A. Definir la tabla (`src/database/migrations/xxxx_create_tasks_table.php`)

```php
public function up(): void {
    Schema::create('tasks', function (Blueprint $table) {
        $table->id();
        $table->string('nombre');
        $table->boolean('completada')->default(false);
        $table->timestamps();
    });
}
```

#### B. Lógica en el Controlador (`src/app/Http/Controllers/TaskController.php`)

```php
namespace App\Http\Controllers;
use App\Models\Task;

class TaskController extends Controller {
    public function index() {
        // Creamos una tarea de prueba si la tabla está vacía
        if (Task::count() == 0) {
            Task::create(['nombre' => 'Aprender Docker con Laravel']);
        }
        return Task::all(); // Devuelve todas las tareas en JSON
    }
}
```

#### C. Registrar la Ruta (`src/routes/web.php`)

```php
use App\Http\Controllers\TaskController;
use Illuminate\Support\Facades\Route;

Route::get('/tareas', [TaskController::class, 'index']);
```

#### D. Permitir que el campo `nombre` sea seguro (`src/app/Models/Task.php`)

```php 
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Task extends Model
{
    protected $fillable = ['nombre'];
}
```

---

### Paso 5: Ejecutar los cambios

De vuelta a la terminal, para que la base de datos se actualice:

```bash
art migrate
```

### Paso 6: Resultado final

Abre tu navegador en:
`http://localhost:8000/tareas`

---

### Resumen del flujo 

1. **Terminal:** `docker compose up -d` y `alias art=...`
2. **Terminal:** Crear ficheros con `art make:...`
3. **VS Code:** Escribir el código PHP (guardar archivos).
4. **Terminal:** Ejecutar `art migrate`.
5. **Navegador:** Ver el resultado.


