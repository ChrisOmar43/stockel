#!/bin/bash

echo "=== Verificando certificados SSL ==="

# Verificar si existen los certificados
if [ -f "./certbot/conf/live/cbros.space/fullchain.pem" ]; then
    echo "✓ Certificados encontrados en ./certbot/conf/live/cbros.space/"
    ls -la ./certbot/conf/live/cbros.space/
else
    echo "✗ No se encontraron certificados en ./certbot/conf/live/cbros.space/"
    echo "Verificando otras ubicaciones..."
    find ./certbot -name "fullchain.pem" 2>/dev/null
fi

echo ""
echo "=== Deteniendo contenedores actuales ==="
docker compose down

echo ""
echo "=== Levantando servicios ==="
docker compose up -d

echo ""
echo "=== Esperando que los servicios inicien (10 segundos) ==="
sleep 10

echo ""
echo "=== Estado de los contenedores ==="
docker compose ps

echo ""
echo "=== Verificando logs de Nginx ==="
docker compose logs nginx --tail=20

echo ""
echo "=== Verificando logs de la aplicación ==="
docker compose logs app --tail=20

echo ""
echo "=== Prueba de conectividad ==="
echo "Probando https://cbros.space"
