
## 0\. Construcció de la Imatge Personalitzada de PHP

Utilitzarem el `Dockerfile` del Canvas, que està a la carpeta principal (`.`), per crear una imatge amb l'extensió `mysqli` necessària.

```bash
docker build -t php-app:latest .
```

-----

Ara, aplico els canvis a la teva documentació de passos:

## 1\. Creació de la Xarxa

```bash
docker network create xarxa1
```

## 2\. Llançament del Contenidor MySQL



```bash
# Cream la carpeta que contindrà la persistència
mkdir -p  db_mysql/data

docker run -d \
  --name bd_mysql \
  --network xarxa1 \
  -e MYSQL_ROOT_PASSWORD=toor \
  -e MYSQL_DATABASE=tienda_db \
  -e MYSQL_USER=iesemili \
  -e MYSQL_PASSWORD=iesemili \
  -v "$(pwd)/db_mysql/data:/var/lib/mysql" \
  -v "$(pwd)/db_mysql/schema.sql:/tmp/schema.sql" \
  mysql:8.0
```

## 3\. Llançament del Contenidor de PHP



```bash
docker run -d \
  --name servidor_php \
  --network xarxa1 \
  -v "$(pwd)/app_php:/var/www/html" \
  php-app:latest
```

## 4\. Llançament del Contenidor de NGINX

```bash
docker run -d \
  --name servidor_nginx \
  --network xarxa1 \
  -p 7070:80 \
  -v "$(pwd)/app_php:/var/www/html" \
  -v "$(pwd)/web_nignx/nginx.conf:/etc/nginx/conf.d/default.conf" \
  nginx:stable-alpine
```

## 5\. Bolcat de les dades a la BD

```bash
docker exec -i bd_mysql mysql -u root -ptoor < ./db_mysql/schema.sql
```

-----

Aquesta seqüència de passos hauria d'engegar tot el teu *stack* de manera coherent amb la teva nova estructura de fitxers i resolent tots els errors de dependències (MySQLi) i de configuració de xarxa i credencials que havíem trobat.