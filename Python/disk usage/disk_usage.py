import psutil
import time
import logging
import GPUtil
from tabulate import tabulate
import threading

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

# Function to check GPU usage
def check_GPU():
    while True:
        # checks for GPU usage and prints the details
        print("=" * 50, "GPU Details", "=" * 50)

        gpus = GPUtil.getGPUs()
        # list the details
        list_gpus = []

        # loops through each GPU and collects its details
        for gpu in gpus:
            # collects the ID
            gpu_id = gpu.id
            # collects the name, load, memory details, temperature, and UUID
            # and appends them to the list
            gpu_name = gpu.name
            gpu_load = f"{gpu.load*100}%"
            gpu_memory_free = f"{gpu.memoryFree}MB"
            gpu_used_memory = f"{gpu.memoryUsed}MB"
            gpu_total_memory = f"{gpu.memoryTotal}MB"
            gpu_temperature = f"{gpu.temperature}°C"
            gpu_uuid = gpu.uuid
            list_gpus.append((
                gpu_id, gpu_name, gpu_load, gpu_memory_free,
                gpu_used_memory, gpu_total_memory, gpu_temperature, gpu_uuid
            ))

            # prints the details
            print(tabulate(list_gpus, headers=(
                "ID", "Name", "Load", "Free Memory", "Used Memory", "Total Memory", "Temperature", "UUID")))
        
        print("=" * 50)
        time.sleep(5)


if __name__ == "__main__":
    # Create threads for monitoring system and checking GPU so they can run at once
    t1 = threading.Thread(target=monitor_system, daemon=True)
    t2 = threading.Thread(target=check_GPU, daemon=True)

    t1.start()
    t2.start()

    t1.join()
    t2.join()

    t1.end()
    t2.end()
    print("Monitoring stopped.")
    