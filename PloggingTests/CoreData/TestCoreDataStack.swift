//
//  TestCoreDataStack.swift
//  PloggingTests
//
//  Created by HONORE Adeline on 20/10/2023.
//

import XCTest
import CoreData
@testable import Plogging

class TestCoreDataStack: CoreDataStack {
    override init() {
        super.init()

        // 1 Creates an in-memory persistent store
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        // 2 Creates an NSPersistentContainer instance
        let testPersistentContainer = NSPersistentContainer(
            name: CoreDataStack.persistentContainerName, managedObjectModel: CoreDataStack.model)

        // 3 Assigns the in-memory persistent store to the container
        testPersistentContainer.persistentStoreDescriptions = [persistentStoreDescription]

        testPersistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        // 4 Overrides the storeContainer in CoreDataStack
        persistentContainer = testPersistentContainer
    }
}
