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
    
    var beginning: Double
    
    var place: String
    
    var latitude: Double?
    var longitude: Double?
    
    var ploggers: [String]?
    
    var isTakingPart: Bool
    
    var distance: Double
    
//    var messages: [Message]
    
    
    init(plogging: Plogging) {
        
        id = plogging.id
        admin = plogging.admin
        
        beginning = plogging.beginning
        
        place = plogging.place
        
        latitude = plogging.latitude
        longitude = plogging.longitude
        
        ploggers = plogging.ploggers
        
        isTakingPart = plogging.isTakingPart
        
        distance = plogging.distance
        
//        self.messages = messages
        
    }
    
    // init for create an instance of PloggingUI
    init(id: String, admin: String, beginning: Double, place: String, isTakingPart: Bool, distance: Double) {
        self.id = id
        self.admin = admin
        self.beginning = beginning
        self.place = place
        self.isTakingPart = isTakingPart
        self.distance = distance
    }
    
    // init from PlogginCD
    init(ploggingCD: PloggingCD) {
        self.id = ploggingCD.id ?? ""
        self.admin = ploggingCD.admin ?? ""
        self.beginning = ploggingCD.time
        self.place = ploggingCD.place ?? ""
        self.ploggers = ploggingCD.ploggers ?? [""]
        self.isTakingPart = ploggingCD.isTakingPart
        self.distance = ploggingCD.distance
    }
}


struct Message: Codable {
    
    var sender: String
    var recipient: String
    var text: String
    var timestamp: Double
    
}
