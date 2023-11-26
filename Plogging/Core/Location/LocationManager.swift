//
//  LocationManager.swift
//  Plogging
//
//  Created by HONORE Adeline on 09/10/2022.
//

import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func accessUserCoordinate(_ location: CLLocation)
}

class LocationManager: CLLocationManager, CLLocationManagerDelegate {

    // MARK: - Properties

    static var shared = LocationManager()

    weak var locationManagerDelegate: LocationManagerDelegate?

    let locationManager = CLLocationManager()

    // MARK: - Init

    override init() {
        super.init()
        locationManager.delegate = self
    }

    // MARK: - User's geo location

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            switch manager.authorizationStatus {
            case .authorizedWhenInUse:  // Location services are available.
                self.locationManager.startUpdatingLocation()
                break
                
            case .restricted, .denied:  // Location services currently unavailable.
                manager.requestWhenInUseAuthorization()
                break
                
            case .notDetermined:        // Authorization not determined yet.
                manager.requestWhenInUseAuthorization()
                break
                
            default:
                break
            }
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

        locationManagerDelegate?.accessUserCoordinate(firstLocation)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
}
