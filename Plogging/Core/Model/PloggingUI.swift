//
//  PloggingUI.swift
//  Plogging
//
//  Created by HONORE Adeline on 07/11/2022.
//

import Foundation


struct PloggingUI: Codable {
    let id: String
    
    let admin: String
    
    var beginning: String
    
    var place: String
    
    var latitude: Double
    var longitude: Double
    
    var ploggers: [String]
    
    var isTakingPart: Bool
    
    var messages: [Message]
}


struct Message: Codable {
    
    var sender: String
    var recipient: String
    var text: String
    var timestamp: Double
    
}
