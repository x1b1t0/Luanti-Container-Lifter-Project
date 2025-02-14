const { exec } = require('child_process');

const crearServidor = (ipServidor, nombreServidor, puertoServidor, callback) => {
    exec(`podman run -d --name="${nombreServidor}" -p "${puertoServidor}:30000/udp" -e CLI_ARGS="--gameid devtest" luanti:latest`, callback);
};

module.exports = { crearServidor };