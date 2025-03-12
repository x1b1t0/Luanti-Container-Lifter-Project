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
    mkdir -p "$(pwd)/volumenes/$nombre_servidor-config/main-config/"
    local config_file="$(pwd)/volumenes/$nombre_servidor-config/main-config/minetest.conf"

    printf "Máximo de jugadores: "
    read -r max_users

    printf "¿Modo creativo? (true/false): "
    read -r creative_mode

    printf "¿Permitir daño? (true/false): "
    read -r enable_damage

   printf " ¿Descripción del servidor?: "
    read -r server_description

    printf " Volar (true/false): "
    read -r noclip
    cat > "$config_file" <<EOF
max_users = $max_users
creative_mode = $creative_mode
enable_damage = $enable_damage
server_description = $server_description
noclip = $noclip

EOF

    printf "✅ Configuración creada en %s\n" "$config_file"
}

# Función para crear un servidor
crear_servidor() {
    mostrar_titulo
    printf "Tu nombre de usuario: "
    read -r nombre_usuario

    printf "Nombre del servidor: "
    read -r nombre_servidor

    if [ -z "$nombre_servidor" ]; then
        printf "❌ Error: El nombre del servidor no puede estar vacío.\n" >&2
        return 1
    fi

    local puerto_servidor
    puerto_servidor=$(obtener_puerto)

    printf "🔧 Configurando servidor...\n"
    crear_configuracion

    printf "🚀 Iniciando servidor '%s' para usuario '%s' en puerto %d...\n" "$nombre_servidor" "$nombre_usuario" "$puerto_servidor"
    # Crear directorio local para persistencia de configuración
    mkdir -p "./$nombre_servidor-config"

    # Iniciar el contenedor con un volumen montado para la configuración
    podman run -d --name="$nombre_servidor" -p "$puerto_servidor:30000/udp" \
        -e MINETEST_WORLDNAME="$nombre_servidor" \
        -v "$(pwd)/volumenes/$nombre_servidor-config:/config/.minetest" \
        docker.io/linuxserver/luanti:latest

    if [ $? -ne 0 ]; then
        printf "❌ Error al iniciar el servidor.\n" >&2
        return 1
    fi

    # Esperar un momento para que el contenedor inicie completamente
    sleep 3

    # Crear la nueva ruta dentro del contenedor si no existe
    podman exec "$nombre_servidor" mkdir -p /config/.minetest/main-config

    # Copiar configuración al nuevo directorio en el contenedor
    printf "📂 Aplicando configuración en /config/.minetest/main-config...\n"
#    podman cp minetest.conf "$nombre_servidor:/config/.minetest/main-config/minetest.conf"

    printf "✅ Servidor '%s' funcionando en puerto %d!\n" "$nombre_servidor" "$puerto_servidor"
}

# Función para eliminar un servidor
eliminar_servidor() {
    mostrar_titulo
    printf "Servidor a eliminar: "
    read -r nombre_servidor

    if [ -z "$nombre_servidor" ]; then
        printf "❌ Error: Debes ingresar un nombre de servidor.\n"
        return 1
    fi
    podman stop "$nombre_servidor" && podman rm "$nombre_servidor" && printf "🗑️  Servidor eliminado!\n"

    # Eliminar la configuración local
    rm -rf "./$nombre_servidor-config"
}

# Función para encender un servidor
encender_servidor() {
    mostrar_titulo
    printf "Servidor a encender: "
    read -r nombre_servidor

    if [ -z "$nombre_servidor" ]; then
        printf "❌ Error: Debes ingresar un nombre de servidor.\n"
        return 1
    fi

    if ! podman ps -a --format "{{.Names}}" | grep -q "^$nombre_servidor$"; then
        printf "⚠️  El servidor '%s' no existe.\n" "$nombre_servidor"
        return 1
    fi

    podman start "$nombre_servidor" && printf "✅ Servidor encendido!\n"
}

# Función para apagar un servidor
parar_servidor() {
    mostrar_titulo
    printf "Servidor a apagar: "
    read -r nombre_servidor

    if [ -z "$nombre_servidor" ]; then
        printf "❌ Error: Debes ingresar un nombre de servidor.\n"
        return 1
    fi

    if ! podman ps --format "{{.Names}}" | grep -q "^$nombre_servidor$"; then
        printf "⚠️  El servidor '%s' no está en ejecución.\n" "$nombre_servidor"
        return 1
    fi

    podman stop "$nombre_servidor" && printf "🛑 Servidor apagado!\n"
}

# Menú principal
while true; do
    mostrar_titulo
    printf "1) 🆕 Crear servidor\n"
    printf "2) 🗑️  Eliminar servidor\n"
    printf "3) 🔥 Encender servidor\n"
    printf "4) 🛑 Apagar servidor\n"
    printf "5) ❌ Salir\n"
    printf "Seleccione una opción: "

    read -r opcion
    case "$opcion" in
        1) crear_servidor ;;
        2) eliminar_servidor ;;
        3) encender_servidor ;;
        4) parar_servidor ;;
        5) exit 0 ;;
        *) printf "❌ Opción inválida!\n" ;;
    esac
done
