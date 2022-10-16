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
    
    var placemark: CLPlacemark?
    
    var searchResults: [MKLocalSearchCompletion] = []
    
    var placeCoordinate: CLLocationCoordinate2D?
    
    
    // MARK: - Init
    
    override init() {
        super .init()
        locationManager.delegate = self
    }
    
    
    // MARK: - Location from Local search completion
    
    func getLocationFromLocalSearchCompletion (completion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            self.placeCoordinate = response?.mapItems[0].placemark.coordinate
            
            self.placemark = response?.mapItems[0].placemark
        }
    }
    
    // MARK: - User's geo location
    
    func getUserGeoLocation () {
        
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.requestLocation()
            
        }
    }
    
    
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        
        guard status == .authorizedWhenInUse else {
            return
        }
        manager.requestLocation()
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        
        guard let firstLocation = locations.first else { return }
        
        placeCoordinate = firstLocation.coordinate
        
        CLGeocoder().reverseGeocodeLocation(firstLocation) { places, _ in
            
            guard
              let firstPlace = places?.first
              else {
                return
            }
            self.placemark = firstPlace
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
