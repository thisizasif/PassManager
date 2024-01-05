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
    echo "Crafted by Thisizasif                                      "
    echo "Password Manager Tool                                       "

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

    while true; do
        # Display menu
        echo "Menu:"
        echo "1. Generate Password"
        echo "3. Display Saved Passwords"
        echo "4. Retrieve Password"
        echo "5. Quit"
       # echo "2. Save Password"

        # Get user choice
        read -p "Enter your choice (1-5): " choice

        case $choice in
            1)
                # Generate Password
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

                echo "Generated Password: $password"

                # Ask user for a name and whether to save the password
                while true; do
                    read -p "Enter a name for the password: " password_name

                    # Validate input
                    if [[ -n $password_name ]]; then
                        break
                    else
                        echo "Invalid input. Please enter a name for the password."
                    fi
                done

                while true; do
                    read -p "Do you want to save this password (y/n)? " save_choice

                    # Validate input
                    if [[ $save_choice =~ ^[YyNn]$ ]]; then
                        break
                    else
                        echo "Invalid input. Please enter 'y' or 'n'."
                    fi
                done

                if [[ $save_choice =~ ^[Yy]$ ]]; then
                    echo "$password_name: $password" >> passwords.txt
                    echo "Password saved to passwords.txt."
                else
                    echo "Password not saved."
                fi
                ;;
            2)
                # Save Password
                while true; do
                    read -p "Enter a name for the password (Press Enter to skip): " password_name

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
            3)
                # Display saved passwords
                display_saved_passwords
                ;;
            4)
                # Retrieve Password
                while true; do
                    read -p "Enter the name of the password to retrieve: " retrieve_name

                    # Validate input
                    if [[ -n $retrieve_name ]]; then
                        break
                    else
                        echo "Invalid input. Please enter a name for the password."
                    fi
                done

                retrieve_password "$retrieve_name"
                ;;
            5)
                # Quit
                echo "Exiting the Password Generator. Goodbye!"
                exit 0
                ;;
            *)
                # Invalid choice
                echo "Invalid choice. Please enter a number between 1 and 5."
                ;;
        esac

        # Prompt to continue or exit
        while true; do
            read -p "Do you want to continue (Y/N)? " continue_choice

            # Validate input
            if [[ $continue_choice =~ ^[YyNn]$ ]]; then
                break
            else
                echo "Invalid input. Please enter 'y' or 'n'."
            fi
        done

        if [[ $continue_choice =~ ^[Nn]$ ]]; then
            echo "Exiting the Password Generator. Goodbye!"
            exit 0
        fi

        # Clear the terminal for the next iteration
        clear
    done
