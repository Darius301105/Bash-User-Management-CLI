#!/bin/bash
# Registers a new user: validates the input, hashes the password and creates a home directory.

USERS_CSV="users.csv"
HOMES_DIR="homes"

read -p "Username: " username

# Usernames must be unique
if grep -q ",$username," "$USERS_CSV"; then
    echo "This user already exists!"
    exit 1
fi

# Basic email format validation
read -p "Email: " email
if ! echo "$email" | grep -Eq "^[^@]+@[^@]+\.[a-z]{2,}$"; then
    echo "Invalid email address!"
    exit 2
fi

# Keep asking until the password is valid and confirmed
echo "The password must have at least 6 characters and contain both letters and digits."
while [[ ${#password} -lt 6 || ! $password =~ [0-9] || ! $password =~ [A-Za-z] || ! "$password" == "$password2" ]]; do
read -s -p "Password: " password; echo
read -s -p "Confirm password: " password2; echo
if [ "$password" != "$password2" ]; then
	echo "The passwords do not match. Please try again."
fi
if [[ ! $password =~ [0-9] ]]; then
	echo "The password must contain at least one digit."
fi
if [[ ! $password =~ [A-Za-z] ]]; then
	echo "The password must contain at least one letter."
fi
if [ ${#password} -lt 6 ]; then
	echo "The password must be at least 6 characters long."
fi
done

# Store only the SHA-256 hash of the password, never the plain text
HASH=$(echo "$password" | sha256sum | cut -d' ' -f1)
ID=$(date +%s%N | cut -b1-10)
HOMEDIR="$HOMES_DIR/$username"

mkdir -p "$HOMEDIR"

echo "$ID,$username,$email,$HASH,$HOMEDIR," >> "$USERS_CSV"

echo "Account $username was created successfully. A confirmation email was sent to $email."
# Requires a configured mail command
echo "Your registration was completed successfully!" | mail -s "Registration confirmation" "$email"

exit 0
