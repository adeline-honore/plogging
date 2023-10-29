//
//  PhotoCD+CoreDataProperties.swift
//  Plogging
//
//  Created by HONORE Adeline on 05/04/2023.
//
//

import Foundation
import CoreData

extension PhotoCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoCD> {
        return NSFetchRequest<PhotoCD>(entityName: "PhotoCD")
    }

    @NSManaged public var imageBinary: Data?
    @NSManaged public var name: String?
    @NSManaged public var owner: PloggingCD?

}

extension PhotoCD: Identifiable {

}
