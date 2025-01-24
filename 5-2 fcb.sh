#!/bin/bash

# Instalación de Podman
echo "Instalando Podman..."
sudo apt update
sudo apt install -y podman

# Descargar la última versión de Minetest
echo "Descargando la última versión de Minetest..."
podman pull linuxserver/minetest

# Limpiar la pantalla después de la descarga
clear

# Solicitar al usuario parámetros para configurar el servidor
echo "Configuración del servidor de Minetest"

# Nombre del servidor
read -p "Ingresa el nombre del servidor: " SERVER_NAME

# Puerto del servidor
read -p "Ingresa el puerto del servidor (default 30000): " SERVER_PORT
SERVER_PORT=${SERVER_PORT:-30000}

# Número máximo de jugadores
read -p "Ingresa el número máximo de jugadores (default 10): " MAX_PLAYERS
MAX_PLAYERS=${MAX_PLAYERS:-10}

# Otras configuraciones que puedas necesitar
read -p "Ingresa la descripción del servidor (opcional): " SERVER_DESC

# Ruta donde se encuentra la configuración en el contenedor
CONFIG_PATH="/config/.minetest/main-config/minetest.conf"

# Crear archivo minetest.conf con los parámetros proporcionados
echo "Creando archivo de configuración..."

# Crear el directorio de configuración
mkdir -p "$(pwd)/config/.minetest/main-config"

# Crear el archivo minetest.conf con los parámetros dados
cat <<EOL > "$(pwd)/config/.minetest/main-config/minetest.conf"
# Archivo de configuración de Minetest
name = "$SERVER_NAME"
server_announce = true
server_description = "$SERVER_DESC"
server_address = "0.0.0.0"
server_port = "$SERVER_PORT"
max_users = "$MAX_PLAYERS"
EOL

# Limpiar la pantalla para que esté limpia antes de iniciar el servidor
clear

# Ejecutar el contenedor de Minetest con los parámetros de configuración
echo "Iniciando el servidor de Minetest..."

# Ejecutar el contenedor de Minetest con Podman
podman run -d \
  -v "$(pwd)/config/.minetest/main-config:/config/.minetest/main-config" \
  -p "$SERVER_PORT:$SERVER_PORT" \
  --name minetest_server \
  linuxserver/minetest

# Mostrar mensaje indicando que el servidor se ha iniciado
echo "Servidor de Minetest iniciado con éxito en el puerto $SERVER_PORT."
echo "¡Disfruta de tu servidor de Minetest!"
