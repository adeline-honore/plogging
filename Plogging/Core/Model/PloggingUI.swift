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
    var distance: Double
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
        distance = Double(plogging.distance)
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
         distance: Double? = nil,
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
    init(ploggingCD: PloggingCD, beginningString: String, isTakingPartUI: Bool, image: UIImage) {
        self.id = ploggingCD.id ?? ""
        self.admin = ploggingCD.admin ?? ""
        self.beginningTimestamp = 0 //Int(ploggingCD.beginning)
        self.beginningString = beginningString
        self.place = ploggingCD.place ?? ""
        self.latitude = ploggingCD.latitude
        self.longitude = ploggingCD.longitude
        self.ploggers = ploggingCD.ploggers ?? [""]
        self.isTakingPart = isTakingPartUI
        self.distance = ploggingCD.distance
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
    
    func convertPloggingCDBeginningToBeginningString(dateString: String) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(Int(dateString) ?? 0))
        if Int(dateString) != nil && Int(dateString) != 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY MMM d, HH:mm"
            let dateUI = dateFormatter.string(from: date as Date)
            return dateUI
        }
        return "unable to display correct date"
    }
}
