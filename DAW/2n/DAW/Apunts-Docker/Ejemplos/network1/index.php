<?php
// Configuración de la Base de Datos
$servername = "mysql"; // Usamos el nombre del servicio de Docker Compose como hostname
$username = "user";
$password = "password";
$dbname = "tienda_db";

// Intento de conexión
$conn = new mysqli($servername, $username, $password, $dbname);

// Comprobar la conexión
if ($conn->connect_error) {
    die("<h1>❌ Error de Conexión a MySQL</h1><p>Verifica que el contenedor 'mysql' esté corriendo en la red 'xarxa1'.</p><p>Error: " . $conn->connect_error . "</p>");
}

// Consulta SQL
$sql = "SELECT id, nombre, caracteristicas, precio, stock FROM productos";
$result = $conn->query($sql);

?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tienda de Productos - Docker Stack</title>
    <style>
        body { font-family: sans-serif; margin: 20px; background-color: #f4f7f6; }
        h1 { color: #007bff; border-bottom: 2px solid #007bff; padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); background-color: white; }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #007bff; color: white; }
        tr:hover { background-color: #f1f1f1; }
        .success { color: #28a745; font-weight: bold; }
        .info { font-size: 0.9em; color: #6c757d; margin-top: 15px; border-left: 5px solid #ffc107; padding: 10px; background-color: #fff3cd; }
    </style>
</head>
<body>
    <h1>✅ Productos de la Base de Datos (MySQL)</h1>
    <div class="info">
        Esta página fue servida por <strong>Nginx</strong>, quien solicitó la respuesta a <strong>PHP</strong>, y <strong>PHP</strong> obtuvo los datos del contenedor <strong>MySQL</strong>, todo a través de la red <code>xarxa1</code>.
    </div>

    <?php
    if ($result->num_rows > 0) {
        echo "<table>";
        echo "<thead><tr><th>ID</th><th>Nombre</th><th>Características</th><th>Precio</th><th>Stock</th></tr></thead>";
        echo "<tbody>";
        // Mostrar los datos de cada fila
        while($row = $result->fetch_assoc()) {
            echo "<tr>";
            echo "<td>" . $row["id"] . "</td>";
            echo "<td>" . $row["nombre"] . "</td>";
            echo "<td>" . $row["caracteristicas"] . "</td>";
            echo "<td class='success'>" . number_format($row["precio"], 2, ',', '.') . " €</td>";
            echo "<td>" . $row["stock"] . "</td>";
            echo "</tr>";
        }
        echo "</tbody></table>";
    } else {
        echo "<p>No se encontraron productos.</p>";
    }
    $conn->close();
    ?>
</body>
</html>