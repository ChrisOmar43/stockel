#!/bin/bash

echo "=== Estado de todos los contenedores ==="
docker compose ps

echo ""
echo "=== Logs de la aplicación (últimas 30 líneas) ==="
docker compose logs app --tail=30

echo ""
echo "=== Logs de Nginx (últimas 10 líneas) ==="
docker compose logs nginx --tail=10

echo ""
echo "=== Verificando si la app está respondiendo internamente ==="
docker compose exec app wget -q -O- http://localhost:3000 2>&1 | head -20 || echo "La app aún no está lista"

echo ""
echo "=== Esperando 30 segundos para que la app termine de construirse... ==="
echo "La app está ejecutando 'npm run build' que puede tardar 1-2 minutos"
sleep 30

echo ""
echo "=== Verificando de nuevo después de esperar ==="
docker compose logs app --tail=20
