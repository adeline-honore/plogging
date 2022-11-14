//
//  CreatePloggingViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 14/11/2022.
//

import UIKit
import MapKit

class CreatePloggingViewController: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    
    // MARK: - Properties
    
    private var createPloggingView: CreatePloggingView!
    
    private var localSearchCompletion = LocalSearchCompletion()
    
    var searchCompleter = MKLocalSearchCompleter()
    
    var when: String?
    
    var distanceArray: [String] = []
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createPloggingView = view as? CreatePloggingView
        
        searchCompleter.delegate = self
        searchResultsTableView.isHidden = true
        distanceArray = returnDistance()
    }

    
    // MARK: - Date Picker View
    
    @IBAction func getDateFromPickerView() {
        let date = createPloggingView.whenDatePicker.date
        
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"

        when = dateFormatter.string(from: date)
    }
    
    
    // MARK: - Distance Picker View
    
    private func returnDistance() -> [String] {
        
        for i in stride(from: 2, through: 20, by: 2) {
            distanceArray.append(String(i))
        }
        return distanceArray
    }
    
    // MARK: - Save as PloggingCD


}


// MARK: - Place auto completion

extension CreatePloggingViewController: UISearchBarDelegate {

     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         searchResultsTableView.isHidden = false
         searchCompleter.queryFragment = searchText
     }

     func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
         searchResultsTableView.isHidden = true
     }
 }


 extension CreatePloggingViewController: UITableViewDataSource {

     func numberOfSections(in tableView: UITableView) -> Int {
         return 1
     }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return localSearchCompletion.searchResults.count
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let searchResult = localSearchCompletion.searchResults[indexPath.row]
         let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
         cell.textLabel?.text = searchResult.title
         cell.detailTextLabel?.text = searchResult.subtitle
         return cell
     }
 }

 extension CreatePloggingViewController: UITableViewDelegate {

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)

         let completion = localSearchCompletion.searchResults[indexPath.row]

         localSearchCompletion.getCoordinateFromLocalSearchCompletion(completion: completion)

         createPloggingView.locationSearchBar.text = completion.title
         searchResultsTableView.isHidden = true
     }
 }

 extension CreatePloggingViewController: MKLocalSearchCompleterDelegate {

     func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
         localSearchCompletion.searchResults = completer.results
         searchResultsTableView.reloadData()

     }

     func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
         // handle error
     }
 }

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
}
