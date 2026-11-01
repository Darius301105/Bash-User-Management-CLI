#!/bin/bash
# Main entry point: interactive menu for registering, logging in and managing users.

USERS_CSV="users.csv"
HOMES_DIR="homes"
LOGGED_USER=""

# Create the storage directory and the CSV file (with header) on first run
[ -d "$HOMES_DIR" ] || mkdir "$HOMES_DIR"
[ -f "$USERS_CSV" ] || echo "ID,Name,Email,Hash,HomeDir,LastLogin" > "$USERS_CSV"

# Menu shown before authentication
function main_menu() {
    while true; do
        echo "----- MAIN MENU -----"
        echo "1. Register new user"
        echo "2. Login"
        echo "3. Exit"
        read -p "Choose an option: " opt
        case $opt in
            1) ./register_user.sh ;;
            2)
		# login_user.sh prints the username on success
		USER=$(./login_user.sh)
		status=$?
                if [[ $status -eq 0 && ! -z "$USER" ]]; then
		    LOGGED_USER="$USER"
                    user_menu "$LOGGED_USER"

                fi
                ;;
            3) echo "Goodbye!"; exit 0 ;;
            *) echo "Invalid option!";;
        esac
    done
}

# Menu shown after a successful login
function user_menu() {
    local user=$1
    clear
    echo "-----------------------------------------"
    echo " Welcome, $user!"
    echo ""
    echo "-----------------------------------------"
    while true; do
        echo "----- USER MENU -----"
        echo "1. Generate report"
        echo "2. Logout"
        echo "3. Exit"
        read -p "Choose an option: " opt
        case $opt in
            1) ./generate_report.sh "$user" ;;
            2) ./logout_user.sh "$user"; LOGGED_USER=""; break ;;
            3) exit 0 ;;
            *)
		echo "Invalid option!";;
        esac
    done
}

main_menu
