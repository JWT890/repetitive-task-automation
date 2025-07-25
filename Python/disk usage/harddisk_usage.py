import shutil

def check_hard_disk_usage():
    total, used, free = shutil.disk_usage("/")

    print("Total: %d GiB" % (total // (2**30)))
    print("Used: %d GiB" % (used // (2**30)))
    print("Free: %d GiB" % (free // (2**30)))

    percentage_used = round((used / total) * 100, 2)
    print(f"Percentage used: {percentage_used}%")


if __name__ == "__main__":
    check_hard_disk_usage()