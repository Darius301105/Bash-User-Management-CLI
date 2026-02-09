#!/bin/bash

USER="$1"
USERS_CSV="users.csv"

i=2 
max=$(wc -l < "$USERS_CSV")

found=0
while [ $i -le $max ]; do
    LINE=$(sed -n "${i}p" "$USERS_CSV")
    aux1=$(echo "$LINE" | cut -d',' -f2)
    aux=$'\n'"$aux1"
    if [[ "$aux" == "$USER" ]]; then
	HOMEDIR=$(echo "$LINE" | cut -d',' -f5)
        echo "Raportul se genereaza in $HOMEDIR!"
        found=1
        break
    fi
    ((i++))
done

if [ $found -eq 0 ]; then
    echo "Userul $USER nu a fost găsit!"
fi

REPORT="$HOMEDIR/raport_$(date +%Y%m%d%H%M%S).txt"

num_files=$(find "$HOMEDIR" -type f | wc -l)
num_dirs=$(find "$HOMEDIR" -type d | wc -l)
disk_size=$(du -sh "$HOMEDIR" | cut -f1)

{
echo "Raport utilizator: $USER"
echo "Numar fisiere: $num_files"
echo "Numar directoare: $num_dirs"
echo "Dimensiune pe disc: $disk_size"
} > "$REPORT" 

echo "Raportul a fost generat in $REPORT"
exit 0
