sudo apt install podman

podman pull docker.io/linuxserver/luanti:latest

podman pull linuxserver/luanti

podman images

podman run -d --name luanti-container linuxserver/luanti:latest

echo "Después de esto ya pueden utilizar el fichero containerlifter.sh"
echo "After this, you can use the containerlifter.sh file"

echo "Para más información, visita https://hub.docker.com/r/linuxserver/luanti"
echo "For more information, visit https://hub.docker.com/r/linuxserver/luanti"

podman exec -it luanti-container /bin/bash -c "wget https://example.com/luanti.zip -O /path/to/destination/luanti.zip"

# Si tienen alguna duda, hagan una issue o utilicen el apartado de contacto de la página web.
# If you have any questions, create an issue or use the contact section of the website.