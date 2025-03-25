
<?php
// Verifica si la solicitud HTTP es de tipo POST
shell_exec('sudo /home/scriptluanti/containerlifter.sh');
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    error_log("recupera los campos del form",0);
    // Obtiene el valor del campo 'server_name' enviado por el formulario y lo limpia
    // con escapeshellcmd() para evitar inyecciones de comandos en la terminal.
    $server_name = escapeshellcmd($_POST['server_name']);

    // Convierte el valor del campo 'max_users' a un número entero, 
    // asegurando que no contenga caracteres no numéricos.
    $max_users = intval($_POST['max_users']);

    // Verifica si el campo 'creative_mode' tiene el valor "yes". 
    // Si es así, lo convierte a "true", de lo contrario, a "false".
    $creative_mode = ($_POST['creative_mode'] === "yes") ? "true" : "false";

    // Verifica si el campo 'enable_damage' tiene el valor "yes". 
    // Si es así, lo convierte a "true", de lo contrario, a "false".
    $enable_damage = ($_POST['enable_damage'] === "yes") ? "true" : "false";
    error_log("antes del script");
    // Construye un comando para ejecutar un script de bash llamado 'containerlifter.sh'
    // y le pasa como parámetros los valores procesados desde el formulario.
    $command = "bash /home/scriptluanti/containerlifter.sh $server_name $max_users $creative_mode $enable_damage";

    // Ejecuta el comando en el sistema operativo del servidor y almacena el resultado en $output.
    $output = shell_exec($command);    

   echo "ivan y victor mandan";
}
?>
  GNU nano 7.2                                                                                                                                                                       index.php                                                                                                                                                                                 
<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    error_log("Recuperando datos del formulario...");

    // Sanitizar y validar entrada
    $server_name = escapeshellarg($_POST['server_name']);
    $max_users = intval($_POST['max_users']);
    $creative_mode = ($_POST['creative_mode'] === "yes") ? "true" : "false";
    $enable_damage = ($_POST['enable_damage'] === "yes") ? "true" : "false";

    // Validar datos esenciales
    if (empty($server_name) || $max_users <= 0) {
        die("Error: Parámetros inválidos.");
    }

    error_log("Ejecutando el script Bash...");

    // Ejecutar script Bash con parámetros
     $command = "echo 'usuario' | sudo -S /bin/bash /home/scriptluanti/containerlifter.sh $server_name $max_users $creative_mode $enable_damage 2>&1";
     $output = shell_exec($command);

    // Mostrar salida
    echo nl2br(htmlspecialchars($output));
}
?>












