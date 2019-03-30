//
//  BankInfo.hpp
//  Backend
//
//  Created by Dima Zapolsky on 30/03/2019.
//  Copyright © 2019 Dima Zapolsky. All rights reserved.
//

#ifndef BankInfo_hpp
#define BankInfo_hpp

#include "json.hpp"
#include <stdio.h>
#include "json.hpp"
#include "Banks.hpp"

using json = nlohmann::json;
using namespace std;

class BankInfo {
private:
    json info;
public:
    BankInfo(string cardNumber);
    BankInfo() = default;
    
    string getName();
    string getNameEn();
    string getBackgroundColor();
    string getBackgroundLightness();
    string getTextColor();
};

#endif /* BankInfo_hpp */
