# Luanti-Container-Lifter-Project

## Descripción

Este proyecto de investigación tiene como objetivo facilitar la creación y gestión de servidores personalizados de Luanti a través de una interfaz web HTML. Utiliza contenedores gestionados con Podman para asegurar un entorno seguro y reproducible.

## Características Principales

- **Interfaz Web Sencilla**: Gestiona servidores de Luanti fácilmente a través de una interfaz web en HTML.
- **Despliegue en Contenedores**: Utiliza Podman para el despliegue de servidores en contenedores, asegurando un entorno seguro y reproducible.
- **Scripts Automatizados**: Scripts para automatizar la configuración y gestión de los servidores.
- **Diseño Modular**: Facilita la personalización y el uso en diversos entornos.

## Objetivo

El objetivo principal de este proyecto es democratizar la creación de servidores para Luanti, proporcionando una solución accesible y eficiente para usuarios y comunidades interesados en levantar sus propios servidores.

## Habilidades Aplicadas

- **Contenerización con Podman**
- **Programación de Scripts Bash para la Automatización de Tareas**
- **Diseño Básico de Interfaces Web en HTML**
- **Gestión de Servidores y Administración de Entornos Virtuales**

## Requisitos

- Python 3.x
- Podman

## Instalación

1. Clonar el repositorio:
    ```bash
    git clone https://github.com/x1b1t0/Luanti-Container-Lifter-Project.git
    cd Luanti-Container-Lifter-Project
    ```

2. Instalar dependencias de Python (si es necesario):
    ```bash
    pip install -r requirements.txt
    ```

3. Asegurarse de que Podman esté instalado en su sistema.

## Uso

1. Construir la imagen del contenedor:
    ```bash
    podman build -t luanti-container-lifter .
    ```

2. Ejecutar el contenedor:
    ```bash
    podman run -d -p 8000:8000 luanti-container-lifter
    ```

3. Ejecutar el script principal:
    ```bash
    podman exec -it <container_id> python main.py <server_name> <max_users> <creative_mode> <enable_damage>
    ```

4. Seguir las instrucciones en pantalla para seleccionar la utilidad deseada.

## Nota Importante

**Luanti-Container-Lifter-Project** está destinado únicamente a fines educativos y de pruebas autorizadas. No utilice esta herramienta para actividades ilegales o sin el permiso explícito del propietario del objetivo.

## Contribuciones

¡Las contribuciones son bienvenidas! Si deseas contribuir a este proyecto, por favor realiza un fork del repositorio y envía una pull request con tus cambios.

## Licencia

Este proyecto está licenciado bajo la Licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.

## Estado del Desarrollo

Este proyecto está actualmente en desarrollo. Se están añadiendo nuevas funcionalidades y mejoras regularmente. ¡Mantente al tanto de las actualizaciones!

---

# Luanti-Container-Lifter-Project

## Description

This research project aims to facilitate the creation and management of custom Luanti servers through an HTML web interface. It uses containers managed with Podman to ensure a flexible, scalable, and reproducible environment.

## Main Features

- **Simple HTML Web Interface**: Easily manage Luanti servers through a straightforward HTML web interface.
- **Containerized Deployment**: Uses Podman for containerized server deployment, ensuring a secure and reproducible environment.
- **Automated Scripts**: Scripts to automate the setup, configuration, and management of servers.
- **Modular Design**: Facilitates customization and use in various environments.

## Objective

The primary goal of this project is to democratize the creation of Luanti servers, providing an accessible and efficient solution for users and communities interested in setting up their own servers.

## Skills Applied

- **Containerization with Podman**
- **Bash Scripting for Task Automation**
- **Basic Web Interface Design in HTML**
- **Server Management and Virtual Environment Administration**

## Requirements

- Python 3.x
- Podman

## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/x1b1t0/Luanti-Container-Lifter-Project.git
    cd Luanti-Container-Lifter-Project
    ```

2. Install Python dependencies (if necessary):
    ```bash
    pip install -r requirements.txt
    ```

3. Ensure Podman is installed on your system.

## Usage

1. Build the container image:
    ```bash
    podman build -t luanti-container-lifter .
    ```

2. Run the container:
    ```bash
    podman run -d -p 8000:8000 luanti-container-lifter
    ```

3. Run the main script:
    ```bash
    podman exec -it <container_id> python main.py <server_name> <max_users> <creative_mode> <enable_damage>
    ```

4. Follow the on-screen instructions to select the desired utility.

## Important Note

**Luanti-Container-Lifter-Project** is intended for educational purposes and authorized testing only. Do not use this tool for illegal activities or without explicit permission from the target owner.

## Contributing

Contributions are welcome! If you wish to contribute to this project, please fork the repository and submit a pull request with your changes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Development Status

This project is currently under development. New features and improvements are being added regularly. Stay tuned for updates!

## Development Status

This project is currently under development. New features and improvements are being added regularly. Stay tuned for updates!
