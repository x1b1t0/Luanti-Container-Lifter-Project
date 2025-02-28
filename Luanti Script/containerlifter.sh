#!/bin/bash

# Función para mostrar el título "ATLANTIS"
mostrar_titulo() {
    echo "----------------------------------"
    echo "         A T L A N T I S         "
    echo "----------------------------------"
    echo ""
}

# Función para crear el servidor
crear_servidor() {
    clear
    ipServidor="127.0.0.1"

    echo "Elige el nombre del servidor:"
    read nombreServidor

    echo "Elige el puerto del servidor (Presiona Enter para usar 1999):"
    read puertoServidor
    puertoServidor=${puertoServidor:-1999}

    echo "Iniciando tu servidor..."
    podman run -d --name="$nombreServidor" -p "$puertoServidor:30000/udp" -e CLI_ARGS="--gameid devtest" luanti:latest

    clear
    echo "Tu servidor ya está funcionando en la IP $ipServidor y con el puerto $puertoServidor."
    sleep 15
}

# Función para listar los contenedores
listar_contenedores() {
    clear
    echo "Contenedores en ejecución:"
    podman ps --format "table {{.Names}}\t{{.Ports}}"
    echo ""
    echo "Presiona Enter para continuar..."
    read
}

# Función para mostrar el menú
mostrar_menu() {
    while true; do
        mostrar_titulo
        echo "1) Crear servidor"
        echo "2) Listar contenedores"
        echo "3) Salir"
        echo -n "Seleccione una opción: "
        read opcion

        case $opcion in
            1) crear_servidor ;;
            2) listar_contenedores ;;
            3) echo "Saliendo..."; exit 0 ;;
            *) echo "Opción inválida, intenta de nuevo." ;;
        esac
    done
}

# Ejecutar el menú
mostrar_menu
