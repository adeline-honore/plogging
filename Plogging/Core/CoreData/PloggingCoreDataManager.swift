//
//  PloggingCoreDataManager.swift
//  Plogging
//
//  Created by HONORE Adeline on 11/11/2022.
//

import Foundation
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
        ploggingCD.setValue(ploggingUI.beginning, forKey: "beginning")
        ploggingCD.setValue(ploggingUI.place, forKey: "place")
        ploggingCD.setValue(ploggingUI.isTakingPart, forKey: "isTakingPart")
    }
}
