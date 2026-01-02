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

wait_for_lock() {
    echo "Checking if package manager is available"
    while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 || fuser /var/lib/dpkg/locka > /dev/null 2>&1; do
        echo "Package manager is busy. Waiting..."
        sleep 5
    done
}

check_for_updates() {
    
}

check_linux_system() {
    echo "Checking the Linux system..."
    $DISTRO="$(lsb_release -is)"
    wait_for_lock
    case "$DISTRO" in
        Debian*|Ubuntu*|Kali*)
            sudo apt-get update && sudo apt-get upgrade -y
            ;;
        RHEL*|CentOS*|Oracle*)
            sudo yum update -y
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
    echo "Installing packages..."
    DISTRO="$(lsb_release -is)"
    PACKAGES="vim curl wget"
    case "$DISTRO" in
        Debian*|Ubuntu*|Kali*)
            sudo apt-get install -y
            ;;
        RHEL*|CentOS*|Oracle*)
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
        Debian*|Ubuntu*|Kali*)
            sudo apt-get autoremove -y
            ;;
        RHEL*|CentOS*|Oracle*)
            sudo yum autoremove -y
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