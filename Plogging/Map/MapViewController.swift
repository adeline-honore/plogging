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

    private var ploggingService = PloggingService()

    static var ploggings: [Plogging] = []

    private var ploggingsUI: [PloggingUI] = []
    private var ploggingUI: PloggingUI?

    private let popUpModal: PopUpModalViewController = PopUpModalViewController()

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
            // display PloggingAnnotation items
            displayPloggingAnnotationItems()
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

    private func displayPloggingAnnotationItems() {
        ploggingService.load { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let ploggingsResult):
                    self.createPloggingAnnotationItems(ploggingList: ploggingsResult)
                case .failure:
                    self.popUpModal.userAlert(element: .network, viewController: self)
                }
            }
        }
    }

    private func createPloggingAnnotationItems(ploggingList: [Plogging]) {
        // 1 filtrer la liste de ploggins result
        // Transformer ploggings result en plogging UI
        // creer annotations depuis plogging UI
//        MapViewController.ploggings = ploggingList
//        self.mapView.addAnnotations(PloggingLoader.init(ploggingService: self.ploggingService ).createAnnotationFromPloggingModels(model: ploggingList))
        self.ploggingsUI = transformPloggingsToPloggingsUI(ploggings: filterPloggingList(ploggingList: ploggingList))
        self.mapView.addAnnotations(PloggingLoader.init(ploggingService: self.ploggingService ).createAnnotationFromPloggingModels(model: self.ploggingsUI))
    }

    private func filterPloggingList(ploggingList: [Plogging]) -> [Plogging] {
//        let now = Date()
        let timestamp = Int(NSDate().timeIntervalSince1970)
        
        var upcommingPloggingList: [Plogging] = []
        ploggingList.forEach { item in
            if item.beginning > timestamp {
                upcommingPloggingList.append(item)
            }
//            let itemDate = item.stringDateToDateObject(dateString: item.convertIntegerTimestampToStringDate())
//            if itemDate > now {
//                upcommingPloggingList.append(item)
//            }
        }
        MapViewController.ploggings = upcommingPloggingList
        return upcommingPloggingList
    }

    private func transformPloggingsToPloggingsUI(ploggings: [Plogging]) -> [PloggingUI] {
//        let ploggingListFitered = filterPloggingList(ploggingList: ploggings)

        let array = ploggings.map { PloggingUI(plogging: $0, scheduleTimestamp: $0.beginning, scheduleString: PloggingUI().displayUIDateFromIntegerTimestamp(timestamp: $0.beginning)) }

        ploggingsUI = array
        return array
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

        annotationView.markerTintColor = .white
        annotationView.glyphImage = glyphImage
        annotationView.glyphTintColor = Color().appColor
        annotationView.subtitleVisibility = .hidden

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
