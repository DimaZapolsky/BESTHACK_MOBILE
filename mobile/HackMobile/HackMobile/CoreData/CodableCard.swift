//
//  CodableCard.swift
//  HackMobile
//
//  Created by Ирина Улитина on 30/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//
import UIKit
import Foundation

class CodableCard: Decodable {
    var cardHolderName: String?
    var bankName: String?
    var expirationDate: Date?
    var color: String?
    var cardNumber: String?

    init(holderName: String?, bankName: String?, expDate: Date?, cardNumber: String?, color: String?) {
        self.cardHolderName = holderName
        self.bankName = bankName
        self.expirationDate = expDate
        self.cardNumber = cardNumber
        self.color = color
    }
    
    enum CodingKeys: String, CodingKey {
        case cardHolderName = "cardHolderName"
        case bankName = "bankName"
        case expirationDate = "expirationDate"
        case color = "color"
        case cardNumber = "cardNumber"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cardHolderName = try container.decode(String?.self, forKey: .cardHolderName)
        self.bankName = try container.decode(String?.self, forKey: .bankName)
        self.cardNumber = try container.decode(String?.self, forKey: .cardNumber)
        var dateStr = try container.decode(String?.self, forKey: .expirationDate)
        if dateStr == nil {
            self.expirationDate = nil
        } else {
            dateStr = "01/" + dateStr!
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yy"
            self.expirationDate = formatter.date(from: dateStr!)
        }
        
        self.color = try container.decode(String?.self, forKey: .color)
        
    }
}
