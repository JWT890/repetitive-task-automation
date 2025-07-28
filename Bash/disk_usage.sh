#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" >&2
    exit 1
fi

LOG_FILE= storage_report.txt

echo "-------------------------" >> $LOG_FILE
echo "Disk Usage Report" >> $LOG_FILE
echo "-------------------------" >> $LOG_FILE

PARTITION="/dev/sda1"

disk_usage = $(df -h | grep "$PARTITION" | awk '{print $5}' | tr -d '%')

CRITICAL_THRESHOLD=90
WARNING_THRESHOLD=75

if [[ $DISK_USAGE -ge $CRITICAL_THRESHOLD ]]; then
    echo "CRITICAL: Disk usage on $disk_usage%! Immediate action required!" >> $LOG_FILE
elif [[ $DISK_USAGE -ge $WARNING_THRESHOLD ]]; then
    echo "WARNING: Disk usage on $disk_usage%! Consider cleaning up." >> $LOG_FILE
else
    echo "OK: Disk usage on $disk_usage%." >> $LOG_FILE
fi