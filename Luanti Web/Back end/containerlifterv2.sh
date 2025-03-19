#!/bin/bash

set -o pipefail

PUERTO_ARCHIVO="/home/scriptluanti/puerto_actual.txt"
VOLUMEN_BASE="/home/scriptluanti/volumenes"

preparar_directorios() {
    mkdir -p "$VOLUMEN_BASE"
    chown -R www-data:www-data "$VOLUMEN_BASE"

    if [[ ! -f "$PUERTO_ARCHIVO" ]]; then
        touch "$PUERTO_ARCHIVO"
        printf "30000\n" > "$PUERTO_ARCHIVO"
        chown www-data:www-data "$PUERTO_ARCHIVO"
    fi
}

obtener_puerto() {
    local puerto_base=30000
    local puerto_actual; puerto_actual=$(cat "$PUERTO_ARCHIVO" 2>/dev/null)

    if [[ -z "${puerto_actual// }" || "$puerto_actual" -lt "$puerto_base" ]]; then
        puerto_actual=$puerto_base
    fi

    local nuevo_puerto=$((puerto_actual + 1))
    printf "%d\n" "$nuevo_puerto" > "$PUERTO_ARCHIVO"

    printf "%d" "$nuevo_puerto"
}

crear_configuracion() {
    local nombre_servidor="$1"
    local max_users="$2"
    local config_dir="$VOLUMEN_BASE/${nombre_servidor}-config/main-config"
    local config_file="$config_dir/minetest.conf"

    mkdir -p "$config_dir"

    {
        printf "max_users = %s\n" "$max_users"
        printf "creative_mode = true\n"
        printf "enable_damage = false\n"
        printf "server_description = Atlantis Server\n"
    } > "$config_file"

    chown -R www-data:www-data "$config_dir"
}

iniciar_contenedor() {
    local nombre_servidor="$1"
    local puerto_servidor="$2"
    local volumen_dir="$VOLUMEN_BASE/${nombre_servidor}-config"

    if podman ps -a --format '{{.Names}}' | grep -qw "$nombre_servidor"; then
        printf "El contenedor '%s' ya existe.\n" "$nombre_servidor" >&2
        return 1
    fi

    if ! podman run -d --name="$nombre_servidor" -p "$puerto_servidor:30000/udp" \
        -e LUANTI_WORLDNAME="$nombre_servidor" \
        -v "$volumen_dir:/config/.minetest" \
        docker.io/linuxserver/luanti:latest > /dev/null; then
        printf "Error al iniciar el contenedor.\n" >&2
        return 1
    fi

    sleep 3

    if ! podman exec "$nombre_servidor" mkdir -p /config/.minetest/main-config; then
        printf "Error creando directorio dentro del contenedor.\n" >&2
        return 1
    fi

    chown -R www-data:www-data "$volumen_dir"
    printf "Servidor '%s' iniciado en puerto %s.\n" "$nombre_servidor" "$puerto_servidor"
}

crear_servidor() {
    local nombre_servidor="$1"
    local max_users="$2"

    if [[ -z "$nombre_servidor" || -z "$max_users" ]]; then
        printf "Uso: %s <nombre_servidor> <max_users>\n" "$0" >&2
        return 1
    fi

    local puerto_servidor; puerto_servidor=$(obtener_puerto)
    crear_configuracion "$nombre_servidor" "$max_users"
    iniciar_contenedor "$nombre_servidor" "$puerto_servidor"
}

main() {
    preparar_directorios
    crear_servidor "$1" "$2" || return 1
}

main "$@"


