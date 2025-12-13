#!/bin/bash

echo "=== Arreglando ruta de certificados SSL ==="

# Detener nginx para poder modificar los archivos
docker compose stop nginx

# Verificar qué carpeta de certificados existe
if [ -d "./certbot/conf/live/cbros.space-0001" ]; then
    echo "✓ Certificados encontrados en cbros.space-0001"

    # Remover el directorio cbros.space si existe (probablemente vacío o con certificados dummy)
    if [ -d "./certbot/conf/live/cbros.space" ]; then
        echo "Removiendo directorio cbros.space antiguo..."
        rm -rf ./certbot/conf/live/cbros.space
    fi

    # Crear symlink
    echo "Creando enlace simbólico de cbros.space-0001 a cbros.space..."
    cd ./certbot/conf/live/
    ln -s cbros.space-0001 cbros.space
    cd ../../..

    echo "✓ Enlace simbólico creado"
    ls -la ./certbot/conf/live/
else
    echo "✗ No se encontraron certificados"
    exit 1
fi

echo ""
echo "=== Reiniciando Nginx ==="
docker compose up -d nginx

echo ""
echo "=== Esperando que Nginx inicie (5 segundos) ==="
sleep 5

echo ""
echo "=== Verificando estado de Nginx ==="
docker compose ps nginx

echo ""
echo "=== Últimos logs de Nginx ==="
docker compose logs nginx --tail=10

echo ""
echo "=== Verificando conectividad ==="
echo "Si todo está bien, tu sitio debería estar en:"
echo "https://cbros.space"
