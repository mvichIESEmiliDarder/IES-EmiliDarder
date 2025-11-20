#!/bin/sh

# Este script lee la variable de entorno 'MENSAJE_BIENVENIDA'
# Si la variable está vacía, se usa el valor por defecto.
MENSAJE=${MENSAJE_BIENVENIDA:-"¡Hola! No especificaste un mensaje."}

echo "-------------------------------------"
echo "MENSAJE INYECTADO: $MENSAJE"
echo "-------------------------------------"

# Mantenemos el contenedor corriendo por un momento para que puedas ver la salida
sleep 10