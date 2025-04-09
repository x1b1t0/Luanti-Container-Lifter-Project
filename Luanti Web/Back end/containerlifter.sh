#!/bin/bash

PUERTO_ARCHIVO="/home/scriptluanti/puerto_actual.txt"
VOLUMEN_BASE="/home/scriptluanti/volumenes"

# Asegurar que la carpeta de volúmenes existe
if [ ! -d "$VOLUMEN_BASE" ]; then
    sudo mkdir -p "$VOLUMEN_BASE"
fi
sudo chown -R www-data:www-data "$VOLUMEN_BASE"

# Se crea el archivo de puerto si no existe
if [ ! -f "$PUERTO_ARCHIVO" ]; then
    echo "30000" | sudo tee "$PUERTO_ARCHIVO" > /dev/null
    sudo chown www-data:www-data "$PUERTO_ARCHIVO"
fi

# Función para obtener el próximo puerto disponible
obtener_puerto() {
    local puerto_base=30001

    # Si el archivo está vacío, inicializar con el puerto base
    if [[ ! -s "$PUERTO_ARCHIVO" ]]; then
        echo "$puerto_base" | sudo tee "$PUERTO_ARCHIVO" > /dev/null
        echo "$puerto_base"
        return
    fi

    local puerto_actual
    puerto_actual=$(cat "$PUERTO_ARCHIVO")

    # Validar que el contenido es un número
    if ! [[ "$puerto_actual" =~ ^[0-9]+$ ]]; then
        echo "$puerto_base" | sudo tee "$PUERTO_ARCHIVO" > /dev/null
        echo "$puerto_base"
        return
    fi

    # Incrementar el puerto y actualizar el archivo
    local nuevo_puerto=$((puerto_actual + 1))
    echo "$nuevo_puerto" | sudo tee "$PUERTO_ARCHIVO" > /dev/null
    echo "$nuevo_puerto"
}

# Función para crear la configuración del servidor
crear_configuracion() {
    local nombre_servidor="$1"
    local max_users="$2"
    local creative_mode="$3"
    local enable_damage="$4"
    local config_dir="$VOLUMEN_BASE/$nombre_servidor-config/main-config"

    sudo mkdir -p "$config_dir"

    local config_file="$config_dir/minetest.conf"

    {
        echo "max_users = $max_users"
        echo "creative_mode = $creative_mode"
        echo "enable_damage = $enable_damage"
        echo "server_description = Atlantis Server"
    } | sudo tee "$config_file" > /dev/null

    sudo chown -R www-data:www-data "$config_dir"
}

# Función para crear un servidor
crear_servidor() {
    local nombre_servidor="$1"
    local max_users="$2"
    local creative_mode="$3"
    local enable_damage="$4"

    local puerto_servidor
    puerto_servidor=$(obtener_puerto)

    crear_configuracion "$nombre_servidor" "$max_users" "$creative_mode" "$enable_damage"

    local volumen_dir="$VOLUMEN_BASE/$nombre_servidor-config"

    sudo mkdir -p "$volumen_dir"
    sudo chown -R www-data:www-data "$volumen_dir"

    # Ejecutar el contenedor de Podman
    sudo podman run -d --name="$nombre_servidor" -p "$puerto_servidor:30000/udp" \
        -e CLI_ARGS="--gameid minetest" `#optional` \
        lscr.io/linuxserver/luanti:latest

    if [ $? -ne 0 ]; then
        echo " Error al iniciar el servidor." >&2
        return 1
    fi

    #sleep 3
    #podman exec "$nombre_servidor" mkdir -p /config/.minetest/main-config

    sudo chown -R www-data:www-data "$volumen_dir"

    echo " Servidor '$nombre_servidor' funcionando en puerto $puerto_servidor!"
}

# Llamar a la función con los parámetros pasados desde PHP
crear_servidor "$1" "$2" "$3" "$4"
