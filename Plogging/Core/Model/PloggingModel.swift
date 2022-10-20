//
//  PloggingModel.swift
//  Plogging
//
//  Created by HONORE Adeline on 17/10/2022.
//

import Foundation
import MapKit

struct PloggingModel: Decodable {
    let id: String
    
    let admin: String
    
    let beginning: String
    
    let place: String
    
    let latitude: Double
    let longitude: Double
    
    let ploggers: [String]
    
    var isTakingPart: Bool
    
}
