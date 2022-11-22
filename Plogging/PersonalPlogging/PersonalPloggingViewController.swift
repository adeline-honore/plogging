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
    
    var ploggingsCD: [PloggingCD] = []
    var ploggingsUI: [PloggingUI] = []
    var ploggingsSection: [[PloggingUI]] = [[], []]
    var ploggingsUIIndex: Int = 0
    
    var dateNowInteger: Double = 0
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayPersonalPloggings()
        
        dateNowInteger = dateToDoubleTimestamp(date: Date())
        
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
            ploggingsCD = try repository.getEntities()
                ploggingsUI = getPloggingsUIFromEntities(entities: ploggingsCD)
        } catch {
            fatalError()
        }
    }
    
    private func getPloggingsUIFromEntities(entities: [PloggingCD]) -> [PloggingUI] {
        
        var ploggings = [PloggingUI]()
        
        ploggings = entities.map {
            PloggingUI(ploggingCD: $0)
        }
        
        return ploggings
    }
    
    
    // MARK: - Configure Table View
    
    private func configureTableView() {
        let cellNib = UINib(nibName: "PloggingTableViewCell", bundle: .main)
        tableView.register(cellNib, forCellReuseIdentifier: PloggingTableViewCell.identifier)
    }
    
    // MARK: - Configure data with sections
    
    private func createDataSection() {
        ploggingsSection = [[], []]
        
        ploggingsUI.forEach { race in

            if race.beginning > dateNowInteger {
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
            viewController?.detailsDelegate = self
            viewController?.ploggingsUI = ploggingsUI
            viewController?.ploggingsUIIndex = ploggingsUIIndex
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
        ploggingsUIIndex = indexPath.row
        sendPloggingsUI()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0) ? "upcoming ploggings" : "past ploggings"
    }
}

extension PersonalPloggingViewController: PloggingDetailsViewControllerDelegate {
    func didChangeIsTakingPartState(id: String, ploggingChanged: PloggingUI) {
        
            ploggingsUI = ploggingsUI.filter { $0.id != id }
    }
}
