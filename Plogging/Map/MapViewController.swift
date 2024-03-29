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
    private var getPloggingService = PloggingService(network: PloggingNetwork())
    private var getImageService = ImageService(network: ImageNetwork())

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
         displayOrNotOnBoardingPage()
    }

    func displayOrNotOnBoardingPage() {
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
        getPloggingService.getPloggingList { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let ploggingsResult):
                    MapViewController.ploggings = ploggingsResult
                    self.ploggingsUI = transformPloggingsToPloggingsUI(ploggings: filterPloggingList(ploggings: ploggingsResult))
                    self.getPloggingMainImage()
                case .failure:
                    self.popUpModal.userAlert(element: .network, viewController: self)
                }
            }
        }
    }

    private func transformPloggingsToPloggingsUI(ploggings: [Plogging]) -> [PloggingUI] {
        let array = ploggings.map { PloggingUI(plogging: $0, scheduleTimestamp: $0.beginning, scheduleString: PloggingUI().displayUIDateFromIntegerTimestamp(timestamp: $0.beginning), isTakingPartUI: isUserTakingPart(ploggingPloggers: $0.ploggers, userEmail: UserDefaults.standard.string(forKey: "emailAddress") ?? "")) }

        ploggingsUI = array
        return array
    }

    // MARK: - Associate Ploggings With Their Images

    func getPloggingMainImage() {

        for validPlogging in ploggingsUI {
            guard let ploggingsIndex = self.ploggingsUI.firstIndex(where: { $0.id == validPlogging.id}) else { return }

            getImageService.getImage(ploggingId: validPlogging.id) { result in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    switch result {
                    case .success(let photoResult):
                        self.ploggingsUI[ploggingsIndex].mainImage = photoResult
                    case .failure:
                        self.ploggingsUI[ploggingsIndex].mainImage = icon
                    }
                    self.createPloggingAnnotationItems()
                }
            }
        }
    }

    // MARK: - Create Plogging Annotations Items

    func createPloggingAnnotationItems() {
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
              let glyphImage = UIImage(systemName: "arrow.3.trianglepath") else {return nil}

        let identifier = ""

        if let dequedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            annotationView = dequedView
        } else {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }

        guard let current = ploggingsUI.first(where: { $0.id == annotation.subtitle }) else { return MKAnnotationView() }

        annotationView.markerTintColor = current.isTakingPart ? Color().blue : Color().grey
        annotationView.glyphImage = glyphImage
        annotationView.glyphTintColor = .white
        annotationView.subtitleVisibility = .hidden

        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        guard let id = view.annotation?.subtitle else { return }

        guard let selected = ploggingsUI.first(where: { $0.id == id }) else {
            return
        }

        ploggingUI = selected

        performSegue(withIdentifier: SegueIdentifier.fromMapToPlogging.rawValue, sender: self)

        view.isSelected = false
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

extension MapViewController {
    func filterPloggingList(ploggings: [Plogging]) -> [Plogging] {
        let timestamp = Int(NSDate().timeIntervalSince1970)

        var upcommingPloggingList: [Plogging] = []
        ploggings.forEach { item in
            if item.beginning > timestamp {
                upcommingPloggingList.append(item)
            }
        }
        return upcommingPloggingList
    }
}
