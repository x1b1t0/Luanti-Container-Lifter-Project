<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $server_name = escapeshellcmd($_POST['server_name']);
    $max_users = intval($_POST['max_users']);
    $creative_mode = ($_POST['creative_mode'] === "yes") ? "true" : "false";
    $enable_damage = ($_POST['enable_damage'] === "yes") ? "true" : "false";
    
    // Ejecución del script de bash
    $command = "bash /var/www/html/Backend/containerlifter.sh $server_name $max_users $creative_mode $enable_damage";
    $output = shell_exec($command);    
}
?> 