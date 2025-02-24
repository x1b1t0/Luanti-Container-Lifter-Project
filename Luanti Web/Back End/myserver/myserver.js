document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('add-server-form');
    const serverList = document.getElementById('servers');

    form.addEventListener('submit', (e) => {
        e.preventDefault();
        
        const serverName = document.getElementById('server-name').value;
        const serverIp = document.getElementById('server-ip').value;

        if (serverName && serverIp) {
            const listItem = document.createElement('li');
            listItem.textContent = `${serverName} - ${serverIp}`;
            serverList.appendChild(listItem);

            form.reset();
        }
    });
});