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

check_memory() {
    echo "Memory check option selected"
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root" >&2
        exit 1
    fi

    LOG_FILE1="memory_report.txt"
    echo "-------------------------" >> "${LOG_FILE1}"
    echo "Memory Usage Report" >> "${LOG_FILE1}"
    echo "-------------------------" >> "${LOG_FILE1}"


    # Get memory usage
    total_memory_usage=$(free -m | grep "Mem" | awk '/Mem/{print $2}')
    used_memory_usage=$(free -m | grep "Mem" | awk '/Mem/{print $3}')
    free_memory_usage=$(free -m | grep 'Mem' | awk '/Mem/{print $4}')

    used_memory_percentage=$(( (used_memory_usage * 100) / total_memory_usage))

    echo "Total Memory: ${total_memory_usage} MB" >> "${LOG_FILE1}"
    echo "Used Memory: ${used_memory_usage} MB" >> "${LOG_FILE1}"
    echo "Free Memory: ${free_memory_usage} MB" >> "${LOG_FILE1}"
    echo "Used Memory Percentage: ${used_memory_percentage}%" >> "${LOG_FILE1}"

    echo "Memory check completed. Report saved to ${LOG_FILE1}"
}

network_status() {
    if ping -c 1 google.com &> /dev/null; then
        echo "Internet connection is active"
    else
        echo "Internet connection: Not available"
    fi

    echo "Netowork Interface Information:"
    ip addr show
}

check_processes() {
    processes=$(ps -eo pid, cmd, %cpu, %mem --sort=%cpu)

    echo "Top 10 Processes by CPU Usage:"
    echo "$processes" | head -n 11

    high_cpu_processes=$(ps -eo pid, cmd,%cpu --sort=-%cpu | awk '$3 > 50 {print $0}')

    if [ -n "$high_cpu_processes" ]; then
        echo "Warning: High CPU Processes Detected:"
        echo "$high_cpu_processes"
    fi

    high_mem_processes=$(ps -eo pid,cmc,%mem --sort=-%mem | awk '$3 > 50 {print $0} ')

    if [ -n "$high_mem_processes" ]; then
        echo "Warning: High Memory Processes Detected:"
        echo "$high_mem_processes"
}

OPTIONS=("Check Disk Usage" "Create log file" "Check Memory" "Network Monitoring" "Processes Check" "Exit")
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
        "Exit")
            echo "Exiting the script."
            exit 0
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
done