# 📝 Ejemplos de Comandos Git - Flujo de Trabajo

Este archivo contiene ejemplos prácticos de cómo usar Git en el día a día.

---

## 🚀 Flujo Básico (Lo que usarás el 90% del tiempo)

### 1️⃣ Obtener últimos cambios del repositorio

```bash
git pull origin main
```

### 2️⃣ Hacer cambios en tu código

Edita los archivos que necesites con tu editor favorito (VS Code, WebStorm, etc.)

### 3️⃣ Ver qué archivos modificaste

```bash
git status
```

**Salida esperada:**
```
On branch main
Changes not staged for commit:
  modified:   src/app/page.tsx
  modified:   src/components/Header.tsx
```

### 4️⃣ Agregar archivos al staging (preparar para commit)

**Opción A: Agregar TODOS los archivos modificados**
```bash
git add .
```

**Opción B: Agregar archivos específicos**
```bash
git add src/app/page.tsx
git add src/components/Header.tsx
```

### 5️⃣ Crear un commit con un mensaje descriptivo

```bash
git commit -m "Descripción clara de lo que cambiaste"
```

**Ejemplos reales:**

```bash
# ✅ BUENOS mensajes de commit
git commit -m "Agregar botón de logout en el header"
git commit -m "Corregir error de validación en formulario de login"
git commit -m "Actualizar colores del tema principal"
git commit -m "Implementar función de búsqueda en inventario"
git commit -m "Optimizar consultas de base de datos en dashboard"

# ❌ MALOS mensajes de commit
git commit -m "cambios"
git commit -m "fix"
git commit -m "update"
git commit -m "asdf"
```

### 6️⃣ Subir los cambios a GitHub

```bash
git push origin main
```

**Salida esperada:**
```
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Delta compression using up to 16 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 456 bytes | 456.00 KiB/s, done.
Total 3 (delta 2), reused 0 (delta 0)
To github.com:ChrisOmar43/stockel.git
   87c0153..cd4450b  main -> main
```

### 7️⃣ ✨ ¡Listo! El deploy se hace automáticamente

Después del push:
- Ve a GitHub → Actions
- Espera 2-3 minutos
- Verifica en http://72.62.129.32:3000

---

## 📚 Ejemplos Completos por Escenario

### 📝 Escenario 1: Modificar una página existente

```bash
# 1. Obtener últimos cambios
git pull origin main

# 2. Editar archivo (ejemplo: src/app/page.tsx)
# ... haces cambios en tu editor ...

# 3. Ver qué cambió
git status

# 4. Agregar el archivo
git add src/app/page.tsx

# 5. O agregar todos los cambios
git add .

# 6. Hacer commit
git commit -m "Actualizar diseño de la página principal"

# 7. Subir a GitHub
git push origin main
```

---

### 🆕 Escenario 2: Crear un nuevo componente

```bash
# 1. Obtener últimos cambios
git pull origin main

# 2. Crear nuevo archivo (ejemplo: src/components/Button.tsx)
# ... creas y editas el archivo ...

# 3. Ver archivos nuevos
git status

# 4. Agregar el nuevo archivo
git add src/components/Button.tsx

# 5. Hacer commit
git commit -m "Crear componente Button reutilizable"

# 6. Subir a GitHub
git push origin main
```

---

### 🐛 Escenario 3: Corregir un bug

```bash
# 1. Obtener últimos cambios
git pull origin main

# 2. Identificar y corregir el bug
# ... haces los cambios necesarios ...

# 3. Ver archivos modificados
git status

# 4. Agregar archivos corregidos
git add .

# 5. Hacer commit explicando el bug
git commit -m "Corregir error que impedía el login con espacios en el email"

# 6. Subir a GitHub
git push origin main
```

---

### 🎨 Escenario 4: Actualizar múltiples archivos relacionados

```bash
# 1. Obtener últimos cambios
git pull origin main

# 2. Modificar varios archivos relacionados
# Por ejemplo: header, footer, y estilos globales
# ... haces todos los cambios ...

# 3. Ver todos los cambios
git status

# Salida:
# modified:   src/components/Header.tsx
# modified:   src/components/Footer.tsx
# modified:   src/app/globals.css

# 4. Agregar todos los archivos
git add .

# 5. Hacer commit describiendo el cambio general
git commit -m "Rediseñar header y footer con nuevo branding"

# 6. Subir a GitHub
git push origin main
```

---

### 🔄 Escenario 5: Hacer varios commits pequeños antes de subir

```bash
# 1. Obtener últimos cambios
git pull origin main

# 2. Primer cambio: Actualizar header
# ... editas Header.tsx ...
git add src/components/Header.tsx
git commit -m "Actualizar logo en el header"

# 3. Segundo cambio: Actualizar footer
# ... editas Footer.tsx ...
git add src/components/Footer.tsx
git commit -m "Agregar enlaces de redes sociales en footer"

# 4. Tercer cambio: Actualizar página principal
# ... editas page.tsx ...
git add src/app/page.tsx
git commit -m "Mejorar descripción en página principal"

# 5. Subir TODOS los commits juntos
git push origin main
```

---

### 📋 Escenario 6: Agregar una nueva funcionalidad completa

