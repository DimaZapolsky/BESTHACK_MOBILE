//
//  Card.hpp
//  Backend
//
//  Created by Dima Zapolsky on 30/03/2019.
//  Copyright © 2019 Dima Zapolsky. All rights reserved.
//

#ifndef Card_hpp
#define Card_hpp

#include <stdio.h>
#include <iostream>
#include <vector>
#include "BankInfo.hpp"
#include "json.hpp"

using json = nlohmann::json;
using namespace std;

class Card {
private:
    string cardNumber;
    string name;
    string nva;
    string system;
    BankInfo * bank;
public:
    Card(json boxesJSON);
    string getBankName();
    string getName();
    string getNVA();
    string getCardNumber();
    string getSystem();
};

#endif /* Card_hpp */
