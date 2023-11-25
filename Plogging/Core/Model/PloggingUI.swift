//
//  PloggingUI.swift
//  Plogging
//
//  Created by HONORE Adeline on 07/11/2022.
//

import UIKit

struct PloggingUI {
    var id: String
    var admin: String
    var beginningTimestamp: Int
    var beginningString: String
    var place: String
    var latitude: Double
    var longitude: Double
    var ploggers: [String]
    var isTakingPart: Bool
    var distance: Int
    var mainImageBinary: Data?
    var mainImage: UIImage?

    init(plogging: Plogging, scheduleTimestamp: Int, scheduleString: String, isTakingPartUI: Bool) {
        id = plogging.id
        admin = plogging.admin
        beginningTimestamp = scheduleTimestamp
        beginningString = scheduleString
        place = plogging.place
        latitude = plogging.latitude
        longitude = plogging.longitude
        ploggers = plogging.ploggers
        isTakingPart = isTakingPartUI
        distance = Int(plogging.distance)
    }

    // init for create an instance of PloggingUI
    init(id: String? = nil,
         admin: String? = nil,
         beginningTimestamp: Int = 0,
         beginningString: String? = nil,
         place: String? = nil,
         latitude: Double? = nil,
         longitude: Double? = nil,
         isTakingPart: Bool = false,
         distance: Int? = nil,
         ploggers: [String]? = nil) {
        self.id = id ?? ""
        self.admin = admin ?? ""
        self.beginningTimestamp = 0
        self.beginningString = beginningString ?? ""
        self.place = place ?? ""
        self.latitude = latitude ?? 0.0
        self.longitude = longitude ?? 0.0
        self.isTakingPart = isTakingPart
        self.distance = distance ?? 0
        self.ploggers = ploggers ?? [""]
    }

    // init from PlogginCD
    init(ploggingCD: PloggingCD, beginningInt: Int, beginningString: String, isTakingPartUI: Bool, image: UIImage) {
        self.id = ploggingCD.id ?? ""
        self.admin = ploggingCD.admin ?? ""
        self.beginningTimestamp = beginningInt
        self.beginningString = beginningString
        self.place = ploggingCD.place ?? ""
        self.latitude = ploggingCD.latitude
        self.longitude = ploggingCD.longitude
        self.ploggers = ploggingCD.ploggers ?? [""]
        self.isTakingPart = isTakingPartUI
        self.distance = Int(ploggingCD.distance)
        self.mainImageBinary = ploggingCD.imageBinary
        self.mainImage = image
    }
    
    func displayUIDateFromIntegerTimestamp(timestamp: Int) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MM dd, HH:mm"
        return formatter.string(from: date as Date)
    }

    var isValid: Bool {
        !place.isEmpty
    }
}
