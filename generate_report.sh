#!/bin/bash
# Generates a report (file count, directory count, disk usage) for a user's home directory.

USER="$1"
USERS_CSV="users.csv"

# Start from line 2 to skip the CSV header
i=2
max=$(wc -l < "$USERS_CSV")

# Find the user's line in the CSV to get their home directory
found=0
while [ $i -le $max ]; do
    LINE=$(sed -n "${i}p" "$USERS_CSV")
    aux1=$(echo "$LINE" | cut -d',' -f2)
    if [[ "$aux1" == "$USER" ]]; then
	HOMEDIR=$(echo "$LINE" | cut -d',' -f5)
        echo "Generating the report in $HOMEDIR..."
        found=1
        break
    fi
    ((i++))
done

if [ $found -eq 0 ]; then
    echo "User $USER was not found!"
fi

REPORT="$HOMEDIR/report_$(date +%Y%m%d%H%M%S).txt"

num_files=$(find "$HOMEDIR" -type f | wc -l)
num_dirs=$(find "$HOMEDIR" -type d | wc -l)
disk_size=$(du -sh "$HOMEDIR" | cut -f1)

{
echo "User report: $USER"
echo "Number of files: $num_files"
echo "Number of directories: $num_dirs"
echo "Disk usage: $disk_size"
} > "$REPORT"

echo "The report was generated at $REPORT"
exit 0
