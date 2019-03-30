//
//  CoreDataStack.swift
//  HackMobile
//
//  Created by Ирина Улитина on 30/03/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    var storeURL: URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsURL.appendingPathComponent("Mystore12.sqlite")
    }
    
    let dataModelName = "Model"
    
    let dataModelExtension = "momd"
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtension)!
        
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistantStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeURL, options: nil)
        } catch let err {
            assert(false)
        }
        
        return coordinator
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        //mainContext.parent = self.masterContext
        mainContext.persistentStoreCoordinator = self.persistantStoreCoordinator
        mainContext.mergePolicy = NSOverwriteMergePolicy
        
        return mainContext
    }()
    
    func performSave() {
        do {
            try self.mainContext.save()
        } catch let err {
            print(err)
        }
    }
}
