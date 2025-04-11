<?php
// manage_containers.php
// Script para administrar contenedores con Podman (start, stop, remove).

$action = $_POST['action'] ?? null;
$containerName = $_POST['name'] ?? null;

// Validar parámetros
if (!$action) {
    exit(json_encode(["success" => false, "message" => "Acción no proporcionada."]));
}
if (!$containerName) {
    exit(json_encode(["success" => false, "message" => "Nombre del contenedor no proporcionado."]));
}
// Comando base para Podman
$podmanCommand = "podman";
// Comando a ejecutar
?>