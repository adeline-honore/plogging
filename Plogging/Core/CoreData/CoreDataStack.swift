//
//  CoreDataStack.swift
//  Plogging
//
//  Created by HONORE Adeline on 11/11/2022.
//

import Foundation
import CoreData

class CoreDataStack {

    // MARK: - Properties

    public static let persistentContainerName = "Plogging"

    public static let model: NSManagedObjectModel = {
      let modelURL = Bundle.main.url(forResource: persistentContainerName, withExtension: "momd")!
      return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    // MARK: - Public

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    public init() {}

    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.persistentContainerName, managedObjectModel: CoreDataStack.model)
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error) \(error.userInfo) for: \(storeDescription.description)")
            }
        })
        return container
    }()
}
