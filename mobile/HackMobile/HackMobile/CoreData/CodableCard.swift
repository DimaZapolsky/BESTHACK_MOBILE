//
//  CodableCard.swift
//  HackMobile
//
//  Created by Ирина Улитина on 30/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//
import UIKit
import Foundation

class BankInfo: Decodable {
    var backgroundColor: String? {
        didSet {
            if (backgroundColor!.count == 4) {
                var newColor = "#"
                for i in 1..<backgroundColor!.count {
                    newColor += String( backgroundColor![ backgroundColor!.index(backgroundColor!.startIndex, offsetBy: i)])
                    newColor += String(backgroundColor![ backgroundColor!.index(backgroundColor!.startIndex, offsetBy: i)])
                }
            }
        }
    }
    var name: String?
    
    private enum CodingKeys: String, CodingKey {
        case backgroundColor = "backgroundColor"
        case name = "nameEn"
    }
}

class CodableCard: Decodable {
    var cardHolderName: String?
    var bankInfo: BankInfo?
    var expirationDate: Date?
    var color: String?
    var cardNumber: String?

    init(holderName: String?, bankName: BankInfo?, expDate: Date?, cardNumber: String?, color: String?) {
        self.cardHolderName = holderName
        self.bankInfo = bankName
        self.expirationDate = expDate
        self.cardNumber = cardNumber
        self.color = color
    }
    init(holderName: String?, bankName: String?, expDate: Date?, cardNumber: String?, color: String?, backgroundColor: String?) {
        self.cardHolderName = holderName
        self.bankInfo = BankInfo()
        self.expirationDate = expDate
        self.cardNumber = cardNumber
        self.color = color
        self.bankInfo?.name = bankName
        self.bankInfo?.backgroundColor = backgroundColor
    }
    
    enum CodingKeys: String, CodingKey {
        case cardHolderName = "name"
        case bankInfo = "BankInfo"
        case expirationDate = "nva"
        case color = "color"
        case cardNumber = "CardNumber"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cardHolderName = try container.decode(String?.self, forKey: .cardHolderName)
        self.bankInfo = try container.decode(BankInfo?.self, forKey: .bankInfo)
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
        do {
            self.color = try container.decode(String?.self, forKey: .color)
        } catch let _ {
            
        }
        
    }
}
