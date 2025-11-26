## 1. Cream la xarxa

```
docker network create xarxa1
```

## 2. Llançam el contenidor MySQL
```
docker run -d \
  --name bbdd_mysql \
  --network xarxa1 \
  -e MYSQL_ROOT_PASSWORD=root_password \
  -e MYSQL_DATABASE=tienda_db \
  -e MYSQL_USER=user \
  -e MYSQL_PASSWORD=password \
  -v "$(pwd)/db/schema.sql:/docker-entrypoint-initdb.d/schema.sql" \
  mysql:8.0
  ```

## 3. Llançam el contenidor de PHP
```
docker run -d \
  --name servidor_php \
  --network xarxa1 \
  -v "$(pwd)/www:/var/www/html" \
  php:8.2-fpm-alpine
  ```

## 4. Llançam el contenidor de NGINX
```
docker run -d \
  --name servidor_nginx \
  --network xarxa1 \
  -p 8080:80 \
  -v "$(pwd)/www:/var/www/html" \
  -v "$(pwd)/nginx/default.conf:/etc/nginx/conf.d/default.conf:ro" \
  nginx:stable-alpine
```
