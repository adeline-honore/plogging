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
}