```bash
# 1. Obtener últimos cambios
git pull origin main

# 2. Implementar la funcionalidad
# Por ejemplo: sistema de notificaciones
# ... creas varios archivos y modificas otros ...

# 3. Ver todos los cambios
git status

# Salida:
# new file:   src/components/Notification.tsx
# new file:   src/hooks/useNotifications.ts
# new file:   src/lib/notifications.ts
# modified:   src/app/layout.tsx
# modified:   src/components/Header.tsx

# 4. Agregar todos los archivos
git add .

# 5. Hacer commit descriptivo
git commit -m "Implementar sistema de notificaciones en tiempo real"

# 6. Subir a GitHub
git push origin main
```

---

## ⚡ Comandos de Un Solo Paso

### Agregar todos los cambios y hacer commit en un comando

```bash
git commit -am "Mensaje del commit"
```

**Nota:** Esto solo funciona con archivos que ya existen (no con archivos nuevos).

**Ejemplo:**
```bash
# Si solo modificaste archivos existentes
git commit -am "Actualizar estilos del dashboard"
git push origin main
```

---

## 🔍 Comandos Útiles para Revisar

### Ver diferencias antes de hacer commit

```bash
git diff
```

### Ver diferencias de un archivo específico

```bash
git diff src/app/page.tsx
```

### Ver historial de commits

```bash
git log --oneline
```

**Salida:**
```
cd4450b login_funcional
87c0153 Arreglo de prisma
e66175f loguin push prueba 1.0
```

### Ver historial con más detalle

```bash
git log --oneline -10
```

Esto muestra los últimos 10 commits.

### Ver quién modificó cada línea de un archivo

```bash
git blame src/app/page.tsx
```

---

## 🛠️ Comandos para Corregir Errores

### Deshacer cambios NO guardados en un archivo

```bash
git checkout -- nombre-del-archivo.tsx
```

**Ejemplo:**
```bash
git checkout -- src/app/page.tsx
```

### Deshacer TODOS los cambios no guardados

```bash
git reset --hard
```

**⚠️ CUIDADO:** Esto elimina TODOS tus cambios no guardados. No se puede deshacer.

### Cambiar el mensaje del último commit

```bash
git commit --amend -m "Nuevo mensaje corregido"
```

**Ejemplo:**
```bash
# Hiciste un commit con un mensaje malo
git commit -m "fix bug"

# Lo corriges
git commit --amend -m "Corregir validación de email en formulario de registro"

# Luego subes
git push origin main
```

### Eliminar el último commit (pero mantener los cambios)

```bash
git reset --soft HEAD~1
```

### Ver el estado actual del repositorio

```bash
git status
```

---

## 🌿 Trabajar con Ramas (Avanzado)

### Crear una nueva rama para una feature grande

```bash
git checkout -b feature/nueva-funcionalidad
```

### Hacer cambios en la rama

```bash
# ... haces cambios ...
git add .
git commit -m "Implementar nueva funcionalidad"
```

### Subir la rama a GitHub

```bash
git push origin feature/nueva-funcionalidad
```

### Volver a la rama main

```bash
git checkout main
```

### Fusionar la rama con main

```bash
git checkout main
git merge feature/nueva-funcionalidad
git push origin main
```

---

## 📊 Resumen de Comandos Más Usados

| Comando | Descripción |
|---------|-------------|
| `git pull origin main` | Obtener últimos cambios |
| `git status` | Ver archivos modificados |
| `git add .` | Agregar todos los archivos |
| `git add archivo.tsx` | Agregar un archivo específico |
| `git commit -m "mensaje"` | Crear commit |
| `git push origin main` | Subir cambios a GitHub |
| `git log --oneline` | Ver historial |
| `git diff` | Ver diferencias |
| `git checkout -- archivo` | Deshacer cambios en un archivo |

---

## ✨ Ejemplo Real del Día a Día

```bash
# Lunes por la mañana - Empiezas a trabajar
git pull origin main

# Trabajas en agregar una nueva página
# ... creas src/app/productos/page.tsx ...
# ... modificas src/components/Header.tsx para agregar el link ...

# Revisas qué cambiaste
git status

# Agregas todo
git add .

# Haces commit
git commit -m "Agregar página de productos y link en navegación"

# Subes a GitHub
git push origin main

# ✅ Deploy automático se ejecuta
# Esperas 2-3 minutos
# Verificas en http://72.62.129.32:3000

# ¡Listo! Tu cambio está en producción
```

---

## 🎓 Consejos Importantes

1. **Siempre haz `git pull` antes de empezar a trabajar**
2. **Haz commits frecuentes y pequeños**
3. **Escribe mensajes de commit claros**
4. **Revisa `git status` antes de hacer commit**
5. **Verifica en GitHub Actions que el deploy fue exitoso**

---

## 🆘 ¿Algo salió mal?

Si cometiste un error o algo no funciona:

1. No entres en pánico
2. Lee el mensaje de error
3. Busca el error en Google
4. Pregunta al equipo
5. Si es necesario, revierte con `git reset` o `git revert`

---

**¡Ahora ya sabes todo lo necesario para trabajar con Git en Stockël! 🎉**

---

**Última actualización:** 2025-12-12
