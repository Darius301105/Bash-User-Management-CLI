# Bash User Management System

A small **Bash-based CLI application** that simulates a basic **user management system**.  
The project provides functionality for **user registration**, **login**, **logout**, and **user report generation**, using CSV files and local directories for persistence.

---

## Features

### 🔐 User Registration (`register_user.sh`)
- Prompts for username, email, and password
- Checks if the user already exists in `users.csv`
- Email validation using regex
- Password validation:
  - minimum 6 characters
  - must contain letters and numbers
  - password confirmation required
- Password hashing using **SHA-256**
- Automatically creates a home directory for the user
- Sends a confirmation email (optional, requires `mail` configuration)

---

### 🔑 User Login (`login_user.sh`)
- Verifies if the username exists
- Hashes the entered password and compares it with the stored hash
- Updates the `LastLogin` field
- Returns the logged-in username to the main script

---

### 🚪 User Logout (`logout_user.sh`)
- Receives the username as an argument
- Displays a logout confirmation message

---

### 📊 User Report Generation (`generate_user.sh`)
- Receives the username as an argument
- Locates the user's home directory
- Generates a `.txt` report containing:
  - number of files
  - number of directories
  - total disk usage
- Saves the report inside the user's home directory

---

### 🧭 Interactive Menu (`user_management.sh`)
- Main menu:
  - Register new user
  - Login
  - Exit
- User menu (after login):
  - Generate user report
  - Logout
  - Exit
