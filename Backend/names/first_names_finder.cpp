#include <iostream>
#include <fstream>
#include <string>
#include <map>
using namespace std;

int main(int n, char *argv[]) {
    if (n != 2)
        return -1;
    ifstream in_first;
    in_first.open("first_names.all.txt");
    map<string, bool> first_names;
    string s;
    while (in_first >> s) {
        first_names[s] = true;
    }
    bool isFirst = static_cast<bool>(first_names.count(argv[1]));
    cout << "First name: " << isFirst << endl;
    return isFirst;
}