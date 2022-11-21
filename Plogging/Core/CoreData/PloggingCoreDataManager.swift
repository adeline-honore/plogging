//
//  PloggingCoreDataManager.swift
//  Plogging
//
//  Created by HONORE Adeline on 11/11/2022.
//

//import Foundation
import CoreData

final class PloggingCoreDataManager {
    
    // MARK: - Properties
    
    private let coreDataStack: CoreDataStack
    let managedObjectContext: NSManagedObjectContext
    
    // MARK: - Init
    
    public init(coreDataStack: CoreDataStack, managedObjectContext: NSManagedObjectContext) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = managedObjectContext
    }
    
    func createEntity(ploggingUI: PloggingUI) throws {
        
        let entity = NSEntityDescription.entity(forEntityName: "PloggingCD",
                                                in: coreDataStack.viewContext)!
        
        let ploggingCD = NSManagedObject(entity: entity, insertInto: coreDataStack.viewContext)
        
        ploggingCD.setValue(ploggingUI.id, forKey: "id")
        ploggingCD.setValue(ploggingUI.admin, forKey: "admin")
        ploggingCD.setValue(ploggingUI.beginning, forKey: "time")
        ploggingCD.setValue(ploggingUI.place, forKey: "place")
        ploggingCD.setValue(ploggingUI.isTakingPart, forKey: "isTakingPart")
        ploggingCD.setValue(ploggingUI.distance, forKey: "distance")
        
        try coreDataStack.viewContext.save()
    }
    
    func getEntities() throws -> [PloggingCD] {
        let request: NSFetchRequest<PloggingCD> = PloggingCD.fetchRequest()
        do {            
            return try coreDataStack.viewContext.fetch(request)            
        } catch {
            throw error
        }
    }
    
    func removeEntity(id: String) throws {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PloggingCD")
        request.predicate = NSPredicate(format:"id = %@", id)
        
        if let results = try coreDataStack.viewContext.fetch(request) as? [NSManagedObject] {
            // delete first object:
            if results.count > 0 {
                coreDataStack.viewContext.delete(results[0])
                do {
                try coreDataStack.viewContext.save()
                } catch {
                    throw error
                }
            }
        } else {
            print("oups")
        }
    }
}
