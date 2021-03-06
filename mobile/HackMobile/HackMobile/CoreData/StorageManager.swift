//
//  StorageManager.swift
//  HackMobile
//
//  Created by Ирина Улитина on 30/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class StorageManager {
    static var shared = StorageManager()
    
    private var stack = CoreDataStack()
    
    func createCard(name: String?, bankName: String?, cardNumber: String?, expirationDate: Date?, color: UIColor = UIColor.white, textColor: UIColor = UIColor.black) {
        let card = CardEntity.createCard(in: self.stack.mainContext)
        card?.bankName = bankName
        card?.cardNumber = cardNumber
        card?.cardHolderName = name
        card?.expirationDate = expirationDate
        card?.timestamp = Date()
        card?.textColor = NSKeyedArchiver.archivedData(withRootObject: textColor)
        card?.color = NSKeyedArchiver.archivedData(withRootObject: color)
        self.stack.performSave()
    }
    
    func save() {
        self.stack.performSave()
    }
    
    func eraseCard(card: CardEntity) {
        self.stack.mainContext.delete(card)
        self.save()
    }
    
    func createCard(decodedCard: CodableCard) {
        let card = CardEntity.createCard(in: self.stack.mainContext)
        card?.bankName = decodedCard.bankInfo?.name
        
        card?.cardNumber = decodedCard.cardNumber
        card?.cardHolderName = decodedCard.cardHolderName
        card?.expirationDate = decodedCard.expirationDate
        card?.timestamp = Date()
        if let backColor = decodedCard.bankInfo?.backgroundColor {
            card?.color = NSKeyedArchiver.archivedData(withRootObject: UIColor.hexStringToUIColor(hex: backColor))
        }
        if let txtColor = decodedCard.color {
        card?.textColor =  NSKeyedArchiver.archivedData(withRootObject: UIColor.hexStringToUIColor(hex: txtColor))
        }
        if let color = decodedCard.color {
            card?.color = NSKeyedArchiver.archivedData(withRootObject: UIColor.hexStringToUIColor(hex: color)) 
        }
        self.stack.performSave()
    }
    
    func generateFRC() -> NSFetchedResultsController<CardEntity> {
        let frc = NSFetchedResultsController(fetchRequest: CardEntity.getCardsByTimeStamp(), managedObjectContext: self.stack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return frc
    }
    
}
