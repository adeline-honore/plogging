//
//  LocationTools.swift
//  Plogging
//
//  Created by HONORE Adeline on 09/10/2022.
//

import MapKit
import CoreLocation

class LocationTools: MKLocalSearchCompleter, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    static var shared = LocationTools()
    
    let locationManager = CLLocationManager()
    
    var placemark: CLPlacemark?
    
    var searchResults: [MKLocalSearchCompletion] = []
    
    var placeCoordinate: CLLocationCoordinate2D?
    
    let initialLocation = CLLocation(latitude: 47.6162601, longitude: -2.6565199)

    //var region: MKCoordinateRegion?
    let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
    
    var ploggingModels: [PloggingModel] = []
    var ploggingAnnotations: [PloggingAnnotation] = []
    
    
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
    
    // MARK: - Load Plogging datas
    
    func loadPloggingDatas() {
        
        guard
            let fileName = Bundle.main.url(forResource: "SomeDataz", withExtension: "json"),
            let ploggingData = try? Data(contentsOf: fileName)
        else {
            print("***** Failed to decode SomeDataz file from bundle.")
            return
        }
        
        do {
            let ploggingResult = try transformToPloggingsModel(data: ploggingData)
            
            ploggingModels = ploggingResult.datas.map { $0.self}
            
            ploggingAnnotations = createAnnotationFromPloggingModels(model: ploggingModels)
            
            return
        } catch {
            print("***** Could not decode SomeDataz in the project")
            return
        }
    }
    
    
    // MARK: - Load Plogging datas
    
    private func transformToPloggingsModel(data: Data) throws -> PloggingDatas {
        
        do {
            return try JSONDecoder().decode(PloggingDatas.self, from: data)
        } catch {
            throw error
        }
    }
    
    
    // MARK: - Create annotation from PloggingModel item
    
    func createAnnotationFromPloggingModel(model: PloggingModel) -> PloggingAnnotation {
        let annotation = PloggingAnnotation(model.latitude, model.longitude, title: model.place, subtitle: model.id)
        
        if CLLocationCoordinate2DIsValid(annotation.coordinate) {
            return annotation
        } else {
            print("*****  CLLocationCoordinate2D is not valid ")
            
        }
        
        return annotation
    }
    
    
    // MARK: - Create annotations from PloggingModel items
    
    func createAnnotationFromPloggingModels(model: [PloggingModel]) -> [PloggingAnnotation] {
        
        model.forEach{ model in
            let annotation = PloggingAnnotation(model.latitude, model.longitude, title: model.place, subtitle: model.id)
            
            if CLLocationCoordinate2DIsValid(annotation.coordinate) {
                ploggingAnnotations.append(annotation)
            } else {
                print("*****  CLLocationCoordinate2D is not valid ")
                
            }
        }
        return ploggingAnnotations
    }
}
