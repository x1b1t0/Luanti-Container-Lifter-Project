<?php
$showservers = shell_exec ('podman ps -a');

echo $showservers;
?>