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
        ploggingCD.setValue(dateToDisplayedString(date :ploggingUI.beginning), forKey: "beginning")
        ploggingCD.setValue(ploggingUI.place, forKey: "place")
        ploggingCD.setValue(ploggingUI.latitude, forKey: "latitude")
        ploggingCD.setValue(ploggingUI.longitude, forKey: "longitude")
        ploggingCD.setValue(ploggingUI.isTakingPart, forKey: "isTakingPart")
        ploggingCD.setValue(ploggingUI.distance, forKey: "distance")
        ploggingCD.setValue(ploggingUI.mainImageBinary, forKey: "imageBinary")
        
        try coreDataStack.viewContext.save()
    }
    
    func getEntities() throws -> [PloggingCD] {
        let request: NSFetchRequest<PloggingCD> = PloggingCD.fetchRequest()
        // get only races where isTakingPart = true
        request.predicate = NSPredicate(format: "isTakingPart = %@", NSNumber(booleanLiteral: true))
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
    
    func setEntity(place: String, ploggingUI: PloggingUI) throws {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PloggingCD")
        request.predicate = NSPredicate(format:"place = %@", place)
        
        if let results = try coreDataStack.viewContext.fetch(request) as? [NSManagedObject] {
            if results.count > 0 {
                results[0].setValue(dateToDisplayedString(date :ploggingUI.beginning), forKey: "beginning")
                results[0].setValue(ploggingUI.place, forKey: "place")
                results[0].setValue(ploggingUI.latitude, forKey: "latitude")
                results[0].setValue(ploggingUI.longitude, forKey: "longitude")
                results[0].setValue(ploggingUI.distance, forKey: "distance")
                results[0].setValue(ploggingUI.mainImageBinary, forKey: "imageBinary")
                
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
    
    func stringDateToDateObject(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        
        guard let date = dateFormatter.date(from: dateString) else { return Date() }
        
        return date
    }
    
    func dateToDisplayedString(date :Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm"
        formatter.locale = Locale.init(identifier: "en_GB")
        return formatter.string(from: date)
    }
}
