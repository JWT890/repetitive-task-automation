#!/bin/bash


check_disk_usage() {
# checks to see if the script is being run as root
    if [[ $EUID -ne 0 ]]; then
        # if not root, prints it must be run as root
        echo "This script must be run as root" >&2
        exit 1
    fi

    # creates the log file
    LOG_FILE="storage_report.txt"

    # prints to the report file
    echo "-------------------------" >> "${LOG_FILE}"
    # prints to the report file
    echo "Disk Usage Report" >> "${LOG_FILE}"
    # prints to the report file
    echo "-------------------------" >> "${LOG_FILE}"

    # checks disk usage for a specific partition
    # you can change the partition as needed
    PARTITION="/dev/sda1"

    # gets the disk usage from the paritition and the percentage used
    disk_usage=$(df -h | grep "$PARTITION" | awk '{print $5}' | tr -d '%')

    # set to 90 for critical level
    CRITICAL_THRESHOLD=90
    # set to 75 for warning level
    WARNING_THRESHOLD=75

    # checks for if the critical threshold has been met or exceeded
    if [[ $disk_usage -ge $CRITICAL_THRESHOLD ]]; then
        # prints it has and must be addressed and prints to the report file
        echo "CRITICAL: Disk usage on $disk_usage%: Immediate action required!" >> "${LOG_FILE}"
    # checks for if the warning threshold has been met or reached
    elif [[ $disk_usage -ge $WARNING_THRESHOLD ]]; then
        # prints it has and must consider cleaning up resources and prints to the report file
        echo "WARNING: Disk usage on $disk_usage%: Consider cleaning up." >> "${LOG_FILE}"
    else
        # prints that nothing of note needs to be done and prints to the report file
        echo "OK: Disk usage on $disk_usage%." >> "${LOG_FILE}"
    fi
}

# Function to create a log file
create_log_file() {
    LOG_FILE="storage_report.txt"
    # creates the log file
    touch $LOG_FILE
    echo "Log file created successfully"
}

# function to check the memory
check_memory() {
    echo "Memory check option selected"
    # checks to see if the script is being run as root
    if [[ $EUID -ne 0 ]]; then
        # exits out
        echo "This script must be run as root" >&2
        exit 1
    fi

    # generates the memory report
    LOG_FILE1="memory_report.txt"
    echo "-------------------------" >> "${LOG_FILE1}"
    echo "Memory Usage Report" >> "${LOG_FILE1}"
    echo "-------------------------" >> "${LOG_FILE1}"


    # Get memory usage
    total_memory_usage=$(free -m | grep "Mem" | awk '/Mem/{print $2}')
    used_memory_usage=$(free -m | grep "Mem" | awk '/Mem/{print $3}')
    free_memory_usage=$(free -m | grep 'Mem' | awk '/Mem/{print $4}')

    # gets the memory used total
    used_memory_percentage=$(( (used_memory_usage * 100) / total_memory_usage))

    echo "Total Memory: ${total_memory_usage} MB" >> "${LOG_FILE1}"
    echo "Used Memory: ${used_memory_usage} MB" >> "${LOG_FILE1}"
    echo "Free Memory: ${free_memory_usage} MB" >> "${LOG_FILE1}"
    echo "Used Memory Percentage: ${used_memory_percentage}%" >> "${LOG_FILE1}"

    echo "Memory check completed. Report saved to ${LOG_FILE1}"
}

# function to check the network status
network_status() {
    # pings for Google
    if ping -c 1 google.com &> /dev/null; then
        # if internet is working
        echo "Internet connection is active"
    else
        # if not
        echo "Internet connection: Not available"
    fi

    echo "Netowork Interface Information:"
    # shows the ips
    ip addr show
}

# checks for running processes
check_processes() {
    # checks cpu, memory, apps, and terminal for process usage
    processes=$(ps -eo pid,cmd,%cpu,%mem --sort=%cpu)

    #organizes by CPU usage
    echo "Top 10 Processes by CPU Usage:"
    echo "$processes" | head -n 11

    # organizes by high processes
    high_cpu_processes=$(ps -eo pid,cmd,%cpu --sort=-%cpu | awk '$3 > 50 {print $0}')

    # checks for high cpu processes that are running
    if [ -n "$high_cpu_processes" ]; then
        echo "Warning: High CPU Processes Detected:"
        echo "$high_cpu_processes"
    fi

    # organizes by high memory usage
    high_mem_processes=$(ps -eo pid,cmd,%mem --sort=-%mem | awk '$3 > 50 {print $0} ')

    # checks for high mem processes that are running
    if [ -n "$high_mem_processes" ]; then
        echo "Warning: High Memory Processes Detected:"
        echo "$high_mem_processes"
    fi
}

# checks for system updates
check_system_updates() {
    echo " === System Update Script ==="
    # logs the updates
    LOG_FILE='/var/log/system_updates.log'
    # says the update has started and logs the date in the log file
    echo "Update started: $(date)" >> $LOG_FILE
    # detects what operating system is running
    if command -v apt-get &> /dev/null; then
        # Debian/Ubuntu
        apt-get update -y
        apt-get upgrade -y
        apt-get autoremove -y
    # CentOS
    elif command -v yum &> /dev/null; then
        yum update -y
        yum autoremove -y
    # RHEL
    elif command -v dnf &> /dev/null; then
        dnf upgrade -y
        dnf autoremove -y
    fi
    # prints the update has completed and logs to the file
    echo "Update completed: $(date)" >> $LOG_FILE
    echo "System updated sucessfully!"
}

# checks the systemctl status of a service
check_systemctl_status() {
    # takes user input for the service name
    echo "Enter the name of the service:"
    read -r service_name

    # checks the status of it
    echo "Checking status of $service_Name..."
    if ! command -v systemctl &> /dev/null; then
        # prints error if systemctl is not found
        echo "Error: systemctl command not found" >&2
        return 1
    fi

    # checks if the service is running
    local status=$(systemctl is-active --quiet "$service_name")
    # if active
    if [[ status == "active" ]]; then
        # prints that the service is running 
        echo "$service_name is running. no need to restart"
        systemctl status "$service_name"
    else
        # if not running, attempts to restart
        echo "$service_name is not running. attempting to restart"
        systemctl restart "$service_name"
    fi
}

# runs a option to choose option wanting to check from the user input
OPTIONS=("Check Disk Usage" "Create log file" "Check Memory" "Network Monitoring" "Processes Check" "System Update Check" "Systemctl Status" "Exit")
select choice in "${OPTIONS[@]}"
do
    case $choice in 
        "Check Disk Usage")
            check_disk_usage
            break
            ;;
        "Create log file")
            create_log_file
            break
            ;;
        "Check Memory")
            check_memory
            break
            ;;
        "Network Monitoring")
            network_status
            break
            ;;
        "Processes Check")
            check_processes
            break
            ;;
        "System Update Check")
            check_system_updates
            break
            ;;
        "Systemctl Status")
            check_systemctl_status
            break
            ;;
        "Exit")
            echo "Exiting the script."
            exit 0
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
done