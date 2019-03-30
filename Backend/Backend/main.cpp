//
//  main.cpp
//  Backend
//
//  Created by Dima Zapolsky on 30/03/2019.
//  Copyright © 2019 Dima Zapolsky. All rights reserved.
//

#include <iostream>
#include "Card.hpp"
#include <fstream>

int main(int argc, const char * argv[]) {
    ifstream in("boxes.json");
    string js = "";
    string s;
    while (in >> s) {
        js += s + " ";
    }
    in.close();
    json boxes = json::parse(js);
    auto card = Card(json(boxes["items"]));
    cout << "  Bank name = " << card.getBankName() << endl;
    cout << "Card number = " << card.getCardNumber() << endl;
    cout << " Owner name = " << card.getName() << endl;
    cout << "   Card nva = " << card.getNVA() << endl;
    cout << "Card system = " << card.getSystem() << endl;
    return 0;
}
