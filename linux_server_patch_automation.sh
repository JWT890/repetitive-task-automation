#!/bin/bash

LOG_FILE='/var/log/system_updates.log'

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" >&2
    exit 1
fi

if [ ! -f "$LOG_FILE" ]; then
    sudo touch "$LOG_FILE"
    chmod 644 "$LOG_FILE"
fi

echo "Starting..." >> "$LOG_FILE"

check_linux_system() {
    echo "Checking the Linux system..."
    case "$DISTRO" in
        Debian*)
            sudo apt-get update -y
            sudo apt-get upgrade -y
            ;;
        CentOS*)
            sudo apt-get update -y
            sudo apt-get upgrade -y
            ;;
        Ubuntu*)
            sudo apt-get update -y
            sudo apt-get upgrade -y
            ;;
        RHEL*)
            sudo yum update -y
            ;;
        Oracle*)
            sudo apt-get update -y
            sudo apt-get upgrade -y
            ;;
        Kali*)
            sudo apt-get update -y
            sudo apt-get upgrade -y
            ;;
        *)
            echo "Unsupported distro: $DISTRO"
            return
            ;;
    esac
    echo "Updates installed successfully"
    echo "Update completed: $(date)" >> $LOG_FILE
}

install_packages() {
    LOG_FILE='/var/log/system_updates.log'
    echo "Installing packages..."
    DISTRO="$(lsb_release -is)"
    case "$DISTRO" in
        Debian*)
            sudo apt-get install -y 
            ;;
        Ubuntu*)
            sudo apt-get install -y
            ;;
        CentOS*)
            sudo apt-get install -y
            ;;
        Oracle*)
            sudo apt-get install -y
            ;;
        Kali*)
            sudo apt-get install -y
            ;;
        RHEL*)
            sudo yum install -y
            ;;
        *)
            echo "Unsupported. Skipping"
            return
            ;;
    esac
    echo "Packages installed sucessfully"
    echo "Installation completed: $(date)" >> "$LOG_FILE"
}
remove_packages() {
    echo "Checking for packages to remove..."
    DISTRO="$(lsb_release -is)"
    case "$DISTRO" in
        Debian*)
            sudo apt autoremove -y
            ;;
        Ubuntu*)
            sudo apt autoremove -y
            ;;
        RHEL*)
            sudo yum autoremove -y
            ;;
        CentOS*)
            sudo apt autoremove -y
            ;;
        Oracle*)
            sudo apt autoremove -y
            ;;
        Kali*)
            sudo apt autoremove -y
            ;;
        *)
            echo "Unsupported. Skipping"
            return
            ;;
    esac
    echo "Unused packages removed successfully"
    echo "Completed: $(date)" >> "$LOG_FILE"
}

echo "Starting patch automation script..."
OPTIONS=("Check Linux System" "Install Packages" "Remove Packages" "Exit")
select choice in "${OPTIONS[@]}"
do
    case $choice in
        "Check Linux System")
            check_linux_system
            break
            ;;
        "Install Packages")
            install_packages
            break
            ;;
        "Remove Packages")
            remove_packages
            break
            ;;
        "Exit")
            echo "Exiting the script"
            exit 0
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
done