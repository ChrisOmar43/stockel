#!/bin/bash

# Script para configurar dominio con SSL en Stockël
# Ejecutar como root en el VPS

DOMAIN="cbros.space"
EMAIL="tu@email.com"  # Cambiar por tu email real

echo "===================================="
echo "🌐 Configurando $DOMAIN con SSL"
echo "===================================="
echo ""

# Verificar que el script se ejecute como root
if [[ $EUID -ne 0 ]]; then
   echo "❌ Este script debe ejecutarse como root (sudo)"
   exit 1
fi

# 1. Actualizar sistema
echo "📦 Actualizando sistema..."
apt update

# 2. Instalar Nginx
echo "🔧 Instalando Nginx..."
apt install -y nginx

# 3. Instalar Certbot para Let's Encrypt
echo "🔐 Instalando Certbot..."
apt install -y certbot python3-certbot-nginx

# 4. Detener Nginx temporalmente
systemctl stop nginx

# 5. Crear configuración de Nginx para el dominio
echo "📝 Creando configuración de Nginx..."
cat > /etc/nginx/sites-available/stockel << EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# 6. Habilitar el sitio
echo "✅ Habilitando sitio..."
ln -sf /etc/nginx/sites-available/stockel /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# 7. Verificar configuración de Nginx
echo "🔍 Verificando configuración de Nginx..."
nginx -t

if [ $? -ne 0 ]; then
    echo "❌ Error en la configuración de Nginx"
    exit 1
fi

# 8. Iniciar Nginx
echo "🚀 Iniciando Nginx..."
systemctl start nginx
systemctl enable nginx

# 9. Obtener certificado SSL
echo "🔐 Obteniendo certificado SSL de Let's Encrypt..."
echo "⚠️  IMPORTANTE: Asegúrate de que el DNS apunte a esta IP antes de continuar"
read -p "¿El DNS ya apunta a este servidor? (y/n): " dns_ready

if [ "$dns_ready" != "y" ]; then
    echo "⏸️  Por favor, configura el DNS primero y ejecuta este script de nuevo"
    exit 0
fi

certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos -m $EMAIL --redirect

if [ $? -eq 0 ]; then
    echo "✅ Certificado SSL instalado exitosamente"
else
    echo "⚠️  No se pudo obtener el certificado SSL"
    echo "Verifica que:"
    echo "  1. El DNS apunte correctamente a este servidor"
    echo "  2. Los puertos 80 y 443 estén abiertos"
    echo ""
    echo "Puedes intentar manualmente con:"
    echo "  certbot --nginx -d $DOMAIN -d www.$DOMAIN"
fi

# 10. Configurar renovación automática
echo "🔄 Configurando renovación automática de SSL..."
systemctl enable certbot.timer
systemctl start certbot.timer

# 11. Configurar firewall (si UFW está instalado)
if command -v ufw &> /dev/null; then
    echo "🔥 Configurando firewall..."
    ufw allow 'Nginx Full'
    ufw delete allow 'Nginx HTTP'
else
    echo "⚠️  UFW no está instalado, asegúrate de que los puertos 80 y 443 estén abiertos"
fi

# 12. Reiniciar Nginx
echo "🔄 Reiniciando Nginx..."
systemctl restart nginx

echo ""
echo "===================================="
echo "✅ ¡Configuración completada!"
echo "===================================="
echo ""
echo "🌐 Tu sitio debería estar disponible en:"
echo "   https://$DOMAIN"
echo "   https://www.$DOMAIN"
echo ""
echo "📝 Próximos pasos:"
echo "1. Actualiza el archivo .env en /root/stockel/.env"
echo "   NEXTAUTH_URL=https://$DOMAIN"
echo ""
echo "2. Reinicia los contenedores:"
echo "   cd /root/stockel"
echo "   docker compose restart"
echo ""
echo "3. Verifica que todo funcione:"
echo "   https://$DOMAIN"
echo ""
echo "🔐 El certificado SSL se renovará automáticamente cada 90 días"
echo ""
