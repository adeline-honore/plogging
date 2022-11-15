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
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayPersonalPloggings()
    }
    
    
    // MARK: - Display Personal Races
    
    private func displayPersonalPloggings() {
        getPersonalPloggings()
        
        tableView.reloadData()
        
        if ploggingsUI.isEmpty {
            print("no personal races")
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
        //recipesTableView.rowHeight = UITableView.automaticDimension
    }
}


extension PersonalPloggingViewController: UITextFieldDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ploggingsUI.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PloggingTableViewCell.identifier) as? PloggingTableViewCell ?? PloggingTableViewCell()
        
        cell.configure(plogging: ploggingsUI[indexPath.row])
        
        return cell
    }
}
