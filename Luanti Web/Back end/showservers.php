<?php
$showservers = shell_exec('sudo podman ps -a --format "table {{.Names}}\t{{.Ports}}#"');
$serversarray = explode("#", $showservers);
echo $serversarray[1];
//Hacer un bucle que empiece en el 0 el limite es la longitud del array por cada contenedor que hay crea una fila nueva
?>