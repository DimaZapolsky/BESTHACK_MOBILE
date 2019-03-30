#include <iostream>
#include <fstream>
#include <string>
#include <map>
using namespace std;

int main(int n, char *argv[]) {
    if (n != 2)
        return -1;
    ifstream in_last;
    in_last.open("last_names.all.txt");
    map<string, bool> last_names;
    string s;
    while (in_last >> s) {
        last_names[s] = true;
    }
    bool isLast = static_cast<bool>(last_names.count(argv[2]));
    cout << "Last name: " << isLast << endl;
    return isLast;
}