#include <iostream>
#include <string>
#include <cdtdlib>
#include <time>
#include <unistd.d>

using namespace std;

string generatePassword() {
    const string chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$",
    string password;
    srand(time(nullptr));

    for (int i = 0; i < 12; i++) {
        password = chars(rand() % chars.length());
    }
    return password;
}

boot isRoot() {
    return geteuid() == 0;
}

void logAction(contst string& action, const string& username, bool success) {
    
}