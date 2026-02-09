#!/bin/bash

USERS_CSV="users.csv"
HOMES_DIR="homes"
LOGGED_USER=""

[ -d "$HOMES_DIR" ] || mkdir "$HOMES_DIR"
[ -f "$USERS_CSV" ] || echo "ID,Nume,Email,Hash,HomeDir,LastLogin" > "$USERS_CSV"

function main_menu() {
    while true; do
        echo "----- MENIU PRINCIPAL -----"
        echo "1. Inregistrare utilizator nou"
        echo "2. Autentificare"
        echo "3. Iesire"
        read -p "Alege optiunea: " opt
        case $opt in
            1) ./register_user.sh ;;
            2) 
		USER=$(./login_user.sh)
		echo "$USER"
                if [[ $? -eq 0 && ! -z "$USER" ]]; then
		    LOGGED_USER="$USER"
                    user_menu "$LOGGED_USER"

                fi
                ;;
            3) echo "La revedere!"; exit 0 ;;
            *) echo "Optiune invalida!";;
        esac
    done
}

function user_menu() {
    local user=$1
    clear
    echo "-----------------------------------------"
    echo " $user, bine ai venit, rau ai nimerit!"
    echo ""
    echo "-----------------------------------------"
    while true; do
        echo "----- MENIU UTILIZATOR -----"
        echo "1. Genereaza raport"
        echo "2. Logout"
        echo "3. Iesire"
        read -p "Alege optiunea: " opt
        case $opt in
            1) ./generate_report.sh "$user" ;;
            2) ./logout_user.sh "$user"; LOGGED_USER=""; break ;;
            3) exit 0 ;;
            *) 
		echo "Optiune invalida!";;
        esac
    done
}

main_menu
