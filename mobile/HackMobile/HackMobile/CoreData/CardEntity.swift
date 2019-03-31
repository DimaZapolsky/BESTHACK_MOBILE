//
//  CardEntity.swift
//  HackMobile
//
//  Created by Ирина Улитина on 30/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import CoreData

extension CardEntity {
    static func createCard(in context: NSManagedObjectContext) -> CardEntity? {
        guard let entity = NSEntityDescription.insertNewObject(forEntityName: "CardEntity", into: context) as? CardEntity else {
            return nil
        }
        return entity
    }
    
    static func getCardsFromBank(bank: String) -> NSFetchRequest<CardEntity> {
        let fetchRequest: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "bankName CONTAINS[cd] %@", bank)
        
        return fetchRequest
    }
    
    static func getCardsByTimeStamp() -> NSFetchRequest<CardEntity> {
        let fetchRequest: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        return fetchRequest
    }
    
    
}
