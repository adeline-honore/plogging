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
    
    var beginning: String
    
    var place: String
    
    var latitude: Double?
    var longitude: Double?
    
    var ploggers: [String]?
    
    var isTakingPart: Bool?
    
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
        
//        self.messages = messages
        
    }
    
    // init for create an instance of PloggingUI
    init(id: String, admin: String, beginning: String, place: String, isTakingPart: Bool) {
        self.id = id
        self.admin = admin
        self.beginning = beginning
        self.place = place
        self.isTakingPart = isTakingPart
    }
}


struct Message: Codable {
    
    var sender: String
    var recipient: String
    var text: String
    var timestamp: Double
    
}
