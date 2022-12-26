//
//  LocalSearchCompletionViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 14/12/2022.
//

import MapKit

protocol LocalSearchCompletionViewControllerDelegate: AnyObject {
    func departurePlaceChoosen(result: MKLocalSearchCompletion)
}

class LocalSearchCompletionViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    // MARK: - Properties
    
    weak var localSearchCompletionViewControllerDelegate: LocalSearchCompletionViewControllerDelegate?
    private var searchCompleter = MKLocalSearchCompleter()
    private var localSearchCompletion = LocalSearchCompletion()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        locationSearchBar.delegate = self
        locationSearchBar.becomeFirstResponder()
        
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchResultsTableView.isHidden = true
        
        searchCompleter.delegate = self
    }
    
    // MARK: - Cancel button
    
    @IBAction func didTapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Place auto completion

extension LocalSearchCompletionViewController: UISearchBarDelegate {

     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         searchResultsTableView.isHidden = false
         searchCompleter.queryFragment = searchText
         
         if searchBar.text == "" {
             searchResultsTableView.isHidden = true
         }
     }
 }

 extension LocalSearchCompletionViewController: UITableViewDataSource {

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

 extension LocalSearchCompletionViewController: UITableViewDelegate {

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
         
         localSearchCompletionViewControllerDelegate?.departurePlaceChoosen(result: localSearchCompletion.searchResults[indexPath.row])
         
         self.dismiss(animated: true, completion: nil)
     }
 }

 extension LocalSearchCompletionViewController: MKLocalSearchCompleterDelegate {

     func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
         localSearchCompletion.searchResults = completer.results
         searchResultsTableView.reloadData()
     }

     func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
         // handle error
     }
 }
