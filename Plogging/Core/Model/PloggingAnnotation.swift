//
//  PloggingAnnotation.swift
//  Plogging
//
//  Created by HONORE Adeline on 17/10/2022.
//

import Foundation
import MapKit

class PloggingAnnotation: NSObject {
    private let item: MKMapItem
    
    init(item: MKMapItem) {
        self.item = item
        
        super.init()
    }
}
