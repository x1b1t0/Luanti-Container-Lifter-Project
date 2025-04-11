<?php
// manage_containers.php
// Script para administrar contenedores con Podman (start, stop, remove).

$action = $_POST['action'] ?? null;
$containerName = $_POST['name'] ?? null;

// Validar parámetros
if (!$action) {
    exit(json_encode(["success" => false, "message" => "Acción no proporcionada."]));
}
?>