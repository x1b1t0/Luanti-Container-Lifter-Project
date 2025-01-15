#!/bin/bash
# Instalar Podman
echo "Actualizando los repositorios y Instalando Podman..."
sudo apt update
sudo apt install -y podman

# Descargar la última imagen de Minetest
echo "Descargando la última versión de Minetest..."
podman pull lscr.io/linuxserver/minetest:latest

# Limipar la pantalla para dejar claro la información que se solicita más tarde
clear

# Solicitar parámetros al usuario
read -p "Introduce el puerto del servidor (por defecto 30000): " PORT
PORT=${PORT:-30000}  # Valor por defecto

read -p "Introduce el número máximo de jugadores (por defecto 20): " MAX_PLAYERS
MAX_PLAYERS=${MAX_PLAYERS:-20}  # Valor por defecto

read -p "¿Quieres establecer una contraseña para el servidor? (s/n): " SET_PASSWORD
if [[ "$SET_PASSWORD" == "s" ]]; then
  read -p "Introduce la contraseña: " PASSWORD
else
  PASSWORD=""
fi

# Crear un directorio para los datos de Minetest
DATA_DIR="$HOME/minetest_data"
mkdir -p "$DATA_DIR"

# Verificar si el directorio se creó correctamente
if [[ ! -d "$DATA_DIR" ]]; then
  echo "Error al crear el directorio para los datos de Minetest."
  exit 1
fi

# Ejecutar el contenedor de Minetest
echo "Ejecutando el contenedor de Minetest..."
podman run -d \
  --name minetest_server \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p "$PORT:30000/udp" \
  -v "$DATA_DIR:/config/.minetest" \
  --restart unless-stopped \
  lscr.io/linuxserver/minetest:latest \
  --max_players="$MAX_PLAYERS" \
  ${PASSWORD:+--password="$PASSWORD"}

# Verificar si el contenedor se ha iniciado correctamente
if [[ $? -ne 0 ]]; then
  echo "Error al ejecutar el contenedor de Minetest."
  exit 1
fi

# Mensaje de finalización
echo "El servidor de Minetest se está ejecutando en el puerto $PORT con un máximo de $MAX_PLAYERS jugadores."

if [[ -n "$PASSWORD" ]]; then
  echo "La contraseña del servidor es: $PASSWORD"
else
  echo "El servidor no tiene contraseña."
fi
