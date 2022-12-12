//
//  PloggingUI.swift
//  Plogging
//
//  Created by HONORE Adeline on 07/11/2022.
//

import Foundation


struct PloggingUI: Codable {
    var id: String
    
    var admin: String
    
    var beginning: Date
    
    var place: String
    
    var latitude: Double?
    var longitude: Double?
    
    var ploggers: [String]?
    
    var isTakingPart: Bool
    
    var distance: Double
    
    var mainImage: String?
    
//    var messages: [Message]
    
    
    init(plogging: Plogging, schedule: Date) {
        
        id = plogging.id
        admin = plogging.admin
        
        beginning = schedule
        
        place = plogging.place
        
        latitude = plogging.latitude
        longitude = plogging.longitude
        
        ploggers = plogging.ploggers
        
        isTakingPart = plogging.isTakingPart
        
        distance = plogging.distance
        
//        self.messages = messages
        
    }
    
    // init for create an instance of PloggingUI
    init(id: String?, admin: String?, beginning: Date?, place: String?, latitude: Double?, longitude: Double?, isTakingPart: Bool = false, distance: Double?, ploggers: [String]?) {
        self.id = id ?? ""
        self.admin = admin ?? ""
        self.beginning = beginning ?? Date()
        self.place = place ?? ""
        self.latitude = latitude
        self.longitude = longitude
        self.isTakingPart = isTakingPart
        self.distance = distance ?? 0
        self.ploggers = ploggers
    }
    
    // init from PlogginCD
    init(ploggingCD: PloggingCD, beginning: Date) {
        self.id = ploggingCD.id ?? ""
        self.admin = ploggingCD.admin ?? ""
        self.beginning = beginning
        self.place = ploggingCD.place ?? ""
        self.latitude = ploggingCD.latitude
        self.longitude = ploggingCD.longitude
        self.ploggers = ploggingCD.ploggers ?? [""]
        self.isTakingPart = ploggingCD.isTakingPart
        self.distance = ploggingCD.distance
    }
    
    func dateToDisplayedString(date :Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm"
        return formatter.string(from: date)
    }
}


struct Message: Codable {
    
    var sender: String
    var recipient: String
    var text: String
    var timestamp: Double
    
}
