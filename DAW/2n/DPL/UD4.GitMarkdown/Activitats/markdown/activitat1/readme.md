# Desplegament d'un Servidor Web Nginx

Aquesta activitat consisteix en la posada en marxa d'un servidor web **Nginx** utilitzant **Docker**. L'objectiu és fer servir una pàgina estàtica personalitzada mitjançant un contenidor lleuger i eficient.

### Requisits previs

* Disposar de **Docker** instal·lat al sistema.
* Accés a una terminal o connexió **SSH** al servidor.
* Connexió a Internet per descarregar la imatge oficial de **Docker Hub**.

---

## Fitxer index.html

El contingut del fitxer `index.html` que servirà el nostre Nginx és el següent:

```html
<!DOCTYPE html>
<html lang="ca">
<head>
    <meta charset="UTF-8">
    <title>Benvinguts a Docker Simple2</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }
        h1 {
            color: #CAF01F; /* Color personalitzat */
            font-size: 2.5em;
        }
    </style>
</head>
<body>
    <div class="missatge-simple">
        <h1>Benvinguts a Docker2!</h1>
    </div>
</body>
</html>

```
---

## Passes per a l'execució

1. **Descarregar la imatge oficial:**
Baixem la darrera versió d'Nginx des de Docker Hub amb la comanda:

`docker pull nginx` 

2. **Preparar l'entorn local:**
Creem el directori de treball per a la persistència de dades:

`mkdir -p /home/iesemili/docker/webserver2/html` 

3. **Executar el contenidor:**
Lancem el contenidor amb el nom `webserver2`, mapejant el port 8081 i creant el volum per al contingut HTML:

`docker run -d --name webserver2 -p 8081:80 -v /home/iesemili/docker/webserver2/html:/usr/share/nginx/html nginx:latest` 

## Verificació
Per comprovar que el servei està funcionant correctament, obriu el vostre navegador i accediu a la següent adreça:

[http://localhost:8081](http://localhost:8081)

Hauríem de veure el missatge "Benvinguts a Docker2!" amb el color corporatiu definit (#CAF01F).
