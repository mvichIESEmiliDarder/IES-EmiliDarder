-- Crea la base de datos si no existe
CREATE DATABASE IF NOT EXISTS tienda_db;
USE tienda_db;

-- 4. Crea la tabla de productos
CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    caracteristicas TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL
);

-- Rellena la tabla con 10 productos
INSERT INTO productos (nombre, caracteristicas, precio, stock) VALUES
('Portátil Ultrabook', 'Procesador i7, 16GB RAM, 512GB SSD, pantalla 13.3"', 1250.99, 15),
('Teclado Mecánico RGB', 'Switches Cherry MX Red, iluminación personalizable', 95.50, 40),
('Monitor Curvo 27"', 'Resolución 4K, 144Hz, tiempo de respuesta 1ms', 459.99, 8),
('Auriculares Inalámbricos', 'Cancelación de ruido activa, 20 horas de batería', 180.00, 30),
('Disco Duro Externo 2TB', 'Conexión USB 3.0, diseño compacto y resistente', 65.45, 60),
('Mouse Ergonómico', 'Sensor óptico de alta precisión, recargable', 45.99, 25),
('Webcam Full HD', 'Resolución 1080p, micrófono incorporado', 32.75, 55),
('Impresora Láser Color', 'Impresión rápida a doble cara, Wi-Fi', 299.90, 12),
('Router WiFi 6', 'Doble banda, alta velocidad y cobertura', 110.00, 20),
('Silla Gaming Ergonómica', 'Respaldo reclinable, soporte lumbar ajustable', 215.50, 5);