//
//  Card.cpp
//  Backend
//
//  Created by Dima Zapolsky on 30/03/2019.
//  Copyright © 2019 Dima Zapolsky. All rights reserved.
//

#include "Card.hpp"
#include <iostream>
#include <cmath>
#include <set>

const int INF = 1e9;

int sqr(int x) {
    return x * x;
}

bool onlyDigits(string s) {
    for (int i = 0; i < s.size(); ++i) {
        if (s[i] != '/' && (s[i] < '0' || s[i] > '9'))
            return false;
    }
    return true;
}

void tolower(string & s) {
    for (auto & c : s) {
        c = tolower(c);
    }
}

bool onlyLetters(string s) {
    tolower(s);
    for (int i = 0; i < s.size(); ++i) {
        if (s[i] < 'a' || s[i] > 'z') {
            return false;
        }
    }
    return true;
}

string leaveOnlyDigits(string s) {
    string ans;
    for (auto c : s) {
        if (c >= '0' && c <= '9') {
            ans.push_back(c);
        }
    }
    return ans;
}

int getDist(string a, string b) {
    tolower(a);
    tolower(b);
    if (!onlyLetters(a) || !onlyLetters(b)) {
        return INF;
    }
    vector <int> cnta(26);
    vector <int> cntb(26);
    for (int i = 0; i < a.size(); ++i) {
        cnta[a[i] - 'a']++;
    }
    for (int i = 0; i < b.size(); ++i) {
        cntb[b[i] - 'a']++;
    }
    int ans = 0;
    for (int i = 0; i < 26; ++i) {
        ans += cnta[i] + cntb[i] - 2 * min(cnta[i], cntb[i]);
    }
    return ans;
}

map <char, string> pos_digits = {{'b', "6"}, {'S', "5"}, {'s', "5"}, {'I', "1"}, {'i', "1"}, {'l', "1"}, {'o', "0"}, {'O', "0"}, {'Q', "0"}};

set <string> small_symbols = {"/", "I", "i", "l"};

