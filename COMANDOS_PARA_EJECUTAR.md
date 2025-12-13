# Comandos para configurar HTTPS en cbros.space

Ejecuta estos comandos **EN ORDEN** en tu VPS:

## 1. Detener contenedores actuales

```bash
cd /root/stockel
docker compose down
```

## 2. Actualizar el código desde GitHub

```bash
git pull origin main
```

## 3. Editar el script de SSL con tu email

```bash
nano init-letsencrypt.sh
```

Busca esta línea:
```
email="tu-email@ejemplo.com"
```

Cámbiala por tu email real, por ejemplo:
```
email="carlos@cbros.space"
```

Guarda con `Ctrl + O`, luego `Enter`, y sal con `Ctrl + X`

## 4. Dar permisos de ejecución al script

```bash
chmod +x init-letsencrypt.sh
```

## 5. Ejecutar el script para obtener certificados SSL

```bash
./init-letsencrypt.sh
```

Este script va a:
- Crear certificados temporales
- Iniciar Nginx
- Obtener certificados reales de Let's Encrypt para cbros.space
- Recargar Nginx

## 6. Verificar que todo esté corriendo

```bash
docker compose ps
```

Deberías ver 4 contenedores corriendo:
- stockel_nginx
- stockel_certbot
- stockel_app
- stockel_db

## 7. Ver logs si hay algún problema

```bash
# Ver logs de Nginx
docker compose logs nginx

# Ver logs de la app
docker compose logs app

# Ver todos los logs
docker compose logs -f
```

## 8. Probar tu sitio

Abre en tu navegador:
- https://cbros.space

Deberías ver tu aplicación con el candado de seguridad (HTTPS)

## Si algo sale mal

### Error: "Existing data found for cbros.space"
Si el script pregunta si quieres reemplazar los certificados, escribe `y` y presiona Enter.

### Error al obtener certificados
Verifica que tu dominio apunte correctamente:
```bash
ping cbros.space
```

Debe responder con: `72.62.129.32`

### Reiniciar todo desde cero
```bash
docker compose down
rm -rf certbot/
./init-letsencrypt.sh
```
