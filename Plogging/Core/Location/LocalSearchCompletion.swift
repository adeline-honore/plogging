//
//  LocalSearchCompletion.swift
//  Plogging
//
//  Created by HONORE Adeline on 29/10/2022.
//

import MapKit

class LocalSearchCompletion: MKLocalSearchCompleter {
    
    // MARK: - Properties
    
    var placeCoordinate: CLLocationCoordinate2D?
    var searchResults: [MKLocalSearchCompletion] = []
    var completion: MKLocalSearchCompletion = MKLocalSearchCompletion()
    
    // MARK: - Location from Local search completion
    
    func getCoordinateFromLocalSearchCompletion (completion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            self.placeCoordinate = response?.mapItems[0].placemark.coordinate
        }
    }
}
