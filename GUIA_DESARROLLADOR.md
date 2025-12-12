# 👨‍💻 Guía para Nuevos Desarrolladores - Stockël

Esta guía te explica cómo trabajar en el proyecto Stockël desde una **nueva computadora** cuando el CI/CD ya está configurado.

---

## 🎯 Lo Importante: ¡Ya está todo configurado!

El sistema de deploy automático **YA ESTÁ FUNCIONANDO**. Tú solo necesitas:
1. Clonar el repositorio
2. Hacer cambios
3. Hacer push

**¡Eso es todo!** GitHub Actions se encarga del resto automáticamente.

---

## 📥 Paso 1: Configurar tu Nueva Computadora

### 1.1 Instalar Git

Si no lo tienes instalado:

**Windows:**
- Descarga desde: https://git-scm.com/download/win

**Mac:**
```bash
brew install git
```

**Linux:**
```bash
sudo apt install git
```

### 1.2 Configurar Git (Primera vez)

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"
```

### 1.3 Configurar SSH con GitHub (Opcional pero recomendado)

#### Generar una llave SSH:

```bash
ssh-keygen -t ed25519 -C "tu@email.com"
```

Presiona Enter 3 veces (acepta la ubicación por defecto y sin contraseña).

#### Copiar la llave pública:

**Mac/Linux:**
```bash
cat ~/.ssh/id_ed25519.pub
```

**Windows (PowerShell):**
```bash
type $env:USERPROFILE\.ssh\id_ed25519.pub
```

#### Agregar la llave a GitHub:

1. Ve a GitHub → Settings → SSH and GPG keys
2. Click en "New SSH key"
3. Pega la llave que copiaste
4. Click en "Add SSH key"

---

## 📦 Paso 2: Clonar el Proyecto

### Opción A: Con SSH (recomendado si configuraste SSH)

```bash
git clone git@github.com:ChrisOmar43/stockel.git
cd stockel
```

### Opción B: Con HTTPS

```bash
git clone https://github.com/ChrisOmar43/stockel.git
cd stockel
```

---

## 💻 Paso 3: Desarrollo Local (Opcional)

Si quieres probar la aplicación en tu computadora antes de subir cambios:

### 3.1 Instalar Docker Desktop

- **Windows/Mac:** https://www.docker.com/products/docker-desktop
- **Linux:** Sigue las instrucciones de instalación de Docker y Docker Compose

### 3.2 Crear archivo `.env` local

```bash
# En la raíz del proyecto
cp .env.example .env
```

Si no existe `.env.example`, crea el archivo `.env` con:

```env
DATABASE_URL=postgresql://stockel_user:password123@db:5432/stockel_db
POSTGRES_USER=stockel_user
POSTGRES_PASSWORD=password123
POSTGRES_DB=stockel_db
NEXTAUTH_SECRET=local-dev-secret-key-change-this
NEXTAUTH_URL=http://localhost:3000
```

### 3.3 Levantar la aplicación localmente

```bash
docker-compose up -d
```

### 3.4 Ejecutar migraciones

```bash
docker-compose exec app npx prisma migrate dev
```

### 3.5 Ver la aplicación

Abre tu navegador en: http://localhost:3000

---

## 🚀 Paso 4: Flujo de Trabajo Diario

### 4.1 Antes de empezar a trabajar

Siempre obtén los últimos cambios del repositorio:

```bash
git pull origin main
```

### 4.2 Hacer cambios

Edita los archivos que necesites modificar.

### 4.3 Ver qué archivos cambiaron

```bash
git status
```

### 4.4 Agregar archivos al staging

**Agregar todos los archivos modificados:**
```bash
git add .
```

**O agregar archivos específicos:**
```bash
git add src/app/page.tsx
git add src/app/api/auth/login/route.ts
```

### 4.5 Crear un commit

```bash
git commit -m "Descripción clara de los cambios"
```

**Ejemplos de buenos mensajes de commit:**
- ✅ `git commit -m "Agregar botón de logout en el dashboard"`
- ✅ `git commit -m "Corregir error en login cuando el email no existe"`
- ✅ `git commit -m "Actualizar diseño de la página de registro"`

**Ejemplos de malos mensajes:**
- ❌ `git commit -m "cambios"`
- ❌ `git commit -m "fix"`
- ❌ `git commit -m "asdf"`

### 4.6 Subir cambios a GitHub

```bash
git push origin main
```

### 4.7 ✨ Deploy Automático

**¡Eso es todo!** Después de hacer `git push`:

1. GitHub Actions se activa automáticamente
2. Se conecta al VPS
3. Descarga los últimos cambios
4. Reconstruye la aplicación
5. Ejecuta migraciones de base de datos
6. Reinicia la aplicación

**Tiempo total:** ~2-3 minutos

### 4.8 Verificar el deploy

1. **Ve a GitHub:**
   - Abre tu repositorio: https://github.com/ChrisOmar43/stockel
   - Click en la pestaña **Actions**
   - Verás el workflow ejecutándose

2. **Espera el check verde ✅**
   - 🟡 Círculo amarillo = Ejecutándose
   - ✅ Check verde = Deploy exitoso
   - ❌ X roja = Hubo un error

3. **Verifica la aplicación:**
   - Abre: http://72.62.129.32:3000
   - Verifica que tus cambios estén ahí

---

## 📝 Ejemplo Completo del Flujo

Aquí un ejemplo real de cómo trabajar:

```bash
# 1. Obtener últimos cambios
git pull origin main

