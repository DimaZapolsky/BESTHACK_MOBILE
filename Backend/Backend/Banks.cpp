//
//  Banks.cpp
//  Backend
//
//  Created by Dima Zapolsky on 30/03/2019.
//  Copyright © 2019 Dima Zapolsky. All rights reserved.
//

#include "Banks.hpp"
#include <iostream>

Banks* Banks::instance = 0;

json Banks::getBankByCardNumber(string number) {
    if (number.length() != 10 && number.length() != 16) {
        cerr << "- ebalo" << endl;
        return json();
    }
    for (auto bank : banks) {
        for (auto st : bank["prefixes"]) {
            string str = st;
            bool flag = true;
            if (str.size() != 6) {
                cerr << "pizdec" << endl;
            }
            for (int i = 0; i < str.size(); ++i) {
                if (str[i] != number[i]) {
                    flag = false;
                    break;
                }
            }
            if (flag) {
                return bank;
            }
        }
    }
    return nullptr;
}
