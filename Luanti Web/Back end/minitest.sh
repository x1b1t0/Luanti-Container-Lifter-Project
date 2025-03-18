#!/bin/bash

PUERTO_ARCHIVO="/home/scriptluanti/puerto_actual.txt"
VOLUMEN_BASE="/home/scriptluanti/volumenes"
LOG_FILE="/var/log/containerlifter.log"

log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | sudo tee -a "$LOG_FILE" > /dev/null
}

# Verificar parámetros
if [ $# -ne 4 ]; then
    log "❌ Error: Uso incorrecto del script."
    echo "Uso: $0 <server_name> <max_users> <creative_mode> <enable_damage>"
    exit 1
fi

server_name="$1"
max_users="$2"
creative_mode="$3"
enable_damage="$4"

log "Creando servidor '$server_name' con $max_users usuarios..."

# Asegurar directorios y permisos
sudo mkdir -p "$VOLUMEN_BASE"
sudo chown -R www-data:www-data "$VOLUMEN_BASE"

if [ ! -f "$PUERTO_ARCHIVO" ]; then
    echo 30000 | sudo tee "$PUERTO_ARCHIVO" > /dev/null
    sudo chown www-data:www-data "$PUERTO_ARCHIVO"
fi

# Función para obtener un nuevo puerto
obtener_puerto() {
    local puerto_actual
    puerto_actual=$(cat "$PUERTO_ARCHIVO")
    nuevo_puerto=$((puerto_actual + 1))
    echo "$nuevo_puerto" | sudo tee "$PUERTO_ARCHIVO" > /dev/null
    echo "$nuevo_puerto"
}

puerto_servidor=$(obtener_puerto)

# Crear directorios de configuración
config_dir="$VOLUMEN_BASE/$server_name-config/main-config"
sudo mkdir -p "$config_dir"

# Crear archivo de configuración
config_file="$config_dir/minetest.conf"
{
    echo "max_users = $max_users"
    echo "creative_mode = $creative_mode"
    echo "enable_damage = $enable_damage"
    echo "server_description = Atlantis Server"
} | sudo tee "$config_file" > /dev/null

sudo chown -R www-data:www-data "$config_dir"

# Iniciar contenedor
log "Iniciando contenedor '$server_name' en puerto $puerto_servidor..."
podman run -d --name="$server_name" -p "$puerto_servidor:30000/udp" \
    -e LUANTI_WORLDNAME="$server_name" \
    -v "$VOLUMEN_BASE/$server_name-config:/config/.minetest" \
    docker.io/linuxserver/luanti:latest

if [ $? -ne 0 ]; then
    log "❌ Error al iniciar el servidor '$server_name'."
    exit 1
fi

sleep 3
podman exec "$server_name" mkdir -p /config/.minetest/main-config
sudo chown -R www-data:www-data "$VOLUMEN_BASE/$server_name-config"

log "✅ Servidor '$server_name' funcionando en puerto $puerto_servidor!"
echo "Servidor '$server_name' iniciado con éxito en puerto $puerto_servidor."
