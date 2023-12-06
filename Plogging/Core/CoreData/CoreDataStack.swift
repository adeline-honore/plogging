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
        guard let modelURL = Bundle.main.url(forResource: persistentContainerName, withExtension: "momd") else { return NSManagedObjectModel() }
        return NSManagedObjectModel(contentsOf: modelURL) ?? NSManagedObjectModel()
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
