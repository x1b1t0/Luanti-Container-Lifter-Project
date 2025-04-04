<?php
header('Content-Type: application/json');
$showservers = shell_exec('podman ps -a --format json');
echo $showservers;
?>