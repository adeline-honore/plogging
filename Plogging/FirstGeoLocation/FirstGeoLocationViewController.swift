//
//  FirstGeoLocationViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 01/10/2022.
//

import UIKit
import MapKit

class FirstGeoLocationViewController: UIViewController {
    
    // MARK: - Properties
    
    private var firstGeoLocationView: FirstGeoLocationView!
    
    private var locationManager = LocationManager.shared
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    var searchCompleter = MKLocalSearchCompleter()
    //private let segueToMap = "segueToMap"
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstGeoLocationView = view as? FirstGeoLocationView
        configureView()
        searchCompleter.delegate = self
        searchResultsTableView.isHidden = true
    }
    
    private func configureView() {
        firstGeoLocationView.saveLocationButton.titleLabel?.text = "Save"
    }
    
    
    // MARK: - Lcation from GeoLocation
    
    @IBAction func didTapGeoLocationButton() {
        locationManager.getUserGeoLocation()
    }
    
    
    // MARK: - Save location
    
    
    @IBAction func didTapSaveLocation() {
        performSegue(withIdentifier: SegueIdentifier.fromFirstToMap.identifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueIdentifier.fromFirstToMap.identifier {
            let vc = segue.destination as! UITabBarController
        }
    }
}



extension FirstGeoLocationViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResultsTableView.isHidden = false
        searchCompleter.queryFragment = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResultsTableView.isHidden = true
    }
}


extension FirstGeoLocationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationManager.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = LocationManager.shared.searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

extension FirstGeoLocationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = locationManager.searchResults[indexPath.row]
        
        locationManager.getLocationFromLocalSearchCompletion(completion: completion)
        
        firstGeoLocationView.locationSearchBar.text = completion.title
        searchResultsTableView.isHidden = true
    }
}

extension FirstGeoLocationViewController: MKLocalSearchCompleterDelegate {

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        locationManager.searchResults = completer.results
        searchResultsTableView.reloadData()

    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}
