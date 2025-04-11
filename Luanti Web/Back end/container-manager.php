<?php
// manage_containers.php
// Script para administrar contenedores con Podman (start, stop, remove).
// Este script recibe una acción (start, stop, remove) y el nombre del contenedor a través de una solicitud POST.
// Se espera que el script se ejecute con privilegios de superusuario (sudo) para poder ejecutar comandos de Podman.
// Se utiliza escapeshellcmd para evitar inyecciones de comandos al pasar parámetros a la línea de comandos.
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    exit(json_encode(["success" => false, "message" => "Método de solicitud no permitido."]));
}

$action = isset($_POST['action']) ? trim($_POST['action']) : null;
$containerName = isset($_POST['name']) ? trim($_POST['name']) : null;
// Validar que se haya proporcionado una acción y un nombre de contenedor
// y que la acción sea válida (start, stop, remove).

if (!$action || !$containerName) {
    exit(json_encode(["success" => false, "message" => "Acción o nombre del contenedor no proporcionados."]));
}
$validActions = ['start', 'stop', 'remove'];
if (!in_array($action, $validActions)) {
    exit(json_encode(["success" => false, "message" => "Acción no válida."]));
}

$output = shell_exec(escapeshellcmd("sudo podman $action $containerName"));

header('Content-Type: application/json');
echo json_encode([
    "success" => true,
    "action" => $action,
    "containerName" => $containerName,
    "message" => trim($output)
]);
?>