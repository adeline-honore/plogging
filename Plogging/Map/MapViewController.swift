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
    private var userLocation: CLLocation = CLLocation()
    
    private var ploggingAnnotationLoader = PloggingLoader()
    private var networkService = NetworkService(network: Network())

    static var ploggings: [Plogging] = []

    private var ploggingsUI: [PloggingUI] = []
    private var ploggingUI: PloggingUI?

    private let popUpModal: PopUpModalViewController = PopUpModalViewController()
    private let icon = UIImage(imageLiteralResourceName: "icon")

    @IBOutlet weak var mapView: MKMapView!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.locationManagerDelegate = self

        // on boarding page
        if !UserDefaults.standard.bool(forKey: UserDefaultsName.executeOnce.rawValue) {
            displayAppOverviewPage()
            UserDefaults.standard.set(true, forKey: UserDefaultsName.executeOnce.rawValue)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !isInternetAvailable() {
            popUpModal.userAlert(element: .internetNotAvailable, viewController: self)
        } else {
            getApiPloggingList()
        }
    }

    // MARK: - App overview page

    private func displayAppOverviewPage() {
        performSegue(withIdentifier: SegueIdentifier.appOverviewPage.rawValue, sender: nil)
    }

    // MARK: - Initial Location on Map

    private func setInitialLocation() {
        mapView.centerToLocation(userLocation)
    }

    // MARK: - Get Plogging List From External Database, Filter And Convert That List

    private func getApiPloggingList() {
        networkService.getAPIPloggingList() { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let ploggingsResult):
                    MapViewController.ploggings = ploggingsResult
                    self.ploggingsUI = transformPloggingsToPloggingsUI(ploggings: filterPloggingList())
                    self.getPloggingMainImage()
                case .failure:
                    self.popUpModal.userAlert(element: .network, viewController: self)
                }
            }
        }
    }

    private func filterPloggingList() -> [Plogging] {
        let timestamp = Int(NSDate().timeIntervalSince1970)

        var upcommingPloggingList: [Plogging] = []
        MapViewController.ploggings.forEach { item in
            if item.beginning > timestamp {
                upcommingPloggingList.append(item)
            }
        }
        MapViewController.ploggings = upcommingPloggingList
        return upcommingPloggingList
    }

    private func transformPloggingsToPloggingsUI(ploggings: [Plogging]) -> [PloggingUI] {
        let array = ploggings.map { PloggingUI(plogging: $0, scheduleTimestamp: $0.beginning, scheduleString: PloggingUI().displayUIDateFromIntegerTimestamp(timestamp: $0.beginning), isTakingPartUI: isUserTakingPart(ploggingPloggers: $0.ploggers)) }

        ploggingsUI = array
        return array
    }

    // MARK: - Associate Ploggings With Their Images

    private func getPloggingMainImage() {

        for validPlogging in ploggingsUI {
            guard let ploggingsIndex = self.ploggingsUI.firstIndex(where: { $0.id == validPlogging.id}) else { return }

            networkService.getPloggingImage(ploggingId: validPlogging.id) { result in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    switch result {
                    case .success(let photoResult):
                        ploggingsUI[ploggingsIndex].mainImage = photoResult
                    case .failure:
                        ploggingsUI[ploggingsIndex].mainImage = icon
                    }
                    createPloggingAnnotationItems()
                }
            }
        }
    }

    // MARK: - Create Plogging Annotations Items

    private func createPloggingAnnotationItems() {
        let annotationList = ploggingAnnotationLoader.createAnnotationFromPloggingModels(model: ploggingsUI)

        annotationList.forEach { ploggingAnnotation in
            self.mapView.addAnnotation(ploggingAnnotation)
        }
    }

    // MARK: - Send datas thanks segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == SegueIdentifier.appOverviewPage.rawValue {
            let overVC = segue.destination as? PresentationViewController
            overVC?.presentationViewControllerDelegate = self

        } else if segue.identifier == SegueIdentifier.fromMapToPlogging.rawValue {
            let viewController = segue.destination as? PloggingDetailsViewController
            viewController?.ploggingUI = ploggingUI
        } else if segue.identifier == SegueIdentifier.fromMapToSignInOrUp.rawValue {
            _ = segue.destination as? SignInOrUpViewController
        } else if segue.identifier == SegueIdentifier.fromMapToCreatePlogging.rawValue {
            if UserDefaults.standard.string(forKey: "emailAddress") == nil {
                popUpModal.delegate = self
                popUpModal.userAlertWithChoice(element: .haveToLogin, viewController: self)
            } else {
                let viewController = segue.destination as? CreatePloggingViewController
                viewController?.delegate = self
            }
        }
    }

    // MARK: - Go to create a plogging

    @IBAction func didTapCreatePlogging(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: SegueIdentifier.fromMapToCreatePlogging.rawValue, sender: self)
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        var annotationView = MKMarkerAnnotationView()

        guard let annotation = annotation as? PloggingAnnotation,
              let glyphImage = UIImage(systemName: "trash.circle.fill") else {return nil}

        let identifier = ""

        if let dequedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            annotationView = dequedView
        } else {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }

        guard let current = ploggingsUI.first(where: { $0.id == annotation.subtitle }) else { return MKAnnotationView() }

        annotationView.markerTintColor = .white
        annotationView.glyphImage = glyphImage
        annotationView.glyphTintColor = current.isTakingPart ? .orange : .black;        annotationView.subtitleVisibility = .hidden

        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        guard let id = view.annotation?.subtitle else { return }

        guard let selected = ploggingsUI.first(where: { $0.id == id }) else {
            print("***** oups! Could not load plogging informations")
            return
        }

        ploggingUI = selected

        performSegue(withIdentifier: SegueIdentifier.fromMapToPlogging.rawValue, sender: self)
    }
    
    
    
    
//    func addUserAnnotation(coordinate: CLLocationCoordinate2D) {
//        let annotation = TemporaryUserAnnotation(coordinate: coordinate)
//        mapView.addAnnotation(annotation)
//        DispatchQueue.main.asyncAfter(wallDeadline: .now() + .seconds(1)) {
//            self.mapView.selectAnnotation(annotation, animated: true)
//        }
//    }
}

extension MapViewController: PresentationViewControllerDelegate {
    func didPressDismissButton() {
        // get user geo location
        if !isInternetAvailable() {
            popUpModal.userAlert(element: .internetNotAvailable, viewController: self)
        }
    }
}

extension MapViewController: CreatePloggingViewControllerDelegate {
    func ploggingIsCreated(ploggingUICreated: PloggingUI) {
        let alertVC = UIAlertController(title: "Awesome ! \nyou create a new plogging race.", message: "\(ploggingUICreated.beginningString) \nat \(ploggingUICreated.place) \nfor \(ploggingUICreated.distance) km.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

extension MapViewController: LocationManagerDelegate {
    func accessUserCoordinate(_ location: CLLocation) {
        userLocation = location

        // Set initial location center on user's location
        setInitialLocation()

        // display user location point
        mapView.showsUserLocation = true
    }
}

extension MapViewController: PopUpModalDelegate {
    func didValidateAction() {
        performSegue(withIdentifier: SegueIdentifier.fromMapToSignInOrUp.rawValue, sender: self)
    }
}
