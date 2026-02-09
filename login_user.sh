#!/bin/bash

USERS_CSV="users.csv"

read -p "Nume utilizator: " username

if ! grep -q ",$username," "$USERS_CSV"; then
    echo "Utilizatorul nu exista!"
    exit 1
fi

read -sp "Parola: " password; echo
HASH=$(echo "$password" | sha256sum | cut -d' ' -f1)

LINE=$(grep ",$username," "$USERS_CSV")
CSV_HASH=$(echo "$LINE" | cut -d',' -f4)

if [ "$HASH" == "$CSV_HASH" ]; then
    now=$(date '+%Y-%m-%d_%H:%M:%S')
    sed -i "/^.*,$username,.*$/ s/\(,$username,[^,]*,[^,]*,[^,]*,\)[^,]*/\1$now/" "$USERS_CSV"
    HOMEDIR=$(echo "$LINE" | cut -d',' -f5)
    printf "%s" "$username"
    exit 0 
else
    read -p " Boss, ai gresit parola! Da-i un ENTER ca sa mergi mai departe" temp
    exit 2
fi
