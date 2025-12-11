# Usa una imagen oficial de Node
FROM node:20-alpine

# Crea la carpeta de la app dentro del contenedor
WORKDIR /app

# Copia package.json y package-lock.json / yarn.lock
COPY package*.json ./

# Instala dependencias
RUN npm install

# Copia todo el proyecto
COPY . .

# Construye la app Next.js
RUN npm run build

# Expone el puerto que usa Next.js
EXPOSE 3000

# Comando para iniciar la app
CMD ["npm", "start"]
