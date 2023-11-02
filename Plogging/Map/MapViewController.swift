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

        } else {
            // get user geo location
            if isInternetAvailable() {
                locationManager.getUserGeoLocation()
            } else {
                popUpModal.userAlert(element: .internetNotAvailable, viewController: self)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if isInternetAvailable() {
            displayPloggingAnnotationItems()
        }
    }

    // MARK: - App overview page

    private func displayAppOverviewPage() {
        performSegue(withIdentifier: SegueIdentifier.appOverviewPage.identifier, sender: nil)
    }

    // MARK: - Initial Location on Map

    private func setInitialLocation() {
        mapView.centerToLocation(userLocation)
    }

    private func displayPloggingAnnotationItems() {
        ploggingService.load { result in
            switch result {
            case .success(let ploggingsResult):
                self.createPloggingAnnotationItems(ploggingList: ploggingsResult)
            case .failure:
                self.popUpModal.userAlert(element: .network, viewController: self)
            }
        }
    }
    

    private func createPloggingAnnotationItems(ploggingList: [Plogging]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            MapViewController.ploggings = ploggingList
            self.mapView.addAnnotations(PloggingLoader.init(ploggingService: self.ploggingService ).createAnnotationFromPloggingModels(model: ploggingList))
            self.ploggingsUI = self.transformPloggingsToPloggingsUI(ploggings: MapViewController.ploggings)
        }
    }

    private func filterPloggingList(ploggingList: [Plogging]) -> [Plogging] {
        let now = Date()
        var upcommingPloggingList: [Plogging] = []
        ploggingList.forEach { item in
            let itemDate = item.stringDateToDateObject(dateString: item.beginning)
            if itemDate > now {
                upcommingPloggingList.append(item)
            }
        }
        return upcommingPloggingList
    }

    private func transformPloggingsToPloggingsUI(ploggings: [Plogging]) -> [PloggingUI] {
        let ploggingListFitered = filterPloggingList(ploggingList: ploggings)

        let array = ploggingListFitered.map { PloggingUI(plogging: $0, schedule: $0.stringDateToDateObject(dateString: $0.beginning)) }

            return array
    }

    // MARK: - Send datas thanks segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == SegueIdentifier.appOverviewPage.identifier {
            let overVC = segue.destination as? PresentationViewController
            overVC?.presentationViewControllerDelegate = self

        } else if segue.identifier == SegueIdentifier.fromMapToPlogging.identifier {
            let viewController = segue.destination as? PloggingDetailsViewController
            viewController?.ploggingUI = ploggingUI
        } else if segue.identifier == SegueIdentifier.fromMapToSignInOrUp.identifier {
            _ = segue.destination as? SignInOrUpViewController
        } else if segue.identifier == SegueIdentifier.fromMapToCreatePlogging.identifier {
            if UserDefaults.standard.string(forKey: UserDefaultsName.emailAddress.rawValue) == nil {
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
        performSegue(withIdentifier: SegueIdentifier.fromMapToCreatePlogging.identifier, sender: self)
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
        if isInternetAvailable() {
            locationManager.getUserGeoLocation()
        } else {
            popUpModal.userAlert(element: .internetNotAvailable, viewController: self)
        }
    }
}

extension MapViewController: CreatePloggingViewControllerDelegate {
    func ploggingIsCreated(ploggingUICreated: PloggingUI) {
        let alertVC = UIAlertController(title: nil, message: "Awesome ! \nyou create a new plogging race. \nIt will beginning \(ploggingUICreated.dateToDisplayedString(date: ploggingUICreated.beginning)) \nat \(ploggingUICreated.place) \nfor \(ploggingUICreated.distance) km.", preferredStyle: .alert)
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

//        // display PloggingAnnotation items
//        displayPloggingAnnotationItems()

    }
}

extension MapViewController: PopUpModalDelegate {
    func didValidateAction() {
        performSegue(withIdentifier: SegueIdentifier.fromMapToSignInOrUp.identifier, sender: self)
    }
}
