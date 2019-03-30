//
//  BankInfo.cpp
//  Backend
//
//  Created by Dima Zapolsky on 30/03/2019.
//  Copyright © 2019 Dima Zapolsky. All rights reserved.
//

#include "BankInfo.hpp"
#include <iostream>

using namespace std;

BankInfo::BankInfo(string number) {
    if (number.length() != 10 && number.length() != 16) {
        cerr << "pizdec nahoi blyat" << endl;
        return;
    }
    info = Banks::getInstance()->getBankByCardNumber(number);
}

string BankInfo::getName() {
    return info["name"];
}

string BankInfo::getNameEn() {
    return info["nameEn"];
}

string BankInfo::getTextColor() {
    return info["text"];
}

string BankInfo::getBackgroundColor() {
    return info["backgroundColor"];
}

string BankInfo::getBackgroundLightness() {
    return info["backgroundLightness"];
}
