// Este archivo contiene un script que agrega un evento al botón con el id 'loadData'.
// Cuando se hace clic en el botón, se realiza una solicitud fetch a un endpoint específico.
// Los datos obtenidos de la respuesta se muestran en un contenedor con el id 'dataContainer'.
// Si ocurre un error durante la solicitud, se muestra en la consola.
document.getElementById('loadData').addEventListener('click', function() {
    fetch('/backend/index.php/endpoint')
        .then(response => response.json())
        .then(data => {
            const dataContainer = document.getElementById('dataContainer');
            dataContainer.innerHTML = JSON.stringify(data, null, 2);
        })
        .catch(error => console.error('Error:', error));
});