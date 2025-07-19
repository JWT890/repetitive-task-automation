import psutil
import time
import logging

# checks logging based on the time for the file
# This script monitors system resources and logs the usage statistics.
logging.basicConfig(filename='disk_usage.log', level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# function to check log usage
def monitor_system():
    while True:
        
        # checks for CPU usage every second
        cpu_usage = psutil.cpu_percent(interval=1)
        # prints the Usage %
        print(f"CPU Usage: {cpu_usage}%")
        # if the usage is above 85% it will print an alert
        if cpu_usage > 85:
            print("ALERT: CPU usage is above 85!")
        else:
            print("Nothing to report")

        # checks for memory usage
        memory = psutil.virtual_memory()

        # prints the Memory usage %
        print(f"Memory Usage: {memory.percent}%")
        # if the usage is above 90% it will print an alert
        if memory.percent > 90:
            print("ALERT: Memory usage is above 90%!")
        else:
            print("Nothing to report")

        # checks for disk usage and prints the usage %
        disk_usage = psutil.disk_usage('/')

        # prints the Disk usage %
        print(f"Disk Usage: {disk_usage.percent}%")

        # if the usage is above 90% it will print an alert
        if disk_usage.percent > 90:
            print("ALERT: Disk usage is above 90%!")
        else:
            print("Nothing to report")

        # checks for network usage and prints the received and sent bytes
        network = psutil.net_io_counters()

        # prints the Network usage
        print(f"Network Usage: {network.bytes_recv} bytes received, {network.bytes_sent} bytes sent")

        print("-" * 50)

        time.sleep(5)

if __name__ == "__main__":
    monitor_system()