#!/bin/bash

# Clear the terminal
clear

# Banner
echo " ____               __  __                                   "
echo "|  _ \ __ _ ___ ___|  \/  | __ _ _ __   __ _  __ _  ___ _ __ "
echo "| |_) / _\` / __/ __| |\/| |/ _\` | '_ \ / _\` |/ _\` |/ _ \ '__|"
echo "|  __/ (_| \__ \__ \ |  | | (_| | | | | (_| | (_| |  __/ |   "
echo "|_|   \__,_|___/___/_|  |_|\__,_|_| |_|\__,_|\__, |\___|_|   "
echo "                                             |___/           "

# Welcome message
echo "╔════════════════════════════════════════════════════════╗"
echo "║                    Password Manager Tool                  ║"
echo "║                    ---------------------                 ║"
echo "║                        Version: 1.0.0                    ║"
echo "║                  Crafted by Thisizasif                    ║"
echo "║     GitHub: https://github.com/thisizasif/PassManager     ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo "   Welcome to the Password Manager Tool, your secure        "
echo "   solution for managing and safeguarding your passwords.    "
echo "   Explore the options below to enhance your security!       "
echo "------------------------------------------------------------"

# Function to generate a random password
generate_password() {
    local length=$1
    local complexity=$2
    local charset='A-Za-z'

    case $complexity in
        easy)
            ;;
        normal)
            charset+='0-9'
            ;;
        hard)
            charset+='0-9!@#$%^&*()-_=+{}[]|;:,.<>?'
            ;;
        *)
            echo "Invalid complexity level."
            exit 1
            ;;
    esac

    tr -dc "$charset" < /dev/urandom | head -c "$length"
}

# Function to manually enter a password
manual_enter_password() {
    read -p "Enter the desired password: " manual_password

    if [[ -n $manual_password ]]; then
        echo "$manual_password"
    else
        echo "Invalid input. Password cannot be empty."
        exit 1
    fi
}

# Function to display saved passwords
display_saved_passwords() {
    echo "Saved Passwords:"
    cat passwords.txt
    echo
}

# Function to retrieve a saved password by name
retrieve_password() {
    local password_name=$1
    local password=$(grep "^$password_name:" passwords.txt | cut -d ' ' -f 2-)

    if [ -n "$password" ]; then
        echo "Retrieved Password for $password_name: $password"
    else
        echo "Password not found for $password_name."
    fi
}

# Function to update an existing password
update_password() {
    local password_name=$1

    # Check if the password exists
    if grep -q "^$password_name:" passwords.txt; then
        read -p "Enter the new password for $password_name: " new_password

        # Update the password
        sed -i "s/^$password_name:.*/$password_name: $new_password/" passwords.txt
        echo "Password for $password_name updated successfully."
    else
        echo "Password not found for $password_name. Cannot update."
    fi
}

# Function to delete a password by name
delete_password() {
    local password_name=$1

    # Delete the password
    sed -i "/^$password_name:/d" passwords.txt
    echo "Password for $password_name deleted successfully."
}

while true; do
    # Display menu
echo -e "\n\033[1;33;4m======= \033[1;34mMenu\033[1;33;4m =======\033[0m"

echo -e "1. \033[1;36mGenerate Password\033[0m"
echo -e "2. \033[1;36mDisplay Saved Passwords\033[0m"
echo -e "3. \033[1;36mRetrieve Password\033[0m"
echo -e "4. \033[1;36mUpdate Password\033[0m"
echo -e "5. \033[1;36mDelete Password\033[0m"
echo -e "6. \033[1;32mQuit\033[0m"


    # Get user choice
    read -p "Enter your choice (1-6): " choice

    case $choice in
        1)
            # Generate Password
            echo -e "\n\033[1;33;4m======= \033[1;34mGenerate Password\033[1;33;4m =======\033[0m"
echo -e "1. \033[1;36mAuto-generate\033[0m"
echo -e "2. \033[1;36mManually enter\033[0m"

            read -p "Choose an option (1-2): " gen_option

            case $gen_option in
                1)
                    # Auto-generate Password
                    while true; do
                        read -p "Enter the desired password length: " password_length

                        # Validate input
                        if [[ $password_length =~ ^[0-9]+$ ]]; then
                            break
                        else
                            echo "Invalid input. Please enter a valid numeric value for password length."
                        fi
                    done

                    while true; do
                        read -p "Enter the password complexity (easy/normal/hard): " password_complexity

                        # Validate input
                        if [[ $password_complexity =~ ^(easy|normal|hard)$ ]]; then
                            break
                        else
                            echo "Invalid input. Please enter 'easy', 'normal', or 'hard' for password complexity."
                        fi
                    done

                    password=$(generate_password "$password_length" "$password_complexity")

                    # Ask user for a name and save the password
                    while true; do
                        read -p "Enter a name for the password: " password_name

                        # Validate input
                        if [[ -n $password_name ]]; then
                            break
                        else
                            echo "Invalid input. Please enter a name for the password."
                        fi
                    done

                    echo "$password_name: $password" >> passwords.txt
                    echo "Password saved to passwords.txt."
                    ;;
                2)
                    # Manually enter Password
                    password=$(manual_enter_password)

                    # Ask user for a name and save the password
                    while true; do
                        read -p "Enter a name for the password: " password_name

                        # Validate input
                        if [[ -n $password_name ]]; then
                            break
                        else
                            echo "Invalid input. Please enter a name for the password."
                        fi
                    done

                    echo "$password_name: $password" >> passwords.txt
                    echo "Password saved to passwords.txt."
                    ;;
                *)
                    echo "Invalid option. Please choose 1 or 2."
                    exit 1
                    ;;
            esac
            ;;
        2)
            # Display saved passwords
            display_saved_passwords
            ;;
        3)
            # Retrieve Password
            read -p "Enter the name of the password to retrieve: " retrieve_name
            retrieve_password "$retrieve_name"
            ;;
        4)
            # Update Password
            read -p "Enter the name of the password to update: " update_name
            update_password "$update_name"
            ;;
        5)
            # Delete Password
            read -p "Enter the name of the password to delete: " delete_name
            delete_password "$delete_name"
            ;;
        6)
            # Quit
            echo "Exiting the Password Manager Tool. Goodbye!"
            exit 0
            ;;
        *)
            # Invalid choice
            echo "Invalid choice. Please enter a number between 1 and 6."
            ;;
    esac

    # Prompt to continue or exit
    read -p "Do you want to continue (Y/N)? " continue_choice

    if [[ $continue_choice =~ ^[Nn]$ ]]; then
        echo "Exiting the Password Manager Tool. Goodbye!"
        exit 0
    fi

    # Clear the terminal for the next iteration
    clear
done
