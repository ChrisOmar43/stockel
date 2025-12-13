# Configuración de Dominio y SSL para cbros.space

Esta guía te ayudará a configurar tu dominio `cbros.space` con HTTPS en tu VPS de Hostinger.

## Paso 1: Configurar DNS en Hostinger

Primero debes configurar los registros DNS de tu dominio en Hostinger:

1. Inicia sesión en tu panel de Hostinger
2. Ve a **Dominios** → Selecciona `cbros.space`
3. Haz clic en **DNS / Name Servers**
4. Agrega/modifica los siguientes registros:

```
Tipo: A
Nombre: @ (o déjalo vacío)
Apunta a: 72.62.129.32
TTL: 3600 (o el predeterminado)

Tipo: A
Nombre: www
Apunta a: 72.62.129.32
TTL: 3600 (o el predeterminado)
```

**IMPORTANTE**: La propagación DNS puede tardar entre 15 minutos y 48 horas. Puedes verificar la propagación en https://dnschecker.org

## Paso 2: Verificar que el dominio apunte correctamente

Antes de continuar, verifica que tu dominio apunte a tu VPS:

```bash
ping cbros.space
```

Deberías ver que responde con la IP `72.62.129.32`

## Paso 3: Preparar el script de SSL

1. Edita el archivo `init-letsencrypt.sh` y cambia el email:

```bash
nano init-letsencrypt.sh
```

Busca la línea:
```bash
email="tu-email@ejemplo.com" # CAMBIA ESTO POR TU EMAIL
```

Y cámbiala por tu email real:
```bash
email="tuemailreal@gmail.com"
```

2. Dale permisos de ejecución al script:

```bash
chmod +x init-letsencrypt.sh
```

## Paso 4: Detener servicios actuales

Si tienes contenedores corriendo, deténlos:

```bash
cd /root/stockel
docker compose down
```

## Paso 5: Ejecutar el script de inicialización de SSL

Este script creará certificados SSL de Let's Encrypt:

```bash
./init-letsencrypt.sh
```

El script hará lo siguiente:
1. Descargar parámetros de seguridad TLS
2. Crear un certificado temporal
3. Iniciar Nginx
4. Solicitar el certificado real de Let's Encrypt
5. Recargar Nginx con el certificado real

## Paso 6: Verificar que todo funcione

Una vez completado el script, tu sitio debería estar disponible en:
- https://cbros.space (con HTTPS)
- https://www.cbros.space (con HTTPS)
- http://cbros.space (redirigirá automáticamente a HTTPS)

## Renovación automática de certificados

Los certificados de Let's Encrypt expiran cada 90 días, pero no te preocupes:
- El contenedor `certbot` renovará automáticamente los certificados cada 12 horas
- Nginx se recargará automáticamente cada 6 horas para aplicar nuevos certificados

## Solución de problemas

### El dominio no apunta a mi VPS
- Verifica que los registros DNS estén correctos en Hostinger
- Espera más tiempo para la propagación DNS
- Usa `dig cbros.space` para ver a dónde apunta actualmente

### Error al obtener certificados SSL
- Asegúrate de que el dominio apunte correctamente a tu VPS ANTES de ejecutar el script
- Verifica que los puertos 80 y 443 estén abiertos en tu firewall
- Si estás probando, cambia `staging=0` a `staging=1` en el script para evitar límites de rate

### El sitio no carga
```bash
# Ver logs de nginx
docker compose logs nginx

# Ver logs de la aplicación
docker compose logs app

# Verificar que todos los contenedores estén corriendo
docker compose ps
```

### Reiniciar todo
```bash
docker compose down
docker compose up -d
```

## Comandos útiles

```bash
# Ver estado de los contenedores
docker compose ps

# Ver logs en tiempo real
docker compose logs -f

# Reiniciar Nginx
docker compose restart nginx

# Renovar certificados manualmente
docker compose run --rm certbot renew

# Verificar configuración de Nginx
docker compose exec nginx nginx -t
```

## Actualización del flujo de deployment

Tu GitHub Action ahora desplegará automáticamente con la configuración de Nginx y SSL.
No necesitas hacer cambios adicionales en el workflow.
