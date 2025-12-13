# 🌐 Configurar Dominio cbros.space con HTTPS

Esta guía te ayudará a configurar tu dominio `cbros.space` para que tu aplicación esté disponible en `https://cbros.space` en lugar de `http://72.62.129.32:3000`.

---

## 📋 ¿Qué vamos a hacer?

1. ✅ Configurar DNS para que `cbros.space` apunte a tu VPS
2. ✅ Instalar Nginx como reverse proxy
3. ✅ Obtener certificado SSL gratis con Let's Encrypt
4. ✅ Configurar HTTPS automático
5. ✅ Actualizar la aplicación para usar el nuevo dominio

---

## 🎯 Paso 1: Configurar DNS del Dominio

### 1.1 Acceder al panel de tu proveedor de dominio

Accede al panel donde compraste `cbros.space` (GoDaddy, Namecheap, Cloudflare, etc.)

### 1.2 Agregar registros DNS

Busca la sección de **DNS Management** o **DNS Settings** y agrega estos registros:

| Tipo | Nombre/Host | Valor/Apunta a | TTL |
|------|-------------|----------------|-----|
| A    | @           | 72.62.129.32   | 3600 |
| A    | www         | 72.62.129.32   | 3600 |

**Explicación:**
- `@` = el dominio raíz (`cbros.space`)
- `www` = el subdominio www (`www.cbros.space`)
- `72.62.129.32` = La IP de tu VPS

### 1.3 Guardar cambios

Guarda los cambios. La propagación puede tardar de 5 minutos a 48 horas (normalmente 15-30 minutos).

### 1.4 Verificar DNS

Desde tu terminal local, ejecuta:

```bash
nslookup cbros.space
```

**Resultado esperado:**
```
Server:  8.8.8.8
Address: 8.8.8.8#53

Non-authoritative answer:
Name:    cbros.space
Address: 72.62.129.32
```

Si ves `72.62.129.32`, ¡perfecto! El DNS está configurado. Si no, espera unos minutos más.

---

## 🖥️ Paso 2: Configurar el VPS

### 2.1 Conectarse al VPS

```bash
ssh root@72.62.129.32
```

### 2.2 Ir al directorio del proyecto

```bash
cd /root/stockel
```

### 2.3 Descargar el script de configuración

```bash
git pull origin main
```

Esto descargará el script `setup-domain-ssl.sh`.

### 2.4 Editar el script con tu email

```bash
nano setup-domain-ssl.sh
```

Cambia esta línea:
```bash
EMAIL="tu@email.com"  # Cambiar por tu email real
```

