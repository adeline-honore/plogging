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
    
    private let repository = PloggingCoreDataManager(
        coreDataStack: CoreDataStack(),
        managedObjectContext: CoreDataStack().viewContext)
    
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
        when = returnStringFromDate(date: Date())
    }

    
    // MARK: - Date Picker View
    
    @IBAction func getDateFromPickerView() {
        when = returnStringFromDate(date: createPloggingView.whenDatePicker.date)
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
        do {
            try repository.createEntity(ploggingUI: createPloggingUI())
        } catch {
            fatalError()
        }
    }
    
    private func createPloggingUI() -> PloggingUI {
        
        //let id = UUID().uuidString
        let id = "plogging2"
        let admin = "admin1"
        let distance = 10.0
        
        guard let when = when,
              let place = createPloggingView.locationSearchBar.text
        else { fatalError() }
        
        
        let newPloggingUI = PloggingUI(id: id, admin: admin, beginning: when, place: place, isTakingPart: true, distance: distance)
        
        return newPloggingUI
    }
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
