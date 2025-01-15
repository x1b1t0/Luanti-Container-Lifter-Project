#!/bin/bash

# Función para instalar Podman y Minetest
install_dependencies() {
    echo "Instalando Podman y Minetest..."
    # Instalar Podman
    if ! command -v podman &> /dev/null; then
        echo "Podman no está instalado. Instalándolo ahora..."
        sudo apt update && sudo apt install -y podman
    else
        echo "Podman ya está instalado."
    fi

    # Instalar Minetest
    if ! command -v minetest &> /dev/null; then
        echo "Minetest no está instalado. Instalándolo ahora..."
        sudo apt update && sudo apt install -y minetest
    else
        echo "Minetest ya está instalado."
    fi
    clear
}

# Función para configurar el servidor
configure_server() {
    echo "Configurando el servidor de Minetest..."
    
    # Solicitar parámetros al usuario
    read -p "Introduce el puerto del servidor (por defecto: 30000): " SERVER_PORT
    SERVER_PORT=${SERVER_PORT:-30000}

    read -p "Introduce el número máximo de jugadores (por defecto: 10): " MAX_PLAYERS
    MAX_PLAYERS=${MAX_PLAYERS:-10}

    read -p "Introduce el nombre del servidor (por defecto: My Minetest Server): " SERVER_NAME
    SERVER_NAME=${SERVER_NAME:-"My Minetest Server"}

    read -p "Introduce la descripción del servidor (por defecto: Welcome to Minetest!): " SERVER_DESCRIPTION
    SERVER_DESCRIPTION=${SERVER_DESCRIPTION:-"Welcome to Minetest!"}

    # Crear configuración personalizada de minetest.conf
    CONFIG_PATH="./minetest.conf"
    echo "Escribiendo configuración en $CONFIG_PATH..."
    cat <<EOL > $CONFIG_PATH
# Configuración del servidor Minetest
port = $SERVER_PORT
max_users = $MAX_PLAYERS
server_name = $SERVER_NAME
server_description = $SERVER_DESCRIPTION
enable_damage = true
creative_mode = false
EOL

    echo "Configuración creada con éxito en $CONFIG_PATH."
}

# Función para ejecutar el servidor en un contenedor
run_server() {
    echo "Iniciando el servidor Minetest en un contenedor con Podman..."

    # Crear directorio de configuración si no existe
    CONFIG_DIR="./config/.minetest"
    mkdir -p $CONFIG_DIR

    # Copiar el archivo de configuración personalizado
    cp ./minetest.conf $CONFIG_DIR/minetest.conf

    # Ejecutar el contenedor con Podman
    podman run -d --name=minetest-server \
        -p ${SERVER_PORT}:${SERVER_PORT}/udp \
        -v $(pwd)/config/.minetest:/config/.minetest \
        linuxserver/minetest

    echo "El servidor de Minetest se está ejecutando en el puerto $SERVER_PORT."
    echo "Para detener el servidor, usa: podman stop minetest-server"
    echo "Para reiniciar el servidor, usa: podman start minetest-server"
}

# Menú principal
clear
echo "Bienvenido al configurador de servidores Minetest"
echo "------------------------------------------------"
echo "1. Instalar dependencias (Podman y Minetest)"
echo "2. Configurar el servidor"
echo "3. Iniciar el servidor"
echo "4. Salir"
echo "------------------------------------------------"

read -p "Selecciona una opción: " OPTION

case $OPTION in
    1)
        install_dependencies
        ;;
    2)
        configure_server
        ;;
    3)
        run_server
        ;;
    4)
        echo "Saliendo..."
        exit 0
        ;;
    *)
        echo "Opción no válida. Saliendo..."
        exit 1
        ;;
esac
