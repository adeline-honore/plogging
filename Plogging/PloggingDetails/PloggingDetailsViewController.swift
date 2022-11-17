//
//  PloggingDetailsViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 20/10/2022.
//

import UIKit

class PloggingDetailsViewController: UIViewController {

    // MARK: - Properties
    
    private var ploggingDetailsView: PloggingDetailsView!
    
    private let repository = PloggingCoreDataManager(
        coreDataStack: CoreDataStack(),
        managedObjectContext: CoreDataStack().viewContext)
    
    var ploggingUI: PloggingUI?
    var ploggingsUI: [PloggingUI]?
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ploggingDetailsView = view as? PloggingDetailsView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let ploggingUI = ploggingUI else {
            return
        }

        ploggingDetailsView.configure(plogging: ploggingUI)
    }
    
    
    @IBAction func didTapIsTakingPartButton() {
        toggleTakePart()
    }
    
    private func toggleTakePart() {
        guard var plogging = ploggingUI else {
            return
        }
                
        if plogging.isTakingPart { // if user already takes part at this plogging race then remove participation
            do {
                try repository.removeEntity(id: plogging.id)
                plogging.isTakingPart = false
                userAlert(element: AlertType.isNotTakingPart)
            } catch {
                fatalError()
            }
            
        } else { // if user wants take part, isTakingPart = true
            do {
                try repository.createEntity(ploggingUI: plogging)
                plogging.isTakingPart = true
                userAlert(element: AlertType.isTakingPart)
            } catch {
                fatalError()
            }
        }
        
            ploggingDetailsView.manageIsTakingPartButton(button: ploggingDetailsView.isTakingPartButton, isTakingPart: plogging.isTakingPart)
        
        ploggingUI = plogging
    }
}
