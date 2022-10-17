//
//  MapViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 04/10/2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    // MARK: - Properties
    
    var locationTools = LocationTools.shared
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set initial location in etang Kernicole
        locationTools.region = MKCoordinateRegion(
            center: locationTools.initialLocation.coordinate,
            latitudinalMeters: 50000,
            longitudinalMeters: 60000)
        mapView.centerToLocation(locationTools.initialLocation)
        
        mapView.setCameraBoundary(
            MKMapView.CameraBoundary(coordinateRegion: locationTools.region),
          animated: true)
        
        mapView.setCameraZoomRange(locationTools.zoomRange, animated: true)
        
    }

    
}
