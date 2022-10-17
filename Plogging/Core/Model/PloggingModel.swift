//
//  PloggingModel.swift
//  Plogging
//
//  Created by HONORE Adeline on 17/10/2022.
//

import Foundation
import MapKit

struct PloggingModel {
    let id: UUID
    
    let admin: String
    
    let date: Date
    let hour: Date
    
    let place: MKMapItem
    let coordinate: CLLocationCoordinate2D
    
    let annotation: MKAnnotation
    let annotations: [MKAnnotation]
    
    let plogger: [String]
    
    var isTakingPart: Bool
    
}
