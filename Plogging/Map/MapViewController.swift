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
    private var plogging: Plogging?
    
    private var ploggingsUI: [PloggingUI] = []
    private var ploggingUI: PloggingUI?
    
    let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
    
    var region: MKCoordinateRegion?
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // on boarding page
        
//        if !UserDefaults.standard.bool(forKey: "ExecuteOnce") {
            displayAppOverviewPage()
//            UserDefaults.standard.set(true, forKey: "ExecuteOnce")
//
//        } else {
//            // get user geo location
//            locationManager.getUserGeoLocation()
//
//            // Set initial location in etang Kernicole
//            setInitialLocationInEtangKernicole()
//
//            // display PloggingAnnotation items
//            displayPloggingAnnotationItems()
//        }
    }
    
    
    // MARK: - App overview page
    
    private func displayAppOverviewPage() {
        performSegue(withIdentifier: SegueIdentifier.appOverviewPage.identifier, sender: nil)
    }
    
    private func setInitialLocationInEtangKernicole() {
        region = MKCoordinateRegion(
            center: locationManager.initialLocation.coordinate,
            latitudinalMeters: 50000,
            longitudinalMeters: 60000)
        mapView.centerToLocation(locationManager.initialLocation)

        guard let region = region else {
            return
        }

        mapView.setCameraBoundary(
            MKMapView.CameraBoundary(coordinateRegion: region),
          animated: true)

        mapView.setCameraZoomRange(zoomRange, animated: true)
    }
    
    private func displayPloggingAnnotationItems() {
        ploggingService.load { result in
            switch result {
            case .success(let ploggingsResult):
                ploggings = ploggingsResult
                mapView.addAnnotations(PloggingLoader.init(ploggingService: ploggingService).createAnnotationFromPloggingModels(model: ploggingsResult))
                self.ploggingsUI = transformPloggingsToPloggingsUI(ploggings: ploggings)
            case .failure:
                userAlert(element: .locationSaved)
            }
        }
    }
    
    private func transformPloggingsToPloggingsUI(ploggings: [Plogging]) -> [PloggingUI] {
        
        let array = ploggings.map { PloggingUI(plogging: $0) }
            
            return array
    }
    
    
    // MARK: - Send datas thanks segue
    
    func sendPloggingsUI() {
        performSegue(withIdentifier: SegueIdentifier.fromMapToPlogging.identifier, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueIdentifier.appOverviewPage.identifier {
            let overVC = segue.destination as? PresentationViewController
            //overVC?.presentationViewControllerDelegate = self
            
            EndPresentationViewController().presentationViewControllerDelegate = self
            
        } else if segue.identifier == SegueIdentifier.fromMapToPlogging.identifier {
            let viewController = segue.destination as? PloggingDetailsViewController
            viewController?.ploggingsUI = ploggingsUI
            viewController?.ploggingUI = ploggingUI
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
        
        guard let selected = ploggingsUI.first(where: { $0.id == id }) else {
            print("***** oups! Could not load plogging informations")
            return
        }
        
        ploggingUI = selected
        
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
