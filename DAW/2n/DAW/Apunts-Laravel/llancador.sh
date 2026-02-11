#!/bin/bash
git pull origin main
docker compose up -d --build
docker compose exec app composer install --no-dev --optimize-autoloader
docker compose exec app php artisan migrate --force
docker compose exec app php artisan config:cache  # Optimiza la lectura de config
docker compose exec app php artisan route:cache    # Optimiza el registro de rutas