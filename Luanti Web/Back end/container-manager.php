<?php
// manage_containers.php
// Script para administrar contenedores con Podman (start, stop, remove).

$action = isset($_POST['action']) ? $_POST['action'] : null;
$containerName = isset($_POST['name']) ? $_POST['name'] : null;

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