#!/bin/bash

USERS_CSV="users.csv"
HOMES_DIR="homes"

read -p "Nume utilizator: " username

if grep -q ",$username," "$USERS_CSV"; then
    echo "Utilizatorul deja exista!"
    exit 1
fi

read -p "Email: " email
if ! echo "$email" | grep -Eq "^[^@]+@[^@]+\.[a-z]{2,}$"; then
    echo "Email-ul este invalid!"
    exit 2
fi

echo "Parola trebuie sa aiba minim 6 caractere si sa contina litere si cifre!"
while [[ ${#password} -lt 6 || ! $password =~ [0-9] || ! $password =~ [A-Za-z] || ! "$password" == "$password2" ]]; do
read -s -p "Parola: " password; echo
read -s -p "Confirmare parola: " password2; echo
if [ "$password" != "$password2" ]; then
	echo "Boss, parolele nu coincid! Mai incearca o data:";
fi
if [[ ! $password =~ [0-9] ]]; then
	echo "Parola nu contine cifre! Mai citeste o data cu atentie mesajul de mai sus!"
fi
if [[ ! $password =~ [A-Za-z] ]]; then
	echo "Sefu, parola ta nu contine litere! Te rog fii mai atent data viitoare!"
fi
if [ ${#password} -lt 6 ]; then
	echo "Parola are mai putin de 6 caractere! Iti mai dau o sansa!"
fi
done

HASH=$(echo "$password" | sha256sum | cut -d' ' -f1)
ID=$(date +%s%N | cut -b1-10) 
HOMEDIR="$HOMES_DIR/$username"

mkdir -p "$HOMEDIR"

echo "$ID,$username,$email,$HASH,$HOMEDIR," >> "$USERS_CSV"

echo "Contul $username a fost creat cu succes. Email de confirmare trimis la $email!"
echo "Inregistrarea a fost realizata cu succes!" | mail -s "Confirmare inregistrare" "$email" 

exit 0
