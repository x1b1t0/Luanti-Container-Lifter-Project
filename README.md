# Luanti-Container-Lifter-Project

## Descripción (Español)

### Introducción
**Luanti-Container-Lifter-Project** es un proyecto destinado a facilitar la creación y gestión de servidores personalizados de Luanti mediante una interfaz web sencilla basada en HTML. Utiliza contenedores para garantizar un entorno seguro, escalable y reproducible, con el respaldo de herramientas como Podman.

### Características Principales
- **Interfaz Web Intuitiva**: Gestiona servidores de manera eficiente a través de una interfaz web.
- **Despliegue en Contenedores**: Proporciona un entorno seguro y reproducible usando Podman.
- **Automatización a través de Scripts**: Scripts personalizados para configurar y gestionar servidores de forma sencilla.
- **Diseño Modular**: Permite personalización y flexibilidad para diferentes entornos.

### Requisitos
- **Python 3.x**: Para ejecutar scripts esenciales.
- **Podman**: Para la creación y gestión de contenedores.

### Instalación
1. Clona este repositorio:
   ```bash
   git clone https://github.com/x1b1t0/Luanti-Container-Lifter-Project.git
   cd Luanti-Container-Lifter-Project
   ```
2. Instala las dependencias de Python (si es necesario):
   ```bash
   pip install -r requirements.txt
   ```
3. Asegúrate de tener Podman instalado en tu sistema.

### Uso
1. Construye la imagen del contenedor:
   ```bash
   podman build -t luanti-container-lifter .
   ```
2. Ejecuta el contenedor:
   ```bash
   podman run -d -p 8000:8000 luanti-container-lifter
   ```
3. Ejecuta el script principal:
   ```bash
   podman exec -it <container_id> python main.py <server_name> <max_users> <creative_mode> <enable_damage>
   ```

### Nota Importante
Este proyecto está destinado únicamente a fines educativos y pruebas autorizadas. No debe utilizarse para actividades ilegales o sin el permiso explícito de los propietarios de los recursos.

### Contribuciones
¡Las contribuciones son bienvenidas! Haz un fork del repositorio, realiza tus cambios y envía un pull request.

---

## Description (English)

### Introduction
**Luanti-Container-Lifter-Project** is a project designed to simplify the creation and management of custom Luanti servers through an easy-to-use HTML web interface. It leverages containers to ensure a secure, scalable, and reproducible environment, using tools like Podman.

### Key Features
- **Intuitive Web Interface**: Manage servers efficiently through a web interface.
- **Containerized Deployment**: Provides a secure and reproducible environment using Podman.
- **Automation via Scripts**: Custom scripts for easy setup and management of servers.
- **Modular Design**: Enables customization and flexibility for different environments.

### Requirements
- **Python 3.x**: To run essential scripts.
- **Podman**: For container creation and management.

### Installation
1. Clone this repository:
   ```bash
   git clone https://github.com/x1b1t0/Luanti-Container-Lifter-Project.git
   cd Luanti-Container-Lifter-Project
   ```
2. Install Python dependencies (if necessary):
   ```bash
   pip install -r requirements.txt
   ```
3. Ensure Podman is installed on your system.

### Usage
1. Build the container image:
   ```bash
   podman build -t luanti-container-lifter .
   ```
2. Run the container:
   ```bash
   podman run -d -p 8000:8000 luanti-container-lifter
   ```
3. Execute the main script:
   ```bash
   podman exec -it <container_id> python main.py <server_name> <max_users> <creative_mode> <enable_damage>
   ```

### Important Note
This project is intended for educational and authorized testing purposes only. It should not be used for illegal activities or without the explicit permission of resource owners.

### Contributions
Contributions are welcome! Fork the repository, make your changes, and submit a pull request.
