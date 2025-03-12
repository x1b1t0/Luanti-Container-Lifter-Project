#!/bin/bash

# Archivo para registrar el último puerto usado
PUERTO_ARCHIVO="puerto_actual.txt"

# Función para mostrar el título "ATLANTIS"
mostrar_titulo() {
    printf "\n         🚀 A T L A N T I S 🚀         \n\n"
}

# Función para obtener un puerto único
obtener_puerto() {
    local puerto_base=3001
    local puerto_actual=$(cat "$PUERTO_ARCHIVO" 2>/dev/null || echo "$puerto_base")

    echo $((puerto_actual + 1)) > "$PUERTO_ARCHIVO"
    printf "%d" "$((puerto_actual + 1))"
}

# Función para crear el archivo de configuración del servidor
crear_configuracion() {
    mkdir -p "$(pwd)/volumenes/$NOMBRE_SERVIDOR-config/main-config/"
    local config_file="$(pwd)/volumenes/$NOMBRE_SERVIDOR-config/main-config/minetest.conf"

    cat > "$config_file" <<EOF
max_users = ${MAX_USERS:-10}
creative_mode = ${CREATIVE_MODE:-false}
enable_damage = ${ENABLE_DAMAGE:-true}
server_description = "${SERVER_DESCRIPTION:-Servidor Atlantis}"
noclip = ${NOCLIP:-false}
EOF

    printf "✅ Configuración creada en %s\n" "$config_file"
}

# Función para crear un servidor
crear_servidor() {
    mostrar_titulo

    # Definir valores predeterminados si no están en las variables de entorno
    NOMBRE_USUARIO=${NOMBRE_USUARIO:-"admin"}
    NOMBRE_SERVIDOR=${NOMBRE_SERVIDOR:-"Atlantis-Server"}
    
    local puerto_servidor
    puerto_servidor=$(obtener_puerto)

    printf "🔧 Configurando servidor...\n"
    crear_configuracion

    printf "🚀 Iniciando servidor '%s' para usuario '%s' en puerto %d...\n" "$NOMBRE_SERVIDOR" "$NOMBRE_USUARIO" "$puerto_servidor"
    
    mkdir -p "./$NOMBRE_SERVIDOR-config"

    podman run -d --name="$NOMBRE_SERVIDOR" -p "$puerto_servidor:30000/udp" \
        -e MINETEST_WORLDNAME="$NOMBRE_SERVIDOR" \
        -v "$(pwd)/volumenes/$NOMBRE_SERVIDOR-config:/config/.minetest" \
        docker.io/linuxserver/luanti:latest

    if [ $? -ne 0 ]; then
        printf "❌ Error al iniciar el servidor.\n" >&2
        return 1
    fi

    sleep 3

    podman exec "$NOMBRE_SERVIDOR" mkdir -p /config/.minetest/main-config

    printf "📂 Aplicando configuración en /config/.minetest/main-config...\n"

    printf "✅ Servidor '%s' funcionando en puerto %d!\n" "$NOMBRE_SERVIDOR" "$puerto_servidor"
}

# Función para eliminar un servidor
eliminar_servidor() {
    mostrar_titulo

    podman stop "$NOMBRE_SERVIDOR" && podman rm "$NOMBRE_SERVIDOR" && printf "🗑️  Servidor eliminado!\n"
    rm -rf "./$NOMBRE_SERVIDOR-config"
}

# Función para encender un servidor
encender_servidor() {
    mostrar_titulo

    podman start "$NOMBRE_SERVIDOR" && printf "✅ Servidor encendido!\n"
}

# Función para apagar un servidor
parar_servidor() {
    mostrar_titulo

    podman stop "$NOMBRE_SERVIDOR" && printf "🛑 Servidor apagado!\n"
}

# Comprobamos el argumento pasado y ejecutamos la función correspondiente
case "$1" in
    crear) crear_servidor ;;
    eliminar) eliminar_servidor ;;
    encender) encender_servidor ;;
    apagar) parar_servidor ;;
    *)
        printf "❌ Opción inválida!\n"
        printf "Uso: $0 {crear|eliminar|encender|apagar}\n"
        exit 1
    ;;
esac
