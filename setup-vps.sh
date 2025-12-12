#!/bin/bash

echo "===================================="
echo "🚀 Preparando VPS para Stockël"
echo "===================================="
echo ""

# Actualizar el sistema
echo "📦 Actualizando sistema..."
apt update && apt upgrade -y

# Instalar dependencias básicas
echo "📦 Instalando dependencias básicas..."
apt install -y ca-certificates curl gnupg git

# Instalar Docker
echo "🐳 Instalando Docker..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Habilitar Docker
echo "✅ Habilitando Docker..."
systemctl enable docker
systemctl start docker

# Verificar instalación de Docker
echo "✅ Verificando Docker..."
docker --version
docker compose version

# Clonar repositorio
echo "📥 Clonando repositorio Stockël..."
cd /root
if [ -d "stockel" ]; then
  echo "⚠️  El directorio stockel ya existe. Eliminando..."
  rm -rf stockel
fi

git clone https://github.com/ChrisOmar43/stockel.git
cd stockel

# Crear archivo .env
echo "📝 Creando archivo .env..."
cat > .env << 'EOF'
DATABASE_URL=postgresql://stockel_user:StockelSecurePass2024@db:5432/stockel_db
POSTGRES_USER=stockel_user
POSTGRES_PASSWORD=StockelSecurePass2024
POSTGRES_DB=stockel_db
NEXTAUTH_SECRET=tu-secreto-super-seguro-cambiar-en-produccion
NEXTAUTH_URL=http://72.62.129.32:3000
EOF

echo ""
echo "===================================="
echo "✅ VPS preparado exitosamente!"
echo "===================================="
echo ""
echo "📋 Próximos pasos:"
echo "1. Revisa el archivo .env en /root/stockel/.env"
echo "2. Cambia NEXTAUTH_SECRET por un valor seguro"
echo "3. Ejecuta: cd /root/stockel && docker-compose up -d"
echo ""
