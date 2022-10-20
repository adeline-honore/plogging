//
//  PloggingAnnotation.swift
//  Plogging
//
//  Created by HONORE Adeline on 17/10/2022.
//

import Foundation
import MapKit

class PloggingAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    
    init(_ latitude:CLLocationDegrees, _ longitude: CLLocationDegrees, title: String, subtitle: String) {
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.title = title
        self.subtitle = subtitle
    }
}
