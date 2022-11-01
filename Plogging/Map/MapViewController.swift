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
    
    private var locationManager = LocationManager.shared
    private var ploggingService = PloggingService()
    
    private var ploggings: [Plogging] = []
    var plogging: Plogging?
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // on bording page
        
//        if !UserDefaults.standard.bool(forKey: "ExecuteOn") {
            displayAppOverviewPage()
//            UserDefaults.standard.set(true, forKey: "ExecuteOn")
//
//        } else {
//            // get user geo location
//            locationManager.getUserGeoLocation()
//
//            // Set initial location in etang Kernicole
//            SetInitialLocationInEtangKernicole()
//
//            // display PloggingAnnotation items
//            displayPloggingAnnotationItems()
//        }
    }
    
    
    // MARK: - App overview page
    
    private func displayAppOverviewPage() {
        
        guard let overviewPageVC = storyboard?.instantiateViewController(withIdentifier: "Presentation") else {
            return
        }
        
        overviewPageVC.modalTransitionStyle = .crossDissolve
            present(overviewPageVC, animated: true, completion: nil)
        
    }
    
    private func setInitialLocationInEtangKernicole() {
        locationManager.region = MKCoordinateRegion(
            center: locationManager.initialLocation.coordinate,
            latitudinalMeters: 50000,
            longitudinalMeters: 60000)
        mapView.centerToLocation(locationManager.initialLocation)

        mapView.setCameraBoundary(
            MKMapView.CameraBoundary(coordinateRegion: locationManager.region),
          animated: true)

        mapView.setCameraZoomRange(locationManager.zoomRange, animated: true)
    }
    
    private func displayPloggingAnnotationItems() {
        ploggingService.load { result in
            switch result {
            case .success(let ploggingsResult):
                ploggings = ploggingsResult
                mapView.addAnnotations(PloggingLoader.init(ploggingService: ploggingService).createAnnotationFromPloggingModels(model: ploggingsResult))
            case .failure:
                userAlert(element: .locationSaved)
            }
        }
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
        
        guard let selected = ploggings.first(where: { $0.id == id }) else {
            print("***** oups! Could not load plogging informations")
            return
        }
        
        plogging = selected
        
        performSegue(withIdentifier: SegueIdentifier.fromMapToPlogging.identifier, sender: self)
    }
}


extension MapViewController: PresentationViewControllerDelegate {
    func didPressDismissButton() {
        
        // get user geo location
        locationManager.getUserGeoLocation()
        
        // Set initial location in etang Kernicole
        setInitialLocationInEtangKernicole()
        
        // display PloggingAnnotation items
        displayPloggingAnnotationItems()
    }
}
