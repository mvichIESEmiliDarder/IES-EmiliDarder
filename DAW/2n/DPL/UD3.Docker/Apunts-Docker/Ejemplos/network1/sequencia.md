
## Estructura de directoris

```
.
├── app_php
│   ├── Dockerfile
│   └── index.php
├── bd_mysql
│   ├── data
│   └── schema.sql
└── web_nignx
    └── nginx.conf

mkdir app_php
mkdir bd_mysql
mkdir -p bd_mysql/data
mkdir web_nginx
```

## 1\. Creació de la Xarxa

```bash
docker network create xarxa
```

## 2\. Llançament del Contenidor MySQL

```bash
docker run -d \
  --name bd_mysql \
  --network xarxa \
  -e MYSQL_ROOT_PASSWORD=toor \
  -e MYSQL_DATABASE=tienda_db \
  -e MYSQL_USER=iesemili \
  -e MYSQL_PASSWORD=iesemili \
  -v "$(pwd)/bd_mysql/data:/var/lib/mysql" \
  -v "$(pwd)/bd_mysql/schema.sql:/tmp/schema.sql" \
  mysql:8.0
```

## 3\. Llançament del Contenidor de PHP
### 3.1\. Construcció de la Imatge Personalitzada de PHP

Utilitzarem el `Dockerfile` que hem de crear a la carpeta app_php per crear una imatge amb l'extensió `mysqli` necessària.

```bash
cd app_php
docker build -t php-app:latest .
```
### 3.2\. Llançam la imatge 

**Atencio!** Ens hem de situar a l'arrel del projecte. 

```bash
cd ..
docker run -d \
  --name servidor_php \
  --network xarxa \
  -v "$(pwd)/app_php:/var/www/html" \
  php-app:latest
```

## 4\. Llançament del Contenidor de NGINX

```bash
docker run -d \
  --name servidor_nginx \
  --network xarxa \
  -p 7070:80 \
  -v "$(pwd)/app_php:/var/www/html" \
  -v "$(pwd)/web_nginx/nginx.conf:/etc/nginx/conf.d/default.conf" \
  nginx:stable-alpine
```

## 5\. Bolcat de les dades a la BD

Per tal de que la BD tingui informació dins, bolcam una mostra.

```bash
docker exec -i bd_mysql mysql -u root -ptoor < ./bd_mysql/schema.sql
```

-----

Aquesta seqüència de passos hauria d'engegar tot *l'stack*. És la primera connexió que feim de diversos contenidors en la mateixa xarxa.