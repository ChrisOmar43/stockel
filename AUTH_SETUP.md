# Sistema de Autenticación - Stockël

Sistema completo de autenticación con Login, Registro y Recuperación de contraseña implementado con Next.js 16, Prisma 7 y PostgreSQL.

## Características Implementadas

- ✅ Registro de usuarios
- ✅ Login con JWT
- ✅ Recuperación de contraseña por email
- ✅ Reset de contraseña con token
- ✅ Validación de formularios
- ✅ Hash de contraseñas con bcrypt
- ✅ UI responsive con Tailwind CSS

## Estructura del Proyecto

```
src/
├── app/
│   ├── api/auth/
│   │   ├── login/route.ts          # POST /api/auth/login
│   │   ├── register/route.ts       # POST /api/auth/register
│   │   ├── forgot-password/route.ts # POST /api/auth/forgot-password
│   │   └── reset-password/route.ts  # POST /api/auth/reset-password
│   ├── login/page.tsx               # Página de login
│   ├── register/page.tsx            # Página de registro
│   ├── forgot-password/page.tsx     # Página de solicitud de recuperación
│   └── reset-password/page.tsx      # Página de reset de contraseña
└── lib/
    └── prisma.ts                    # Cliente de Prisma

prisma/
├── schema.prisma                    # Modelo de base de datos
└── prisma.config.ts                 # Configuración de Prisma 7
```

## Configuración

### 1. Base de Datos PostgreSQL

Configura tu base de datos PostgreSQL y actualiza el archivo `.env`:

```env
DATABASE_URL="postgresql://usuario:contraseña@localhost:5432/stockel?schema=public"
```

Si usas Docker, puedes levantar PostgreSQL con:

```bash
docker run --name stockel-postgres -e POSTGRES_PASSWORD=password -e POSTGRES_USER=stockel -e POSTGRES_DB=stockel -p 5432:5432 -d postgres:15
```

Luego actualiza la URL:
```env
DATABASE_URL="postgresql://stockel:password@localhost:5432/stockel?schema=public"
```

### 2. Variables de Entorno

Actualiza el archivo `.env` con tus credenciales:

```env
# Base de datos
DATABASE_URL="postgresql://usuario:contraseña@localhost:5432/stockel?schema=public"

# JWT
JWT_SECRET="cambia-esto-por-un-secreto-seguro-en-produccion"
NEXTAUTH_SECRET="cambia-esto-por-otro-secreto-seguro"
NEXTAUTH_URL="http://localhost:3000"

# Email (opcional - para recuperación de contraseña)
SMTP_HOST="smtp.gmail.com"
SMTP_PORT="587"
SMTP_USER="tu-email@gmail.com"
SMTP_PASSWORD="tu-app-password"
EMAIL_FROM="noreply@stockel.com"
```

#### Configurar Email con Gmail (Opcional)

1. Ve a tu cuenta de Google
2. Habilita la verificación en 2 pasos
3. Genera una contraseña de aplicación en: https://myaccount.google.com/apppasswords
4. Usa esa contraseña en `SMTP_PASSWORD`

### 3. Ejecutar Migraciones

```bash
npx prisma migrate dev --name init
```

Esto creará las tablas necesarias en tu base de datos.

### 4. Generar Cliente de Prisma

```bash
npx prisma generate
```

## Ejecución

```bash
npm run dev
```

Abre http://localhost:3000 en tu navegador.

## Rutas Disponibles

- `/login` - Iniciar sesión
- `/register` - Crear cuenta nueva
- `/forgot-password` - Solicitar recuperación de contraseña
- `/reset-password?token=XXX` - Resetear contraseña (accesible desde el email)

## API Endpoints

### POST /api/auth/register
Registra un nuevo usuario.

**Body:**
```json
{
  "email": "usuario@example.com",
  "password": "contraseña123",
  "name": "Nombre Usuario"
}
```

**Respuesta exitosa (201):**
```json
{
  "message": "Usuario registrado exitosamente",
  "user": {
    "id": "uuid",
    "email": "usuario@example.com",
    "name": "Nombre Usuario"
  }
}
```

### POST /api/auth/login
Inicia sesión y devuelve un JWT.

**Body:**
```json
{
  "email": "usuario@example.com",
  "password": "contraseña123"
}
```

**Respuesta exitosa (200):**
```json
{
  "message": "Login exitoso",
  "token": "jwt-token-aqui",
  "user": {
    "id": "uuid",
    "email": "usuario@example.com",
    "name": "Nombre Usuario"
  }
}
```

### POST /api/auth/forgot-password
Envía un email con un enlace para resetear la contraseña.

**Body:**
```json
{
  "email": "usuario@example.com"
}
```

**Respuesta exitosa (200):**
```json
{
  "message": "Si el email existe, recibirás un enlace de recuperación"
}
```

### POST /api/auth/reset-password
Resetea la contraseña usando el token recibido por email.

**Body:**
```json
{
  "token": "token-de-recuperacion",
  "password": "nueva-contraseña123"
}
```

**Respuesta exitosa (200):**
```json
{
  "message": "Contraseña actualizada exitosamente"
}
```

## Modelo de Datos

```prisma
model User {
  id                String    @id @default(uuid())
  email             String    @unique
  password          String
  name              String?
  emailVerified     DateTime?
  resetToken        String?   @unique
  resetTokenExpiry  DateTime?
  createdAt         DateTime  @default(now())
  updatedAt         DateTime  @updatedAt
}
```

## Seguridad

- Las contraseñas se hashean con bcrypt (10 rounds)
- Los tokens JWT expiran en 7 días
- Los tokens de recuperación expiran en 1 hora
- No se revela si un email existe o no en forgot-password (seguridad)
- Las credenciales inválidas muestran mensajes genéricos

## Flujo de Uso

### Registro
1. Usuario accede a `/register`
2. Completa el formulario (email, contraseña, nombre)
3. Se crea el usuario con contraseña hasheada
4. Redirige a `/login`

### Login
1. Usuario accede a `/login`
2. Ingresa email y contraseña
3. Recibe un JWT token
4. El token se guarda en localStorage
5. Redirige a la página principal

### Recuperación de Contraseña
1. Usuario accede a `/forgot-password`
2. Ingresa su email
3. Recibe un email con un enlace (válido por 1 hora)
4. Hace clic en el enlace que lo lleva a `/reset-password?token=XXX`
5. Ingresa nueva contraseña
6. La contraseña se actualiza
7. Redirige a `/login`

## Próximos Pasos Sugeridos

- [ ] Implementar protección de rutas con middleware
- [ ] Agregar verificación de email
- [ ] Implementar refresh tokens
- [ ] Agregar rate limiting en las APIs
- [ ] Implementar 2FA (autenticación de dos factores)
- [ ] Agregar sesiones de usuario
- [ ] Implementar logout
- [ ] Agregar roles y permisos

## Comandos Útiles

```bash
# Ver la base de datos con Prisma Studio
npx prisma studio

# Crear una nueva migración
npx prisma migrate dev --name nombre-de-migracion

# Resetear la base de datos
npx prisma migrate reset

# Aplicar migraciones en producción
npx prisma migrate deploy
```

## Notas Importantes

- **No olvides cambiar** `JWT_SECRET` y `NEXTAUTH_SECRET` en producción
- El email es opcional para desarrollo, pero necesario para la recuperación de contraseña
- Asegúrate de que PostgreSQL esté corriendo antes de ejecutar migraciones
- El cliente de Prisma se genera en `src/generated/prisma`
