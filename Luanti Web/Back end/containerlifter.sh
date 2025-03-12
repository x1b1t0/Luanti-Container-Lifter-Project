#!/bin/bash

# Archivo para registrar el último puerto usado
PUERTO_ARCHIVO="puerto_actual.txt"

# Función para mostrar el título "ATLANTIS"
mostrar_titulo() {
    printf "\n         🚀 A T L A N T I S 🚀         \n\n"
}

# Función para obtener un puerto único
obtener_puerto() {
    local puerto_base=30001
    local puerto_actual=$(cat "$PUERTO_ARCHIVO" 2>/dev/null || echo "$puerto_base")
    echo $((puerto_actual + 1)) > "$PUERTO_ARCHIVO"
    printf "%d" "$((puerto_actual + 1))"
}

# Función para crear el archivo de configuración del servidor
crear_configuracion() {
    local nombre_servidor="$1"
    local max_users="$2"
    
    mkdir -p "$(pwd)/volumenes/$nombre_servidor-config/main-config/"
    local config_file="$(pwd)/volumenes/$nombre_servidor-config/main-config/minetest.conf"

    printf "max_users = %s\n" "$max_users" > "$config_file"
    printf "creative_mode = true\n" >> "$config_file"
    printf "enable_damage = false\n" >> "$config_file"
    printf "server_description = Atlantis Server\n" >> "$config_file"
    printf "noclip = true\n" >> "$config_file"

    printf "✅ Configuración creada en %s\n" "$config_file"
}

# Función para crear un servidor
crear_servidor() {
    local nombre_servidor="$1"
    local max_users="$2"
    
    mostrar_titulo
    local puerto_servidor
    puerto_servidor=$(obtener_puerto)

    printf "🔧 Configurando servidor...\n"
    crear_configuracion "$nombre_servidor" "$max_users"

    printf "🚀 Iniciando servidor '%s' en puerto %d...\n" "$nombre_servidor" "$puerto_servidor"
    mkdir -p "./$nombre_servidor-config"

    podman run -d --name="$nombre_servidor" -p "$puerto_servidor:30000/udp" \
        -e MINETEST_WORLDNAME="$nombre_servidor" \
        -v "$(pwd)/volumenes/$nombre_servidor-config:/config/.minetest" \
        docker.io/linuxserver/luanti:latest

    if [ $? -ne 0 ]; then
        printf "❌ Error al iniciar el servidor.\n" >&2
        return 1
    fi

    sleep 3
    podman exec "$nombre_servidor" mkdir -p /config/.minetest/main-config
    printf "✅ Servidor '%s' funcionando en puerto %d!\n" "$nombre_servidor" "$puerto_servidor"
}

crear_servidor "$1" "$2"
