//
//  FirstGeoLocationViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 01/10/2022.
//

import UIKit

class FirstGeoLocationViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    private var firstGeoLocationView: FirstGeoLocationView!
    
    private var locationTools = LocationTools.shared
    
    
    private let segueToMap = "segueToMap"
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstGeoLocationView = view as? FirstGeoLocationView
        configureView()
        firstGeoLocationView.searchTextField.delegate = self
    }
    
    private func configureView() {
        firstGeoLocationView.saveLocationButton = firstGeoLocationView.saveLocationButton.configureOkButton(title: "Save", frame: CGRect(x: 0, y: 0, width: firstGeoLocationView.frame.width - 100, height: (firstGeoLocationView.frame.width - 100) * 0.2), target: self)
    }
    
    
    // MARK: - Location from textField

    @IBAction func didEditingChangedTextField(_ sender: UITextField) {
        locationTools.textFieldDidChange(textField: sender)
        
        firstGeoLocationView.suggestionLabel.text = locationTools.suggestion
    }
    
    @IBAction func didTapYesButton() {
        saveUserEntryLocation()
    }
    
    private func saveUserEntryLocation() {
        // TODO : mettre dans userDefaults et sauvegarder ailleurs
        
        userAlert(element: .locationSaved)
    }
    
    private func showSuggestion(_ suggestion: String) {
        firstGeoLocationView.suggestionLabel.text = suggestion
    }
    
    
    // MARK: - Lcation from GeoLocation
    
    
    // MARK: - Save location
    
    
    @IBAction func didTapSaveLocation() {
        performSegue(withIdentifier: segueToMap, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segueToMap {
            let vc = segue.destination as! UITabBarController
        }
    }
}
