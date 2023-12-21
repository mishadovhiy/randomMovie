//
//  CoreDataDBManager.swift
//  MovieList
//
//  Created by Misha Dovhiy on 13.10.2023.
//

import Foundation
import CoreData

struct GeneralEntityStruct {
    let db:Data
    static func create(db:GeneralEntitie) -> GeneralEntityStruct {
        return .init(db: db.db ?? .init())
    }
}

struct CoreDataDBManager {
    enum Entities:String {
        case general = "GeneralEntitie"
    }
    
    private let persistentContainer:NSPersistentContainer
    private let context:NSManagedObjectContext
    private let appDelegate:AppDelegate
    
    init(persistentContainer: NSPersistentContainer,
         appDelegate:AppDelegate) {
        self.persistentContainer = persistentContainer
        self.context = persistentContainer.viewContext
        self.appDelegate = appDelegate
    }
    
    static var transactionsHolder:GeneralEntityStruct?
    
    func fetch(_ entitie:Entities) -> GeneralEntitie? {
        let results = self.fetchRecordsForEntity(entitie, inManagedObjectContext: context)
        if let transactions = (results.filter({
            return $0 is GeneralEntitie
        }) as? [GeneralEntitie])?.first {
            return transactions
        } else {
            return nil
        }
        
    }
    

    func updateTransactions(_ new:GeneralEntityStruct) {
        if Thread.isMainThread {
            DispatchQueue(label: "db", qos: .userInitiated).async {
                if let old = fetch(.general) {
                    old.db = new.db
                    self.appDelegate.saveContext()
                } else {
                    let _: GeneralEntitie = .create(entity: context, transaction: new)
                    self.appDelegate.saveContext()
                }
            }
        } else {
            if let old = fetch(.general) {
                old.db = new.db
                appDelegate.saveContext()
            } else {
                let _: GeneralEntitie = .create(entity: context, transaction: new)
                appDelegate.saveContext()
            }
        }
        
    }
    
    private func fetchRecordsForEntity(_ entity:Entities, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)

        var result = [NSManagedObject]()

        do {
            let records = try managedObjectContext.fetch(fetchRequest)

            if let records = records as? [NSManagedObject] {
                result = records
            }

        } catch {
            print("Unable to fetch managed objects for entity \(entity.rawValue).")
        }

        return result
    }
    
    
}

extension GeneralEntitie {
    static func create(entity:NSManagedObjectContext, transaction:GeneralEntityStruct) -> GeneralEntitie {
        let new = GeneralEntitie(context: entity)
        new.db = transaction.db
        return new
    }
        
}
