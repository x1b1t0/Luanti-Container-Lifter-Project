import sys

def main(server_name, max_users, creative_mode, enable_damage):
    # Lógica para manejar los argumentos y crear el servidor
    print(f"Server Name: {server_name}")
    print(f"Max Users: {max_users}")
    print(f"Creative Mode: {creative_mode}")
    print(f"Enable Damage: {enable_damage}")
    # Aquí puedes agregar la lógica para crear el servidor

if __name__ == "__main__":
    if len(sys.argv) != 5:
        print("Usage: main.py <server_name> <max_users> <creative_mode> <enable_damage>")
        sys.exit(1)
    server_name = sys.argv[1]
    max_users = sys.argv[2]
    creative_mode = sys.argv[3]
    enable_damage = sys.argv[4]
    main(server_name, max_users, creative_mode, enable_damage)