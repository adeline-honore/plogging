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
    
    private var locationTools = LocationTools.shared
    var plogging: PloggingModel?
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
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
        
        // display PloggingAnnotation items
        locationTools.loadPloggingDatas()
        mapView.addAnnotations(locationTools.ploggingAnnotations)
        
    }
    
    
    // MARK: - Send datas thanks segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueIdentifier.fromMapToPlogging.identifier {
            let viewController = segue.destination as? PloggingDetailsViewController
            viewController?.plogging = plogging
        }
    }
}


extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = MKMarkerAnnotationView()
        
        guard let annotation = annotation as? PloggingAnnotation else {return nil}
        let identifier = ""
        
        
        if let dequedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            annotationView = dequedView
        } else{
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        annotationView.markerTintColor = UIColor.black
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let id = view.annotation?.subtitle else { return }
        
        guard let selected = locationTools.ploggingModels.first(where: { $0.id == id }) else {
            print("***** oups! Could not load plogging informations")
            return
        }
        
        plogging = selected
        
        performSegue(withIdentifier: SegueIdentifier.fromMapToPlogging.identifier, sender: self)
    }
}
