<?php
// showservers.php
// Este script muestra los servidores que están corriendo en el sistema
// además de incluir la IP de la interfaz enp0s3.

// Conseguir la IP de la interfaz enp0s3
$ipOutput = shell_exec("ip -4 addr show enp0s3 | grep -oP '(?<=inet\\s)\\d+(\\.\\d+){3}'");
$ipAddress = trim($ipOutput); // Limpiar espacios en blanco

// Coger información de los servidores
$showservers = shell_exec('sudo podman ps -a --format "{{.Names}}#{{.Ports}}#{{.Status}}"');
$serversarray = explode("\n", trim($showservers)); // Dividir por líneas
$servers = [];
foreach ($serversarray as $fila) {
    if (!empty($fila)) { // Verificar que la línea no esté vacía
        list($name, $ports, $status) = explode("#", $fila); // Dividir cada línea en nombre, puertos y estado

        // Extraer el puerto externo de los contenedores de podman que contienen los servidores luanti para jugar.
        preg_match('/:(\d+)->/', $ports, $matches); // Búsqueda del puerto externo
        $externalPort = $matches[1] ?? 'N/A'; // Si no encuentra puerto o no hay puerto, usar 'N/A'

        // Traducir el estado
        $traduccionestado = match (strtolower(trim($status))) {
            'created' => 'Stopped',
            'up' => 'Active',
            'exited' => 'Detained',
            default => 'Unknown'
        };

        $servers[] = [
            "name" => trim($name),
            "ports" => $externalPort,
            "status" => $traduccionestado,
            "ip" => $ipAddress // Enseñar la IP de enp0s3 a cada servidor
        ];
    }
}

// Convertir la lista de servidores a formato JSON
header('Content-Type: application/json'); // Indicar que la salida es JSON
echo json_encode($servers);
?>

