#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" >&2
    exit 1
fi

check_linux_system() {
    $LOG_FILE='/var/log/system_updates.log'
    echo "Checking the Linux system..."
    case "$(lsb_release -is | tr -s ' ' | cut -d ' ' -f2)" in
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
        *)
            echo  "Unsupported distro. Skipping"
    esac
    echo "Updates installed successfully"
    echo "Update completed: $(date)" >> $LOG_FILE
}

install_packages() {
    $LOG_FILE='/var/log/system_updates.log'
    echo "Installing packages..."
    case "$(lsb_release -is | tr -s ' ' | cut -d ' ' -f2)" in
        Debian*)
            sudo apt-get install -y 
            ;;
        Ubuntu*)
            sudo apt-get install -y
            ;;
        CentOS*)
            sudo apt-get install -y
            ;;
        RHEL*)
            sudo yum install -y
            ;;
        *)
            echo "Unsupported. Skipping"
    esac
    echo "Packages installed sucessfully"
    echo "Installation completed: $(date)" >> $LOG_FILE
}
remove_packages() {
    
}