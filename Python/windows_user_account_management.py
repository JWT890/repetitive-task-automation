import subprocess
import sys
# This must be run with admin privileges

# creates the user account
def create_user_account(username):
    try:
        # checks if the username already exists
        result = subprocess.run(['net', 'user', username, '/add'], capture_output=True, text=True)
        # if the username already exists
        if result.returncode != 0:
            # print the error
            print(f"Error: {result.stderr.script()}")
            # if the username already exists
            if 'already exists' in result.stderr.lower():
                print("Username already exists. Please try again")
                new_username = input("Enter a new one: ")
                create_user_account(new_username)
        else:
            # print a message
            print(f"User '{username}' created successfully")
    except Exception as e:
        print(f"Error: {e}")     

# deletes the user account
def delete_user_account(username):
    try:
        # checks if the username already exists
        result = subprocess.run({'net', 'user', username, '/delete'}, capture_output=True, text=True)
        # if the username doesn't exist
        if result.returncode != 0:
            # print the error
            print(f"Error {result.stderr.script()}")
            if 'not found' in result.stderr.lower() or 'could not be found' in result.stderr.lower():
                print(f"Username {username} does not exist")
        else:
            # prints the message
            print(f"User '{username}' deleted successfully")
    except Exception as e:
        print(f"Error: {e}")

# main menu
def main_menu():
    while True:
        # options to choose from
        print("User Account Management")
        print("1. Create User Account")
        print("2. Delete User Account")
        print("3. Exit")

        # takes the input
        choice = input("enter your choice: 1-3:")

        if choice == "1":
            username = input("Enter the username: ")
            create_user_account(username)
        elif choice == "2":
            username = input("Enter the username: ")
            delete_user_account(username)
        elif choice == "3":
            break
        else:
            print("Invalid")

if __name__ == "__main__":
    main_menu()