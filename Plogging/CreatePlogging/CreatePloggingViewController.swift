//
//  CreatePloggingViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 14/11/2022.
//

import UIKit
import MapKit

class CreatePloggingViewController: UIViewController {
    
    // MARK: - Properties
    
    private var createPloggingView: CreatePloggingView!
        
    private let repository = PloggingCoreDataManager(
        coreDataStack: CoreDataStack(),
        managedObjectContext: CoreDataStack().viewContext)
        
    private var newPloggingUI: PloggingUI = PloggingUI(id: "", admin: "", beginning: Date(), place: "", latitude: 0, longitude: 0, isTakingPart: false, distance: 0, ploggers: [""])
    private var when: Date = Date()
    
    private var distanceArray: [String] = []
    private var distanceSelected: String = ""
    
    private var placeCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPloggingView = view as? CreatePloggingView
        
        distanceArray = returnDistance()
        distanceSelected = distanceArray[0]
    }

    // MARK: - Date Picker View
    
    @IBAction func getDateFromPickerView() {
        when = createPloggingView.whenDatePicker.date
    }
    
    // MARK: - Distance Picker View
    
    private func returnDistance() -> [String] {
        
        for i in stride(from: 2, through: 20, by: 2) {
            distanceArray.append(String(i))
        }
        return distanceArray
    }
    
    
    // MARK: - Save as PloggingCD

    @IBAction func didTapSavePlogging(_ sender: UIBarButtonItem) {
        savePlogging()
    }
    
    private func savePlogging() {
        setPloggingElement()
        
        if newPloggingUI.place.isEmpty {
            userAlert(element: .ploggingWithoutPlace)
        }
        else if newPloggingUI.id.isEmpty ||
            newPloggingUI.admin.isEmpty ||
            newPloggingUI.latitude == nil ||
            newPloggingUI.longitude == nil ||
            newPloggingUI.isTakingPart == false ||
            newPloggingUI.distance == 0 {
            userAlert(element: .ploggingNotSaved)
        }
        else {
            // save into CoreData
            do {
                try repository.createEntity(ploggingUI: newPloggingUI)
                // TO DO send ploggingUI in cloud
                displayPersonalPloggingsRaces()
            } catch {
                userAlert(element: AlertType.ploggingNotSaved)
                fatalError()
            }
        }
    }
        
    private func setPloggingElement() {
        
        //let id = UUID().uuidString
        let id = "plogging2"
        let admin = "admin1"
        let ploggers = [admin]
        
        guard let place = createPloggingView.resultLocationLabel.text,
              let distance = Double(distanceSelected)
        else { return }
        
        newPloggingUI = PloggingUI(id: id, admin: admin, beginning: when, place: place, latitude: placeCoordinate.latitude, longitude: placeCoordinate.longitude, isTakingPart: true, distance: distance, ploggers: ploggers)
    }
    
    // MARK: - Segue
    
    private func displayPersonalPloggingsRaces() {
        performSegue(withIdentifier: SegueIdentifier.fromCreateToPersonnal.identifier, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueIdentifier.fromCreateToPersonnal.identifier {
            _ = segue.destination as? PersonalPloggingViewController
        }
        
        if segue.identifier == SegueIdentifier.fromCreateToLocalSearch.identifier {
            let overVC = segue.destination as? LocalSearchCompletionViewController
            overVC?.localSearchCompletionViewControllerDelegate = self
        }
    }
}

// MARK: - PickerView

extension CreatePloggingViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return distanceArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return distanceArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        distanceSelected = distanceArray[row]
    }
}

// MARK: - LocalSearchCompletionViewControllerDelegate

extension CreatePloggingViewController: LocalSearchCompletionViewControllerDelegate {
    func departurePlaceChoosen(result: MKLocalSearchCompletion, coordinate: CLLocationCoordinate2D) {
        createPloggingView.resultLocationLabel.text = result.title
        placeCoordinate = coordinate
    }
}
