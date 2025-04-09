<?php
$showservers = shell_exec('sudo podman ps -a --format "{{.Names}}#{{.Ports}}"');
$serversarray = explode("\n", trim($showservers)); // Dividir por líneas

$servers = [];
foreach ($serversarray as $fila) {
    list($name, $ports) = explode("#", $fila); // Dividir cada línea en nombre y puertos
    $servers[] = [
        "name" => trim($name),
        "ports" => trim($ports)
    ];
}

header('Content-Type: application/json'); // Indicar que la salida es JSON
echo json_encode($servers);
?>