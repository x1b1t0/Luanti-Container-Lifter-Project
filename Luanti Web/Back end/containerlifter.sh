#!/bin/bash

PUERTO_ARCHIVO="/home/scriptluanti/puerto_actual.txt"
VOLUMEN_BASE="/home/scriptluanti/volumenes"

# Asegurar que la carpeta de volúmenes existe y cambiar propietario
if [ ! -d "$VOLUMEN_BASE" ]; then
    sudo mkdir -p "$VOLUMEN_BASE"
fi
sudo chown -R www-data:www-data "$VOLUMEN_BASE"

# Se crea el archivo de puerto si no existe y se le asignan permisos
if [ ! -f "$PUERTO_ARCHIVO" ]; then
    sudo touch "$PUERTO_ARCHIVO"
    sudo chown www-data:www-data "$PUERTO_ARCHIVO"
fi

# Función para obtener el puerto
obtener_puerto() {
    local puerto_base=30001
    local puerto_actual=$(cat "$PUERTO_ARCHIVO" 2>/dev/null || echo "$puerto_base")
    echo $((puerto_actual + 1)) | sudo tee "$PUERTO_ARCHIVO" > /dev/null
    printf "%d" "$((puerto_actual + 1))"
}

# Función para crear el archivo de configuración del servidor
crear_configuracion() {
    local nombre_servidor="$1"
    local max_users="$2"
    local config_dir="$VOLUMEN_BASE/$nombre_servidor-config/main-config"

    sudo mkdir -p "$config_dir"

    local config_file="$config_dir/minetest.conf"

    {
        echo "max_users = $max_users"
        echo "creative_mode = true"
        echo "enable_damage = false"
        echo "server_description = Atlantis Server"
    } | sudo tee "$config_file" > /dev/null

    sudo chown -R www-data:www-data "$config_dir"
}

# Función para crear un servidor
crear_servidor() {
    local nombre_servidor="$1"
    local max_users="$2"

    local puerto_servidor
    puerto_servidor=$(obtener_puerto)

    crear_configuracion "$nombre_servidor" "$max_users"

    local volumen_dir="$VOLUMEN_BASE/$nombre_servidor-config"

    sudo mkdir -p "$volumen_dir"
    sudo chown -R www-data:www-data "$volumen_dir"

    podman run -d --name="$nombre_servidor" -p "$puerto_servidor:30000/udp" \
        -e LUANTI_WORLDNAME="$nombre_servidor" \
        -v "$volumen_dir:/config/.minetest" \
        docker.io/linuxserver/luanti:latest

    if [ $? -ne 0 ]; then
        echo "❌ Error al iniciar el servidor." >&2
        return 1
    fi

    sleep 3
    podman exec "$nombre_servidor" mkdir -p /config/.minetest/main-config

    sudo chown -R www-data:www-data "$volumen_dir"

    echo "✅ Servidor '$nombre_servidor' funcionando en puerto $puerto_servidor!"
}

crear_servidor "$1" "$2"




