//
//  PersonalPloggingViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 14/11/2022.
//

import UIKit

class PersonalPloggingViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    
    private let repository = PloggingCoreDataManager(
        coreDataStack: CoreDataStack(),
        managedObjectContext: CoreDataStack().viewContext)
    
    private var ploggingsUI: [PloggingUI] = []
    private var ploggingsSection: [[PloggingUI]] = [[], []]
    private var ploggingUI: PloggingUI?
    
    private var dateNowInteger: Date = Date()
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        displayPersonalPloggings()
        
//        dateNowInteger = Date()
        
        createDataSection()
        tableView.reloadData()
    }
    
    
    // MARK: - Display Personal Races
    
    private func displayPersonalPloggings() {
        getPersonalPloggings()
                
        if ploggingsUI.isEmpty {
            userAlert(element: AlertType.noPersonalPlogging)
        }
    }
    
    private func getPersonalPloggings() {
        do {
            let ploggingsCD = try repository.getEntities()
            ploggingsUI = ploggingsCD.map { PloggingUI(ploggingCD: $0, beginning: repository.stringDateToDateObject(dateString: $0.beginning ?? "")) }
        } catch {
            fatalError()
        }
    }
    
    // MARK: - Configure Table View
    
    private func configureTableView() {
        let cellNib = UINib(nibName: PloggingTableViewCell.identifier, bundle: .main)
        tableView.register(cellNib, forCellReuseIdentifier: PloggingTableViewCell.identifier)
    }
    
    // MARK: - Configure data with sections
    
    private func createDataSection() {
        ploggingsSection = [[], []]
        
        ploggingsUI.forEach { race in
            let date =  race.beginning
            
            if date > dateNowInteger {
                // upcoming races
                ploggingsSection[0].append(race)
            } else {
                // past races
                ploggingsSection[1].append(race)
            }
        }
    }
    
    // MARK: - View details of plogging
    
    func sendPloggingsUI() {
        performSegue(withIdentifier: SegueIdentifier.fromPersonalToDetails.identifier, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.fromPersonalToDetails.identifier {
            let viewController = segue.destination as? PloggingDetailsViewController
            viewController?.ploggingUI = ploggingUI
        }
    }
}


extension PersonalPloggingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        ploggingsSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ploggingsSection[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PloggingTableViewCell.identifier) as? PloggingTableViewCell ?? PloggingTableViewCell()
        
        if !ploggingsUI.isEmpty {
            cell.configure(plogging: ploggingsUI[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        ploggingUI = ploggingsUI[indexPath.row]
        sendPloggingsUI()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0) ? "upcoming ploggings" : "past ploggings"
    }
}
