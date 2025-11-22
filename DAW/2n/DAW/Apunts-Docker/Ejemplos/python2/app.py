import os
from flask import Flask

# Obtener la variable de entorno
greeting_message = os.environ.get('GREETING_MSG', 'Hola desde el contenedor Docker!')

app = Flask(__name__)

@app.route('/')
def hello_world():
    # Asegúrate de cerrar la cadena de texto f"""
    return f"""
    <h1>Servicio Flask en Docker</h1>
    <p>Mensaje de Saludo (ENV VAR): <b>{greeting_message}</b></p>
    """ 

if __name__ == '__main__':
    # Usamos '0.0.0.0' para que sea accesible desde fuera del contenedor
    app.run(host='0.0.0.0', port=5000)