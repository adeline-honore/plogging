//
//  LocalSearchCompletion.swift
//  Plogging
//
//  Created by HONORE Adeline on 29/10/2022.
//

import MapKit

enum LocalSearchError: Error {
    case emptyCompletion
}

class LocalSearchCompletion: MKLocalSearchCompleter {
    
    // MARK: - Properties
    
    var placeCoordinate: CLLocationCoordinate2D?
    var searchResults: [MKLocalSearchCompletion] = []
    
    // MARK: - Location from Local search completion
    
    func getCoordinates(for searchCompletion: MKLocalSearchCompletion?, completionHandler: @escaping((Result<CLLocationCoordinate2D?, Error>) -> Void)) {
        guard let searchCompletion = searchCompletion else {
            return completionHandler(.failure(LocalSearchError.emptyCompletion))
        }
        
        let searchRequest = MKLocalSearch.Request(completion: searchCompletion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinates = response?.mapItems.first?.placemark.coordinate
            completionHandler(.success(coordinates))
        }
    }
}
