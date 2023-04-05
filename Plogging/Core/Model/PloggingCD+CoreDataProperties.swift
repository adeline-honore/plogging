//
//  PloggingCD+CoreDataProperties.swift
//  Plogging
//
//  Created by HONORE Adeline on 05/04/2023.
//
//

import Foundation
import CoreData


extension PloggingCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PloggingCD> {
        return NSFetchRequest<PloggingCD>(entityName: "PloggingCD")
    }

    @NSManaged public var admin: String?
    @NSManaged public var beginning: String?
    @NSManaged public var distance: Double
    @NSManaged public var id: String?
    @NSManaged public var imageBinary: Data?
    @NSManaged public var imagesBinary: [Data]?
    @NSManaged public var imagesString: [String]?
    @NSManaged public var imageString: String?
    @NSManaged public var isTakingPart: Bool
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var messages: [String]?
    @NSManaged public var place: String?
    @NSManaged public var ploggers: [String]?
    @NSManaged public var schedule: Date?
    @NSManaged public var time: Double
    @NSManaged public var photos: NSSet?

}

// MARK: Generated accessors for photos
extension PloggingCD {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: PhotoCD)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: PhotoCD)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}

extension PloggingCD : Identifiable {

}
