//
//  LocationTools.swift
//  Plogging
//
//  Created by HONORE Adeline on 09/10/2022.
//

import UIKit
import MapKit
import CoreLocation

class LocationTools: MKLocalSearchCompleter, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    static var shared = LocationTools()
    
    let locationManager = CLLocationManager()
    
    var currentPlace: CLPlacemark?
    
    var searchResults: [MKLocalSearchCompletion] = []
    
    var placeCoordinate: CLLocationCoordinate2D?
        
    
    // MARK: - Methods
    
    func getCoordinateFromLocalSearchCompletion (completion: MKLocalSearchCompletion) {
            let searchRequest = MKLocalSearch.Request(completion: completion)
            let search = MKLocalSearch(request: searchRequest)
            search.start { (response, error) in
                self.placeCoordinate = response?.mapItems[0].placemark.coordinate
        }
    }
}
