#!/bin/bash

# Brief explanation of Podman commands
# Breve explicación de los comandos de Podman

# Pull an image from a container registry
# Descargar una imagen de un registro de contenedores
# podman pull <image>
# Example / Ejemplo:
# podman pull docker.io/library/alpine

# List all images
# Listar todas las imágenes
# podman images

# Run a container from an image
# Ejecutar un contenedor desde una imagen
# podman run <options> <image> <command>
# Example / Ejemplo:
# podman run -it --rm alpine sh

# List all running containers
# Listar todos los contenedores en ejecución
# podman ps

# Stop a running container
# Detener un contenedor en ejecución
# podman stop <container_id>

# Remove a container
# Eliminar un contenedor
# podman rm <container_id>

# Remove an image
# Eliminar una imagen
# podman rmi <image_id>

# Display system information
# Mostrar información del sistema
# podman info

# Display detailed information about a container
# Mostrar información detallada sobre un contenedor
# podman inspect <container_id>

# Display logs of a container
# Mostrar los registros de un contenedor
# podman logs <container_id>

# Copy files/folders between a container and the local filesystem
# Copiar archivos/carpetas entre un contenedor y el sistema de archivos local
# podman cp <container_id>:<path> <local_path>
# Example / Ejemplo:
# podman cp mycontainer:/etc/hosts /tmp/hosts

# Execute a command in a running container
# Ejecutar un comando en un contenedor en ejecución
# podman exec <container_id> <command>
# Example / Ejemplo:
# podman exec -it mycontainer sh