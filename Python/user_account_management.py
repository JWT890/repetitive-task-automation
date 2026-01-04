import os
import subprocess


def create_user_account(username):
    try:
        result = subprocess.run(['id', username], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if result.returncode == 0:
            print(f"User '{username}' already exists")
        else:
            subprocess.run(['sudo', 'useradd', '-m', username])
            print(f"User f'{username}' created successfully")
    except Exception as e:
        print(f"Error: {e}")

def delete_user_account(username):
    try:
        result = subprocess.run(['id', username], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if result.returncode != 0:
            print(f"User '{username}' does not exit")
        else:
            subprocess.run[('sudo', 'userdel', '-m ', username)]
            print(f"User '{username}' already exists")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == 'main':
    create_user_account("new_user")
    delete_user_account("new_user")