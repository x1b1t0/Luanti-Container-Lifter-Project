<?php
$showservers = shell_exec('sudo podman ps -a --format "table {{.Names}}\t{{.Ports}}#"');
$serversarray = explode("#", $showservers);

//Hacer un bucle que empiece en el 0 el limite es la longitud del array por cada contenedor que hay crea una fila nueva
foreach ($serversarray as $fila){
 echo "fila: $fila";
}
//Hay que hacer que el HTML coja el php y con esta informacion cree una table bien organizada y estructurada de todos los valores que aqui aaprecen
?>
