<?php
// manage_containers.php
// Script para administrar contenedores (iniciar, detener, eliminar) utilizando Podman.

// Obtener la acción y el nombre del contenedor de la solicitud
$action = $_POST['action'] ?? null; // Las acciones posibles son: start, stop, remove
$containerName = $_POST['name'] ?? null;

if (!$action || !$containerName) {
    exit(json_encode([
        "success" => false,
        "message" => "Acción o nombre del contenedor no proporcionados."
    ]));
}

// Función para ejecutar comandos de podman
function executePodmanCommand($command, $containerName) {
    $fullCommand = escapeshellcmd("sudo podman $command $containerName");
    $output = shell_exec($fullCommand);
    return $output;
}
?>
