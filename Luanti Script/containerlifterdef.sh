#!/bin/bash

# Variable para contar el tiempo desde la última interacción
LAST_INTERACTION=0

# Función para manejar el "clear" solo si han pasado 20 segundos
verificar_clear() {
    if (( SECONDS - LAST_INTERACTION >= 20 )); then
        clear
    fi
}

# Función para mostrar el título "ATLANTIS"
mostrar_titulo() {
    verificar_clear
    echo "----------------------------------"
    echo "         A T L A N T I S         "
    echo "----------------------------------"
    echo ""
}

# Función para crear el servidor
crear_servidor() {
    LAST_INTERACTION=$SECONDS
    ipServidor="127.0.0.1"  # Se usa la IP de loopback

    echo "Elige el nombre del servidor:"
    read nombreServidor
    LAST_INTERACTION=$SECONDS

    echo "Elige el puerto del servidor (Presiona Enter para usar 1999):"
    read puertoServidor
    puertoServidor=${puertoServidor:-1999}  # Si el usuario no ingresa nada, usa 1999
    LAST_INTERACTION=$SECONDS

    echo "Iniciando tu servidor '$nombreServidor' en la IP $ipServidor y el puerto $puertoServidor..."
    
    # Ejecutar el contenedor
    podman run -d --name="$nombreServidor" -p "$ipServidor:$puertoServidor:30000/udp" -e CLI_ARGS="--gameid devtest" luanti:latest
    LAST_INTERACTION=$SECONDS

    # Verificar si el contenedor se inició correctamente
    if podman ps --format "{{.Names}}" | grep -q "^$nombreServidor$"; then
        echo "✅ Tu servidor '$nombreServidor' ya está funcionando."
        echo "🌍 Dirección IP: $ipServidor"
        echo "🔌 Puerto: $puertoServidor"
    else
        echo "❌ Hubo un problema al iniciar el servidor. Revisa los logs con: podman logs $nombreServidor"
    fi

    echo "Presiona Enter para continuar..."
    read
    LAST_INTERACTION=$SECONDS
}

# Función para listar los contenedores
listar_contenedores() {
    LAST_INTERACTION=$SECONDS
    echo "Contenedores en ejecución:"
    
    # Guardar la salida de podman ps
    contenedores=$(podman ps --format "table {{.Names}}\t{{.Ports}}")

    # Verificar si la salida está vacía
    if [ -z "$(echo "$contenedores" | tail -n +2)" ]; then
        echo "No hay contenedores en ejecución."
    else
        echo "$contenedores"
    fi

    echo ""
    echo "Presiona Enter para continuar..."
    read
    LAST_INTERACTION=$SECONDS
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
        LAST_INTERACTION=$SECONDS

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