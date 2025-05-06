<?php
// manage_containers.php
// Script para administrar contenedores con Podman (start, stop, remove).

// Leer los datos de entrada
$requestBody = file_get_contents('php://input');
$data = json_decode($requestBody, true);

$action = $data['action'] ?? null;
$containerName = $data['name'] ?? null;

// Validar parámetros
if (!$action || empty($action)) {
    exit(json_encode(["success" => false, "message" => "Acción no proporcionada o vacía."]));
}
if (!$containerName || empty($containerName)) {
    exit(json_encode(["success" => false, "message" => "Nombre del contenedor no proporcionado o vacío."]));
}

// Comando base para Podman
$podmanCommand = "podman";

// Comando a ejecutar
switch ($action) {
    case 'start':
        $command = "sudo $podmanCommand start $containerName";
        break;
    case 'stop':
        $command = "sudo $podmanCommand stop $containerName";
        break;
    case 'remove':
        $command = "sudo $podmanCommand rm $containerName";
        break;
    default:
        exit(json_encode(["success" => false, "message" => "Acción no válida."]));
}

// Ejecutar el comando
exec($command, $output, $returnVar);

if ($returnVar === 0) {
    exit(json_encode(["success" => true, "message" => "Comando ejecutado correctamente.", "output" => $output]));
} else {
    exit(json_encode(["success" => false, "message" => "Error al ejecutar el comando.", "output" => $output]));
}
?>


