//
//  PloggingDetailsViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 20/10/2022.
//

import UIKit

protocol ChooseImageDelegate: AnyObject {
    func chooseImage(source: UIImagePickerController.SourceType)
}

protocol PloggingDetailsViewControllerDelegate: AnyObject {
    func didSetMainImage(id: String, modifiedPlogging: PloggingUI)
}

class PloggingDetailsViewController: UIViewController {

    // MARK: - Properties
    
    private var ploggingDetailsView: PloggingDetailsView!
    
    private let repository = PloggingCoreDataManager(
        coreDataStack: CoreDataStack(),
        managedObjectContext: CoreDataStack().viewContext)
        
    var ploggingUI: PloggingUI?
    
    weak var delegate: PloggingDetailsViewControllerDelegate?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ploggingDetailsView = view as? PloggingDetailsView
        
        // TODO : check if user is admin of race to display or not editMainImageButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        guard let ploggingUI = ploggingUI else {
            return
        }
        ploggingDetailsView.configure(plogging: ploggingUI)
    }
    
    // MARK: - Toogle to take part at race
    
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
    
    // MARK: - Set main image
    
    @IBAction func didTapEditMainImage() {
        chooseImage(source: .photoLibrary)
    }
}


extension PloggingDetailsViewController: ChooseImageDelegate {
    func chooseImage(source: UIImagePickerController.SourceType) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = source
        imagePickerController.delegate = self

        present(imagePickerController, animated: true, completion: nil)
    }
}

extension PloggingDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        guard let choosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
                
        ploggingDetailsView.mainImage.image = choosenImage
        
        picker.dismiss(animated: true, completion: nil)
              
        ploggingUI?.mainImage = choosenImage
        ploggingUI?.mainImageBinary = choosenImage.jpegData(compressionQuality: 1.0)
        
        guard let ploggingUI = ploggingUI else { return }
        
        delegate?.didSetMainImage(id: ploggingUI.id, modifiedPlogging: ploggingUI)
        
        do {
            try repository.setEntity(place: ploggingUI.place, ploggingUI: ploggingUI)
        } catch {
            print(error)
        }
        
    }
}
