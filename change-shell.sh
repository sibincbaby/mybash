#!/bin/bash

# Check if /etc/shells file exists
if [ ! -f /etc/shells ]; then
    echo "Error: /etc/shells file not found."
    exit 1
fi

# Read available shells from /etc/shells and remove duplicates
available_shells=$(grep -E '/(bash|zsh|sh|fish|your_additional_shells_here)' /etc/shells | grep -v "^#" | grep '^/usr/bin/' | sort -u)

# Check if there are any available shells
if [ -z "$available_shells" ]; then
    echo "No available shells found in /etc/shells."
    exit 1
fi

# Display available shells with numbers
echo "Available Shells:"
count=1
echo "$available_shells" | while read -r shell; do
    echo "$count. $shell"
    ((count++))
done

# Prompt the user to select a shell
read -p "Select a shell (enter the number): " choice

# Validate user input
if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
    echo "Invalid input. Please enter a number. Exiting."
    exit 1
fi

# Get the selected shell based on the user's choice
selected_shell=$(echo "$available_shells" | sed -n "${choice}p")

# Check if the selected shell is valid
if [ -z "$selected_shell" ]; then
    echo "Invalid selection. Exiting."
    exit 1
fi

# Change the default shell
chsh -s "$selected_shell"

echo "Default shell changed to $selected_shell."

# Prompt to reboot
read -p "Do you want to reboot to apply the changes? (Y/N): " reboot_choice
if [ "$reboot_choice" == "Y" ] || [ "$reboot_choice" == "y" ]; then
    echo "Rebooting..."
    sudo reboot
else
    echo "You may need to restart your terminal or log out and log back in for the changes to take effect."
fi
