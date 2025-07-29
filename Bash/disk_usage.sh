#!/bin/bash

# checks to see if the script is being run as root
if [[ $EUID -ne 0 ]]; then
    # if not root, prints it must be run as root
    echo "This script must be run as root" >&2
    exit 1
fi

# creates the log file
LOG_FILE= "storage_report.txt"

# prints to the report file
echo "-------------------------" >> $LOG_FILE
# prints to the report file
echo "Disk Usage Report" >> $LOG_FILE
# prints to the report file
echo "-------------------------" >> $LOG_FILE

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
if [[ $DISK_USAGE -ge $CRITICAL_THRESHOLD ]]; then
    # prints it has and must be addressed and prints to the report file
    echo "CRITICAL: Disk usage on $disk_usage%: Immediate action required!" >> $LOG_FILE
# checks for if the warning threshold has been met or reached
elif [[ $DISK_USAGE -ge $WARNING_THRESHOLD ]]; then
    # prints it has and must consider cleaning up resources and prints to the report file
    echo "WARNING: Disk usage on $disk_usage%: Consider cleaning up." >> $LOG_FILE
else
    # prints that nothing of note needs to be done and prints to the report file
    echo "OK: Disk usage on $disk_usage%." >> $LOG_FILE
fi