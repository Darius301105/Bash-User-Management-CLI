#!/bin/bash
# Authenticates a user. On success, updates LastLogin and prints the username for the caller.

USERS_CSV="users.csv"

read -p "Username: " username

if ! grep -q ",$username," "$USERS_CSV"; then
    echo "This user does not exist!"
    exit 1
fi

# Hash the entered password and compare it with the stored hash
read -sp "Password: " password; echo >&2
HASH=$(echo "$password" | sha256sum | cut -d' ' -f1)

LINE=$(grep ",$username," "$USERS_CSV")
CSV_HASH=$(echo "$LINE" | cut -d',' -f4)

if [ "$HASH" == "$CSV_HASH" ]; then
    # Update the LastLogin field (6th column) for this user
    now=$(date '+%Y-%m-%d_%H:%M:%S')
    sed -i "/^.*,$username,.*$/ s/\(,$username,[^,]*,[^,]*,[^,]*,\)[^,]*/\1$now/" "$USERS_CSV"
    HOMEDIR=$(echo "$LINE" | cut -d',' -f5)
    printf "%s" "$username"
    exit 0
else
    read -p "Wrong password! Press ENTER to continue." temp
    exit 2
fi