Por tu email real (se usará para notificaciones de Let's Encrypt):
```bash
EMAIL="carlos@ejemplo.com"
```

Guarda con `Ctrl+X`, luego `Y`, luego `Enter`.

### 2.5 Dar permisos de ejecución

```bash
chmod +x setup-domain-ssl.sh
```

### 2.6 Ejecutar el script

```bash
./setup-domain-ssl.sh
```

El script:
1. Instalará Nginx
2. Instalará Certbot (para SSL)
3. Configurará Nginx como reverse proxy
4. Obtendrá certificado SSL gratis
5. Configurará renovación automática

**⏱️ Esto tomará unos 2-3 minutos.**

### 2.7 Cuando pregunte si el DNS está listo

El script preguntará:
```
¿El DNS ya apunta a este servidor? (y/n):
```

- Si ya verificaste que `nslookup cbros.space` muestra `72.62.129.32`, escribe `y` y presiona Enter
- Si no, escribe `n`, configura el DNS primero, y ejecuta el script de nuevo

---

## 🔧 Paso 3: Actualizar Variables de Entorno

### 3.1 Editar el archivo .env

```bash
cd /root/stockel
nano .env
```

### 3.2 Cambiar NEXTAUTH_URL

Busca esta línea:
```env
NEXTAUTH_URL=http://72.62.129.32:3000
```

Cámbiala por:
```env
NEXTAUTH_URL=https://cbros.space
```

Guarda con `Ctrl+X`, luego `Y`, luego `Enter`.

### 3.3 Reiniciar los contenedores

```bash
docker compose restart
```

---

## ✅ Paso 4: Verificar que Todo Funciona

### 4.1 Abrir en el navegador

Abre tu navegador y ve a:
- **https://cbros.space**

Deberías ver:
- ✅ Tu aplicación Stockël funcionando
- ✅ El candado verde de HTTPS
- ✅ URL limpia sin puerto

### 4.2 Verificar certificado SSL

1. Click en el candado verde en la barra de direcciones
2. Verás "Conexión segura"
3. El certificado es válido por Let's Encrypt

### 4.3 Probar redirecciones

El sistema debe redirigir automáticamente:
- `http://cbros.space` → `https://cbros.space`
- `http://www.cbros.space` → `https://cbros.space`
- `https://www.cbros.space` → `https://cbros.space`

---

## 🔄 Paso 5: Actualizar Configuración en el Código

Ahora necesitas actualizar tu código local para usar el nuevo dominio.

### 5.1 En tu computadora local

```bash
cd /ruta/a/stockel
```

### 5.2 Editar docker-compose.yml (para desarrollo local)

Si tienes un archivo `docker-compose.yml` para desarrollo, no necesitas cambiarlo. Solo es para local.

### 5.3 Actualizar documentación

Actualiza los archivos de documentación para reflejar el nuevo dominio:

**README.md:**
```markdown
**URL de Producción:** https://cbros.space
```

**RESUMEN_CONFIGURACION.md:**
Cambia todas las referencias de `http://72.62.129.32:3000` a `https://cbros.space`

### 5.4 Hacer commit y push

```bash
git add .
git commit -m "Actualizar dominio a cbros.space con HTTPS"
git push origin main
```

El deploy automático actualizará el VPS (pero Nginx ya estará configurado, así que no afecta).

---

## 🎨 Paso 6: Actualizar la Aplicación (Opcional)

Si quieres actualizar el mensaje en el footer de la app:

**src/app/page.tsx:**

Cambia:
```tsx
<p className="mt-2 text-blue-100">Deploy automático con GitHub Actions funcionando ✅</p>
```

Por:
```tsx
<p className="mt-2 text-blue-100">Seguro con HTTPS 🔒 | Deploy automático ✅</p>
```

Luego:
```bash
git add .
git commit -m "Actualizar mensaje de footer con HTTPS"
git push origin main
```

---

## 🔐 Renovación Automática del Certificado SSL

El certificado SSL se renovará **automáticamente** cada 90 días gracias a Certbot.

### Verificar renovación automática

En el VPS, ejecuta:

```bash
systemctl status certbot.timer
```

Debería mostrar `active (running)`.

### Renovar manualmente (si es necesario)

```bash
certbot renew --dry-run
```

---

## 🚀 Actualizar el Workflow de GitHub Actions

Para que los deploys futuros funcionen correctamente con el dominio, NO necesitas cambiar nada en el workflow. GitHub Actions seguirá funcionando igual porque:

1. Se conecta por SSH a la IP (no al dominio)
2. Reconstruye los contenedores
3. Nginx sigue redirigiendo el tráfico

Todo sigue funcionando automáticamente. ✅

---

## 🛠️ Comandos Útiles

### Ver logs de Nginx

```bash
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log
```

### Ver estado de Nginx

```bash
systemctl status nginx
```

### Reiniciar Nginx

```bash
systemctl restart nginx
```

### Ver certificados instalados

```bash
certbot certificates
```

### Renovar certificado manualmente

```bash
certbot renew
```

### Verificar configuración de Nginx

```bash
nginx -t
```

---

## 🐛 Solución de Problemas

### Error: "Connection refused"

**Causa:** Nginx no está corriendo o hay un problema de configuración.

**Solución:**
```bash
systemctl status nginx
systemctl restart nginx
nginx -t
```

### Error: "SSL certificate problem"

**Causa:** El certificado no se instaló correctamente.

**Solución:**
```bash
certbot --nginx -d cbros.space -d www.cbros.space
```

### Error: "502 Bad Gateway"

**Causa:** La aplicación en el puerto 3000 no está corriendo.

**Solución:**
```bash
cd /root/stockel
docker compose ps
docker compose logs app
docker compose restart
```

### El dominio no resuelve

**Causa:** El DNS no ha propagado aún.

**Solución:**
1. Espera 15-30 minutos más
2. Verifica con `nslookup cbros.space`
3. Verifica en https://dnschecker.org/#A/cbros.space

### Error: "Too many requests" al obtener SSL

**Causa:** Intentaste obtener el certificado muchas veces.

**Solución:**
Let's Encrypt tiene límites de rate. Espera 1 hora antes de volver a intentar.

---

## 📊 Resumen Final

Después de completar esta guía, tendrás:

✅ Dominio `cbros.space` apuntando a tu VPS
✅ Nginx configurado como reverse proxy
✅ Certificado SSL válido y gratuito
✅ HTTPS funcionando automáticamente
✅ Redirección automática de HTTP a HTTPS
✅ Renovación automática del certificado cada 90 días
✅ Deploy automático funcionando con el nuevo dominio

---

## 🎯 URLs Finales

Antes:
- ❌ http://72.62.129.32:3000

Después:
- ✅ https://cbros.space
- ✅ https://www.cbros.space
- ✅ http://cbros.space (redirige a HTTPS)
- ✅ http://www.cbros.space (redirige a HTTPS)

---

## 📝 Checklist de Verificación

- [ ] DNS configurado (nslookup muestra 72.62.129.32)
- [ ] Script setup-domain-ssl.sh ejecutado exitosamente
- [ ] Nginx corriendo (`systemctl status nginx`)
- [ ] Certificado SSL instalado (`certbot certificates`)
- [ ] .env actualizado con NEXTAUTH_URL=https://cbros.space
- [ ] Contenedores reiniciados
- [ ] https://cbros.space funciona
- [ ] Candado verde visible en el navegador
- [ ] Documentación actualizada
- [ ] Deploy automático sigue funcionando

---

**¡Felicidades! 🎉 Tu aplicación ahora tiene un dominio profesional con HTTPS.**

---

**Última actualización:** 2025-12-12
