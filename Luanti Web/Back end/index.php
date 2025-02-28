<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $name = escapeshellarg($_POST['name']);
    $playernumbers = escapeshellarg($_POST['playernumbers']);
    
    //Ejecuccion de el script de bash
    $command = "bash /var/www/html/Back\ end/script.sh $name $message";
    $outpout = shell_exec($command);
    echo $outpout;
}
?>