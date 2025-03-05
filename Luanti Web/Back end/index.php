<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $server_name = escapeshellarg($_POST['name']);
    $max_users = escapeshellarg($_POST['players']);
    $creative_mode = escapeshellarg($_POST['creativemode']);
    $enable_damage = escapeshellarg($_POST['pvp']);

    // Ejecución del script de bash
    $command = "bash /var/www/html/Backend/containerlifter.sh $server_name $max_users $creative_mode $enable_damage";
    $output = shell_exec($command);
    echo $output;

    // Ejecución del script de Python
    $python_command = "python3 /var/www/html/Backend/main.py $server_name $max_users $creative_mode $enable_damage";
    $python_output = shell_exec($python_command);
    echo $python_output;
}
?> 