Card::Card(json boxesJSON) {
    vector <json> boxes;
    for (auto box : boxesJSON) {
        boxes.push_back(box);
    }
    bool flag = true;

    while (flag) {
        flag = false;
        vector <pair <pair <int, int>, double> > best;
        for (int i = 0; i < boxes.size(); ++i) {
            for (int j = i + 1; j < boxes.size(); ++j) {
                double min_w = min((int)boxes[i]["x2"] - (int)boxes[i]["x1"], (int)boxes[j]["x2"] - (int)boxes[j]["x1"]);
                double min_h = min((int)boxes[i]["y2"] - (int)boxes[i]["y1"], (int)boxes[j]["y2"] - (int)boxes[j]["y1"]);
                if (small_symbols.count((string)boxes[i]["str"]) || small_symbols.count((string)boxes[j]["str"]))
                    min_w *= 3;
                else
                    min_w = (min_w * 3) / 2;
                if (min(abs((int)boxes[i]["x2"] - (int)boxes[j]["x1"]), abs((int)boxes[i]["x1"] - (int)boxes[j]["x2"])) <= min_w / 1) {
                    if (max(abs((int)boxes[i]["y2"] - (int)boxes[j]["y2"]), abs((int)boxes[i]["y1"] - (int)boxes[j]["y1"])) <= min_h / 1) {
                        bool a = onlyDigits(boxes[i]["str"]);
                        bool b = onlyDigits(boxes[j]["str"]);
                        if (a == b) {
                            best.push_back(make_pair(make_pair(i, j), sqr((int)boxes[i]["x1"] + (int)boxes[i]["x2"] - (int)boxes[j]["x1"] - (int)boxes[j]["x2"]) + sqr((int)boxes[i]["y1"] + (int)boxes[i]["y2"] - (int)boxes[j]["y1"] - (int)boxes[j]["y2"])));
                            flag = true;
                        }
                        else {
                            if (a && ((string)boxes[j]["str"]).size() == 1) {
                                auto c = (string)boxes[j]["str"];
                                
                                if (pos_digits.count(c[0])) {
                                    boxes[j]["str"] = pos_digits[c[0]];
                                    best.push_back(make_pair(make_pair(i, j), sqr((int)boxes[i]["x1"] + (int)boxes[i]["x2"] - (int)boxes[j]["x1"] - (int)boxes[j]["x2"]) + sqr((int)boxes[i]["y1"] + (int)boxes[i]["y2"] - (int)boxes[j]["y1"] - (int)boxes[j]["y2"])));
                                    flag = true;
                                }
                            }
                            if (b && ((string)boxes[i]["str"]).size() == 1) {
                                auto c = (string)boxes[i]["str"];
                                if (pos_digits.count(c[0])) {
                                    boxes[i]["str"] = pos_digits[c[0]];
                                    best.push_back(make_pair(make_pair(i, j), sqr((int)boxes[i]["x1"] + (int)boxes[i]["x2"] - (int)boxes[j]["x1"] - (int)boxes[j]["x2"]) + sqr((int)boxes[i]["y1"] + (int)boxes[i]["y2"] - (int)boxes[j]["y1"] - (int)boxes[j]["y2"])));
                                    flag = true;
                                }
                            }
                        }
                    }
                }
            }
        }
        if (flag) {
            int mn = 0;
            for (int i = 0; i < best.size(); ++i) {
                if (best[i].second < best[mn].second) {
                    mn = i;
                }
            }
            int i = best[mn].first.first;
            int j = best[mn].first.second;
            if (boxes[i]["x2"] > boxes[j]["x2"]) {
                swap(boxes[i], boxes[j]);
            }
            
            if (!onlyDigits((string)boxes[i]["str"])) {
                if ((int)boxes[j]["x1"] - (int)boxes[i]["x2"] >= 1.25 * ((int)boxes[i]["x2"] - (int)boxes[i]["x1"] + (int)boxes[j]["x2"] - (int)boxes[j]["x1"]) / (((string)boxes[i]["str"]).size() + ((string)boxes[j]["str"]).size()) && ((string)boxes[i]["str"]).size() > 1 && ((string)boxes[j]["str"]).size() > 1) {
                    boxes[i]["str"] = string(boxes[i]["str"]) + " ";
                }
            }
            boxes[i]["str"] = (string)boxes[i]["str"] + (string)boxes[j]["str"];
            boxes[i]["x1"] = min((int)boxes[i]["x1"], (int)boxes[j]["x1"]);
            boxes[i]["y1"] = min((int)boxes[i]["y1"], (int)boxes[j]["y1"]);
            boxes[i]["x2"] = max((int)boxes[i]["x2"], (int)boxes[j]["x2"]);
            boxes[i]["y1"] = min((int)boxes[i]["y1"], (int)boxes[j]["y1"]);
            boxes.erase(boxes.begin() + j);
        }
    }
    for (auto x : boxes) {
        string str = (string)x["str"];
        for (auto c : str) {
            if (c == '/') {
                nva = str;
                continue;
            }
        }
        
        auto str2 = leaveOnlyDigits(str);
        if ((str2.size() == 10 || str2.size() == 16) && (str.size() - str2.size()) <= 3) {
            cardNumber = str2;
            continue;
        }
        
        if (getDist(str, "mastercard") <= 3) {
            system = "mastercard";
            continue;
        }
        if (getDist(str, "visa") <= 2) {
            system = "visa";
            continue;
        }
        if (!onlyDigits(str) && str.size() >= 8) {
            name = str;
        }
    }
    bank = new BankInfo(cardNumber);
    cerr << boxes << endl << endl << endl;
    cout << "_________________________________" << endl;
}

string Card::getBankName() {
    return bank->getName();
}

string Card::getNVA() {
    return nva;
}

string Card::getName() {
    return name;
}

string Card::getCardNumber() {
    return cardNumber;
}

string Card::getSystem() {
    return system;
}
