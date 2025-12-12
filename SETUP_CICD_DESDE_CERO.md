# 🚀 Configurar CI/CD desde Cero - Stockël

Esta guía explica cómo configurar el sistema de deploy automático desde cero para el proyecto Stockël.

---

## 📋 Requisitos Previos

- ✅ Repositorio en GitHub
- ✅ VPS con Ubuntu 24.04 LTS (Hostinger o cualquier proveedor)
- ✅ Acceso SSH al VPS (usuario root)
- ✅ Proyecto con Docker y Docker Compose

---

## 🎯 Paso 1: Configurar GitHub Actions

### 1.1 Crear estructura de carpetas

En tu proyecto local, crea la carpeta:

```bash
mkdir -p .github/workflows
```

### 1.2 Crear archivo de workflow

Crea el archivo `.github/workflows/deploy.yml` con este contenido:

```yaml
name: Deploy to VPS

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Deploy to VPS
        uses: appleboy/ssh-action@v1.0.3
        with:
          host: ${{ secrets.VPS_HOST }}
          username: ${{ secrets.VPS_USERNAME }}
          password: ${{ secrets.VPS_PASSWORD }}
          script: |
            cd /root/stockel
            git pull origin main
            docker compose down
            docker compose up -d --build
            docker compose exec -T app npx prisma migrate deploy
            echo "Deploy completado exitosamente!"
```

**Importante:** Cambia `/root/stockel` por la ruta donde clonarás el proyecto en tu VPS.

---

## 🔐 Paso 2: Configurar Secretos en GitHub

1. Ve a tu repositorio en GitHub
2. Click en **Settings** (arriba a la derecha)
3. En el menú lateral: **Secrets and variables** → **Actions**
4. Click en **New repository secret**

Agrega estos 3 secretos:

| Name | Secret (Valor) |
|------|---------------|
| `VPS_HOST` | IP de tu VPS (ej: `72.62.129.32`) |
| `VPS_USERNAME` | `root` |
| `VPS_PASSWORD` | Tu contraseña root del VPS |

---

## 🖥️ Paso 3: Preparar el VPS

### 3.1 Conectarse al VPS

```bash
ssh root@TU_IP_DEL_VPS
```

### 3.2 Ejecutar script de instalación

Copia y pega este script completo en tu terminal del VPS:

```bash
cat > setup-vps.sh << 'SCRIPT_END'
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
NEXTAUTH_URL=http://TU_IP_DEL_VPS:3000
EOF

echo ""
echo "===================================="
echo "✅ VPS preparado exitosamente!"
echo "===================================="
echo ""
echo "📋 Próximos pasos:"
echo "1. Revisa el archivo .env en /root/stockel/.env"
echo "2. Cambia NEXTAUTH_SECRET por un valor seguro"
echo "3. Ejecuta: cd /root/stockel && docker compose up -d"
echo ""
SCRIPT_END
```

**Importante:** Antes de ejecutar el script, modifica:
- Cambia `https://github.com/ChrisOmar43/stockel.git` por la URL de tu repositorio
- Cambia `TU_IP_DEL_VPS` por tu IP real

### 3.3 Ejecutar el script

```bash
chmod +x setup-vps.sh
./setup-vps.sh
```

Esto instalará Docker, clonará tu repositorio y creará el archivo `.env`.

### 3.4 Configurar variables de entorno

Edita el archivo `.env` con tus valores reales:

```bash
cd /root/stockel
nano .env
```

Cambia:
- `NEXTAUTH_SECRET` por un valor seguro (generado aleatoriamente)
- `NEXTAUTH_URL` por tu IP real

### 3.5 Iniciar la aplicación

```bash
docker compose up -d
```

### 3.6 Ejecutar migraciones de Prisma

```bash
docker compose exec app npx prisma migrate deploy
```

### 3.7 Verificar que está funcionando

```bash
docker compose ps
docker compose logs app --tail=50
```

Abre tu navegador en: `http://TU_IP_DEL_VPS:3000`

---

## ✅ Paso 4: Probar el Deploy Automático

### 4.1 Hacer un cambio en tu código local

Por ejemplo, edita `src/app/page.tsx` y agrega un comentario.

### 4.2 Subir los cambios

```bash
git add .
git commit -m "Probar CI/CD automático"
git push origin main
```

### 4.3 Verificar en GitHub Actions

1. Ve a tu repositorio en GitHub
2. Click en la pestaña **Actions**
3. Verás el workflow ejecutándose
4. Espera a que termine (2-3 minutos)
5. Verifica que tu aplicación se actualizó en el VPS

---

## 🎉 ¡Listo!

Ahora cada vez que hagas `git push origin main`, tu aplicación se desplegará automáticamente en tu VPS.

---

## 🔧 Solución de Problemas

### Error: "docker-compose: command not found"

Usa `docker compose` (con espacio) en lugar de `docker-compose` (con guión).

### Error: "libssl.so.1.1 not found"

Asegúrate de que tu `Dockerfile` incluya:

```dockerfile
RUN apk add --no-cache openssl libc6-compat
```

Y tu `prisma/schema.prisma` tenga:

```prisma
generator client {
  provider      = "prisma-client-js"
  binaryTargets = ["native", "linux-musl-openssl-3.0.x"]
}
```

### El workflow falla por SSH

Verifica que los secretos en GitHub estén configurados correctamente:
- `VPS_HOST`: Solo la IP, sin http:// ni puerto
- `VPS_USERNAME`: `root`
- `VPS_PASSWORD`: Tu contraseña correcta

---

## 📚 Recursos Adicionales

- [Documentación de GitHub Actions](https://docs.github.com/actions)
- [Documentación de Docker](https://docs.docker.com/)
- [Documentación de Prisma](https://www.prisma.io/docs)

---

**Última actualización:** 2025-12-12
