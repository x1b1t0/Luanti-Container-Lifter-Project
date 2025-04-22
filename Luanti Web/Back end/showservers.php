<?php
// showservers.php
// Este script se encarga de mostrar los servidores que están corriendo en el sistema.
// Se utiliza el comando 'podman ps -a' para obtener la lista de contenedores y sus puertos.
$showservers = shell_exec('sudo podman ps -a --format "{{.Names}}#{{.Ports}}#{{.Status}}"');
$serversarray = explode("\n", trim($showservers)); // Dividir por líneas
$servers = [];
foreach ($serversarray as $fila) {
    list($name, $ports, $status) = explode("#", $fila); // Dividir cada línea en nombre y puertos
    $servers[] = [
        "name" => trim($name),
        "ports" => trim($ports),
        "status" => trim($status)
    ];
}
// Convertir la lista de servidores a formato JSON y enviarla como respuesta al php en la pagina myservers.html
header('Content-Type: application/json'); // Indicar que la salida es JSON
echo json_encode($servers);
?>
