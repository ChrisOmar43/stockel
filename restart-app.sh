#!/bin/bash

echo "=== Actualizando configuración desde Git ==="
git pull origin main

echo ""
echo "=== Deteniendo y removiendo contenedores ==="
docker compose down

echo ""
echo "=== Limpiando node_modules y .next para empezar fresco ==="
rm -rf node_modules .next

echo ""
echo "=== Reconstruyendo y levantando contenedores ==="
docker compose up -d --build

echo ""
echo "=== Esperando 15 segundos para que los servicios inicien ==="
sleep 15

echo ""
echo "=== Estado de los contenedores ==="
docker compose ps

echo ""
echo "=== Logs de la aplicación ==="
docker compose logs app --tail=30

echo ""
echo "=== Siguiendo logs de la aplicación en tiempo real ==="
echo "Presiona Ctrl+C cuando veas 'Ready in X ms'"
echo ""
docker compose logs app -f
