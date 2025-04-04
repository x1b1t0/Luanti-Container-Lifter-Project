
<?php
// Verifica si la solicitud HTTP es de tipo POST
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
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
    
    // Ejecución del script de bash
    $command = "bash /var/www/html/Backend/containerlifter.sh $server_name $max_users $creative_mode $enable_damage";
    $output = shell_exec($command);    

    header('Location: www.google.com');
}
?>












