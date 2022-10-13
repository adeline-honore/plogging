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
    
    static var shared = LocationTools()
    
    let locationManager = CLLocationManager()
    
    var currentPlace: CLPlacemark?
    
    let autoCompletion = MKLocalSearchCompleter()
    
    var suggestion: String?
    
    override init() {
        super .init()
        autoCompletion.delegate = self
        locationManager.delegate = self
    }
    
    
    func textFieldDidChange(textField: UITextField) {
        
        guard let query = textField.text else {
            
            if autoCompletion.isSearching {
                autoCompletion.cancel()
            }
            return
        }
        autoCompletion.queryFragment = query
    }
    
    func attemptLocationAccess() {
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
    
    func showSuggestion(_ placeSuggested: String) -> String {
        placeSuggested
    }
}


// MARK: - MKLocalSearchCompleterDelegate

extension LocationTools: MKLocalSearchCompleterDelegate {
    
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        guard let firstResult = completer.results.first else {
            return
        }
        
        suggestion = showSuggestion(firstResult.title)
    }
    
    func completer(
        _ completer: MKLocalSearchCompleter,
        didFailWithError error: Error
    ) {
        print("Error suggesting a location: \(error.localizedDescription)")
    }
}


// MARK: - CLLocationManagerDelegate

extension LocationTools {
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        // 1
        guard status == .authorizedWhenInUse else {
            return
        }
        manager.requestLocation()
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let firstLocation = locations.first else {
            return
        }
        
        // TODO: Configure MKLocalSearchCompleter here...
        
        
        CLGeocoder().reverseGeocodeLocation(firstLocation) { places, _ in
            
            guard
                let firstPlace = places?.first
            else {
                return
            }
            
            self.currentPlace = firstPlace
        }
    }
}
