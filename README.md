# 🏪 Stockël - Sistema de Gestión de Inventario

Sistema web moderno para gestión de inventario construido con Next.js, Prisma, PostgreSQL y Docker.

## 🚀 Deploy Automático

Este proyecto cuenta con **CI/CD automático** mediante GitHub Actions. Cada push a la rama `main` despliega automáticamente a producción.

**URL de Producción:** http://72.62.129.32:3000

---

## 📚 Documentación

### Para Nuevos Desarrolladores
- **[Guía del Desarrollador](GUIA_DESARROLLADOR.md)** - ¿Primera vez en el proyecto? Empieza aquí
- **[Ejemplos de Git](EJEMPLO_FLUJO_GIT.md)** - Comandos Git con ejemplos prácticos

### Para Configuración
- **[Setup CI/CD desde Cero](SETUP_CICD_DESDE_CERO.md)** - Configurar deploy automático
- **[Configuración de Autenticación](AUTH_SETUP.md)** - Sistema de auth y usuarios

---

## 🛠️ Stack Tecnológico

- **Frontend:** Next.js 16 (App Router), React 19, TailwindCSS 4
- **Backend:** Next.js API Routes, Prisma ORM
- **Base de Datos:** PostgreSQL 15
- **Autenticación:** NextAuth.js, JWT, bcrypt
- **DevOps:** Docker, Docker Compose, GitHub Actions
- **VPS:** Ubuntu 24.04 LTS (Hostinger)

---

## 🚀 Inicio Rápido para Desarrolladores

### 1. Clonar el repositorio

```bash
git clone https://github.com/ChrisOmar43/stockel.git
cd stockel
```

### 2. Instalar Docker Desktop

Descarga e instala Docker Desktop para tu sistema operativo:
- [Windows/Mac](https://www.docker.com/products/docker-desktop)
- [Linux](https://docs.docker.com/desktop/install/linux-install/)

### 3. Crear archivo de entorno

```bash
cp .env.example .env
```

O crea un archivo `.env` con:

```env
DATABASE_URL=postgresql://stockel_user:password123@db:5432/stockel_db
POSTGRES_USER=stockel_user
POSTGRES_PASSWORD=password123
POSTGRES_DB=stockel_db
NEXTAUTH_SECRET=local-dev-secret-key-change-this
NEXTAUTH_URL=http://localhost:3000
```

### 4. Levantar el proyecto

```bash
docker-compose up -d
```

### 5. Ejecutar migraciones

```bash
docker-compose exec app npx prisma migrate dev
```

### 6. Abrir en el navegador

http://localhost:3000

---

## 🔄 Flujo de Trabajo (Workflow)

### Desarrollo Local

1. Obtener últimos cambios:
```bash
git pull origin main
```

2. Hacer cambios en el código

3. Agregar y hacer commit:
```bash
git add .
git commit -m "Descripción clara de los cambios"
```

4. Subir a GitHub:
```bash
git push origin main
```

5. **¡Deploy automático!** 🎉
   - Ve a GitHub → Actions
   - Espera 2-3 minutos
   - Verifica en producción

---

## 🗂️ Estructura del Proyecto

```
stockel/
├── .github/
│   └── workflows/
│       └── deploy.yml          # Configuración de CI/CD
├── prisma/
│   ├── schema.prisma          # Modelo de base de datos
│   └── migrations/            # Migraciones
├── src/
│   ├── app/
│   │   ├── api/
│   │   │   └── auth/         # Endpoints de autenticación
│   │   ├── login/            # Página de login
│   │   ├── register/         # Página de registro
│   │   └── page.tsx          # Página principal
│   ├── components/           # Componentes reutilizables
│   └── lib/
│       └── prisma.ts         # Cliente de Prisma
├── docker-compose.yml        # Configuración de Docker
├── Dockerfile               # Imagen de la aplicación
└── .env                     # Variables de entorno (no subir a Git)
```

---

## 📝 Scripts Disponibles

```bash
# Desarrollo local
npm run dev

# Build de producción
npm run build

# Iniciar en producción
npm start

# Linter
npm run lint
```

---

## 🐳 Comandos Docker Útiles

```bash
# Levantar contenedores
docker-compose up -d

# Ver logs
docker-compose logs app -f

# Detener contenedores
docker-compose down

# Reconstruir contenedores
docker-compose up -d --build

# Ejecutar migraciones
docker-compose exec app npx prisma migrate deploy

# Acceder al contenedor
docker-compose exec app sh

# Ver contenedores corriendo
docker-compose ps
```

---

## 🔐 Autenticación

El sistema incluye autenticación completa con:

- ✅ Registro de usuarios
- ✅ Login con JWT
- ✅ Recuperación de contraseña
- ✅ Verificación de email
- ✅ Protección de rutas

Ver más detalles en [AUTH_SETUP.md](AUTH_SETUP.md)

---

## 🌐 Despliegue en Producción

El proyecto está configurado para desplegarse automáticamente en un VPS mediante GitHub Actions.

### Variables de Entorno en Producción

Asegúrate de configurar estas variables en el archivo `.env` del VPS:

- `DATABASE_URL`: Conexión a PostgreSQL
- `NEXTAUTH_SECRET`: Secreto para JWT (generar uno seguro)
- `NEXTAUTH_URL`: URL de producción

### Deploy Manual (si es necesario)

```bash
# Conectarse al VPS
ssh root@72.62.129.32

# Ir al directorio del proyecto
cd /root/stockel

# Actualizar código
git pull origin main

# Reconstruir y reiniciar
docker compose down
docker compose up -d --build

# Ejecutar migraciones
docker compose exec -T app npx prisma migrate deploy
```

---

## 🤝 Contribuir

1. Clona el repositorio
2. Crea una rama para tu feature: `git checkout -b feature/nueva-funcionalidad`
3. Haz commit de tus cambios: `git commit -m "Agregar nueva funcionalidad"`
4. Sube la rama: `git push origin feature/nueva-funcionalidad`
5. Abre un Pull Request

---

## 🐛 Reportar Problemas

Si encuentras un bug o tienes una sugerencia:

1. Ve a la pestaña [Issues](https://github.com/ChrisOmar43/stockel/issues)
2. Click en "New Issue"
3. Describe el problema o sugerencia
4. Agrega capturas de pantalla si es necesario

---

## 📖 Recursos de Aprendizaje

- [Next.js Documentation](https://nextjs.org/docs)
- [Prisma Documentation](https://www.prisma.io/docs)
- [Docker Documentation](https://docs.docker.com/)
- [GitHub Actions Documentation](https://docs.github.com/actions)
- [Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)

---

## 👥 Equipo

- **Carlos** - Desarrollo principal

---

## 📄 Licencia

Este proyecto es privado y de uso interno.

---

## 🎯 Roadmap

- [x] Sistema de autenticación
- [x] CI/CD automático
- [ ] Dashboard de administración
- [ ] Gestión de productos
- [ ] Control de inventario
- [ ] Reportes y estadísticas
- [ ] Gestión de proveedores
- [ ] Sistema de notificaciones

---

**Última actualización:** 2025-12-12
