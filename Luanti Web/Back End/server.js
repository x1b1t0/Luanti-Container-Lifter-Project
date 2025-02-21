const readline = require('readline');
const { exec } = require('child_process');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

function mostrarTitulo() {
    console.clear();
    console.log('----------------------------------');
    console.log('         A T L A N T I S         ');
    console.log('----------------------------------');
    console.log('');
}

function crearServidor() {
    console.clear();
    rl.question('¿Cuál es la IP de tu ordenador? (Presiona Enter para usar 127.0.0.1): ', (ipServidor) => {
        ipServidor = ipServidor || '127.0.0.1';

        rl.question('Elige el nombre del servidor: ', (nombreServidor) => {
            rl.question('Elige el puerto del servidor (Presiona Enter para usar 1999): ', (puertoServidor) => {
                puertoServidor = puertoServidor || '1999';

                console.log('Iniciando tu servidor...');
                exec(`podman run -d --name="${nombreServidor}" -p "${puertoServidor}:30000/udp" -e CLI_ARGS="--gameid devtest" luanti:latest`, (error, stdout, stderr) => {
                    if (error) {
                        console.error(`Error al iniciar el servidor: ${error.message}`);
                        return;
                    }
                    if (stderr) {
                        console.error(`stderr: ${stderr}`);
                        return;
                    }
                    console.clear();
                    console.log(`Tu servidor ya está funcionando en la IP ${ipServidor} y con el puerto ${puertoServidor}.`);
                    setTimeout(mostrarMenu, 15000);
                });
            });
        });
    });
}

function mostrarMenu() {
    mostrarTitulo();
    console.log('1) Crear servidor');
    console.log('2) Salir');
    rl.question('Seleccione una opción: ', (opcion) => {
        switch (opcion) {
            case '1':
                crearServidor();
                break;
            case '2':
                console.log('Saliendo...');
                rl.close();
                break;
            default:
                console.log('Opción inválida, intenta de nuevo.');
                mostrarMenu();
                break;
        }
    });
}

// Ejeccuccion del menú
mostrarMenu();