# 2. Hacer cambios en el código
# (editas archivos en tu editor favorito)

# 3. Ver qué cambió
git status

# 4. Agregar archivos
git add .

# 5. Crear commit
git commit -m "Agregar validación de email en el formulario de registro"

# 6. Subir cambios
git push origin main

# 7. Verificar en GitHub Actions
# (abrir navegador en GitHub → Actions)

# 8. Esperar 2-3 minutos

# 9. Verificar en producción
# (abrir http://72.62.129.32:3000)
```

---

## 🔄 Variaciones del Flujo de Git

### Si quieres hacer múltiples commits antes de subir:

```bash
# Commit 1
git add src/components/Header.tsx
git commit -m "Actualizar header con nuevo logo"

# Commit 2
git add src/app/page.tsx
git commit -m "Cambiar colores del tema principal"

# Subir todos los commits juntos
git push origin main
```

### Si te equivocaste en el mensaje del último commit:

```bash
git commit --amend -m "Mensaje corregido"
git push origin main
```

### Si quieres ver el historial de commits:

```bash
git log --oneline -10
```

---

## ⚠️ Cosas Importantes a Recordar

### ✅ SÍ hacer:

- ✅ Hacer `git pull` antes de empezar a trabajar
- ✅ Escribir mensajes de commit descriptivos
- ✅ Probar localmente antes de hacer push (si tienes Docker)
- ✅ Verificar en GitHub Actions que el deploy fue exitoso
- ✅ Hacer commits pequeños y frecuentes

### ❌ NO hacer:

- ❌ Hacer push directamente sin pull primero (puede causar conflictos)
- ❌ Subir archivos `.env` con credenciales reales
- ❌ Hacer commits muy grandes con muchos cambios
- ❌ Ignorar errores en GitHub Actions
- ❌ Modificar archivos de configuración sin entender qué hacen

---

## 🛠️ Comandos Git Útiles

### Ver diferencias antes de hacer commit:

```bash
git diff
```

### Deshacer cambios NO commiteados:

```bash
# Deshacer cambios en un archivo específico
git checkout -- nombre-archivo.tsx

# Deshacer TODOS los cambios no guardados (¡CUIDADO!)
git reset --hard
```

### Ver el estado del repositorio:

```bash
git status
```

### Ver historial de commits:

```bash
git log --oneline
```

### Crear una rama (para features grandes):

```bash
git checkout -b nombre-de-la-rama
# Hacer cambios
git add .
git commit -m "Descripción"
git push origin nombre-de-la-rama
```

---

## 🆘 Solución de Problemas

### Error: "Your branch is behind 'origin/main'"

```bash
git pull origin main
```

### Error: "merge conflict"

1. Abre los archivos en conflicto
2. Busca las líneas con `<<<<<<<`, `=======`, `>>>>>>>`
3. Decide qué código mantener
4. Elimina los marcadores de conflicto
5. Guarda el archivo
6. Continúa:

```bash
git add .
git commit -m "Resolver conflictos de merge"
git push origin main
```

### Olvidé hacer pull y ahora tengo conflictos

```bash
git stash           # Guarda tus cambios temporalmente
git pull origin main
git stash pop       # Recupera tus cambios
# Resuelve conflictos si hay
git add .
git commit -m "Merge con cambios remotos"
git push origin main
```

### El deploy falló en GitHub Actions

1. Ve a GitHub → Actions
2. Click en el workflow que falló
3. Click en "Deploy to VPS" para ver el error
4. Lee el mensaje de error
5. Corrige el problema en tu código
6. Vuelve a hacer push

---

## 📞 ¿Necesitas Ayuda?

Si tienes problemas:

1. Revisa esta guía
2. Revisa los logs en GitHub Actions
3. Pregunta al equipo en el chat/Slack
4. Crea un issue en GitHub describiendo el problema

---

## 🎓 Recursos para Aprender Más

- [Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)
- [Learn Git Branching](https://learngitbranching.js.org/)
- [GitHub Actions Docs](https://docs.github.com/actions)
- [Docker Tutorial](https://docker-curriculum.com/)

---

**¡Bienvenido al equipo! 🎉**

Recuerda: **Cada push a `main` despliega automáticamente a producción**, así que asegúrate de que tu código funcione antes de subir.

---

**Última actualización:** 2025-12-12
