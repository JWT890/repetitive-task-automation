# repetitive-task-automation

Collection of scripts in Bash, Python, JavaScript and C++ to automate every day tasks that are repetitive

Linux:
Task_Bash.sh (so far):  
root-level, menu-driven system monitoring utility for Linux environments. It performs disk, memory, network, and process checks, applying threshold-based alerts and generating log-based reports. The script leverages standard system tools (df, free, ps, ip, ping) to provide quick operational visibility and basic health monitoring.  

Python:  
HardDisk_Usage.py:  
This Python script uses the shutil module to retrieve total, used, and free disk space for the root filesystem. It converts raw byte values into human-readable gigabytes and calculates overall disk utilization as a percentage. The script provides a simple, platform-independent method for assessing disk usage at runtime.  
Disk_Usage.py:  
This Python script implements a multi-threaded system monitoring tool that continuously tracks CPU, memory, disk, network, and GPU utilization. It uses psutil and GPUtil to collect real-time metrics, applies threshold-based alerts for resource saturation, and presents GPU statistics in a structured tabular format. Concurrent threads allow system and GPU monitoring to run simultaneously, providing near real-time visibility into overall system performance.  
Excel_Auto.py: work in progress

JavaScript:  
Patch Monitor Status Static:  
Checks to see if patched systems are up to date and compliant or not.  

C++:  

