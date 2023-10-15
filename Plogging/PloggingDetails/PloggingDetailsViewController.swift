//
//  PloggingDetailsViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 20/10/2022.
//

import UIKit

protocol PloggingDetailsViewControllerDelegate: AnyObject {
    func didSetPloggingPhoto(photoUI: PhotoUI, removePhoto: Bool)
}

class PloggingDetailsViewController: UIViewController {

    // MARK: - Properties
    
    private var ploggingDetailsView: PloggingDetailsView!
    private var isAdmin: Bool = false
    
    private let repository = PloggingCoreDataManager(
        coreDataStack: CoreDataStack(),
        managedObjectContext: CoreDataStack().viewContext)
        
    var ploggingUI: PloggingUI?
    
    weak var delegate: PloggingDetailsViewControllerDelegate?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ploggingDetailsView = view as? PloggingDetailsView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        guard let ploggingUI = ploggingUI else {
            return
        }
        ploggingDetailsView.configure(plogging: ploggingUI)
        isAdmin = ploggingUI.admin == UserDefaultsName.emailAddress.rawValue ? true : false
        displayEditMainImageButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.fromDetailsToCollectionView.identifier {
            let viewController = segue.destination as? PloggingCollectionViewController
            viewController?.delegate = self
            guard let ploggingUI else { return }
            viewController?.ploggingId = ploggingUI.id
            viewController?.isPloggingAdmin = isAdmin
            guard let photos = ploggingUI.photos else { return }
            viewController?.photos = photos
        }
        if segue.identifier == SegueIdentifier.fromDetailsToEmail.identifier {
            let viewController = segue.destination as? WhoIsTakingPartViewController
            viewController?.delegate = self
        }
    }
    
    // MARK: - Toogle to take part at race
    
    @IBAction func didTapIsTakingPartButton() {
        if isInternetAvailable() {
            toggleTakePart()
        } else {
            userAlert(element: .unableToSaveChangeInternet)
        }
    }
    
    private func toggleTakePart() {
        
        if ploggingUI?.isTakingPart == true {
            // if user already takes part at this plogging race then remove participation
            guard let emailIndex = ploggingUI?.ploggers?.firstIndex(where: {$0 == UserDefaults.standard.string(forKey: UserDefaultsName.emailAddress.rawValue)}) else {
                return
            }
            ploggingUI?.ploggers?.remove(at: emailIndex)
            ploggingUI?.isTakingPart = false
            saveTakePartChoice()
            userAlert(element: .isNotTakingPart)
        } else if ploggingUI?.isTakingPart == false && UserDefaults.standard.string(forKey: UserDefaultsName.emailAddress.rawValue) != nil  {
            participate()
        } else {
            performSegue(withIdentifier: SegueIdentifier.fromDetailsToEmail.identifier, sender: nil)
        }
    }
    
    private func saveTakePartChoice() {
        guard let ploggingUI else { return }
        
        do {
            try repository.setEntity(ploggingUI: ploggingUI)
            // TODO: modifier cloudkit
        } catch {
            fatalError()
        }
        
        ploggingDetailsView.manageIsTakingPartButton(button: ploggingDetailsView.isTakingPartButton, isTakingPart: ploggingUI.isTakingPart)
    }
    
    private func participate() {
        guard let email = UserDefaults.standard.string(forKey: UserDefaultsName.emailAddress.rawValue) else { return }
        ploggingUI?.ploggers?.append(email)
        ploggingUI?.isTakingPart = true
        saveTakePartChoice()
        userAlert(element: .isTakingPart)
    }
    
    // MARK: - Set main image
    
    @IBAction func didTapEditMainImage() {
        if isInternetAvailable() {
            chooseImage(source: .photoLibrary)
        } else {
            userAlert(element: .unableToSaveChangeInternet)
        }
    }
    
    private func displayEditMainImageButton () {
        ploggingDetailsView.editMainImageButton.isHidden = !isAdmin
    }
    
    // MARK: - Open mail app and send mail
    
    @IBAction func didTapMessageButton() {
        let addressMail = ploggingUI?.admin
        
        if let emailURL = URL(string: "mailto:\(String(describing: addressMail))"), UIApplication.shared.canOpenURL(emailURL) {
            UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
        } else {
            userAlert(element: .mailAppUnavailable)
        }
    }
    
    // MARK: - Display all race's photos
    
    @IBAction func didTapPhotosButton() {
        performSegue(withIdentifier: SegueIdentifier.fromDetailsToCollectionView.identifier, sender: nil)
    }
    
    // MARK: - Set images
    
    private func setImage(photo: PhotoUI, action: String) {
        do {
            switch action {
            case PhotoAction.create.rawValue:
                let photoToCreate = PhotoUI(name: photo.name, imageBinary: photo.imageBinary, image: photo.image, owner: returnPloggingCD())
                ploggingUI?.photos?.append(photoToCreate)
                try repository.createPhotoEntity(photoUI: photoToCreate)
            case PhotoAction.set.rawValue:
                if let index = ploggingUI?.photos?.firstIndex(where: {$0.name == photo.name}) {
                    ploggingUI?.photos?[index] = photo
                } else {
                    print("error")
                }
                try repository.setPhotoEntity(photo: photo)
            case PhotoAction.delete.rawValue:
                if let index = ploggingUI?.photos?.firstIndex(where: {$0.name == photo.name}) {
                    ploggingUI?.photos?.remove(at: index)
                } else {
                    print("error")
                }
                try repository.removePhotoEntity(photo: photo)
            default:
                return
            }
        } catch {
            print(error)
        }
    }
    
    private func returnPloggingCD() -> PloggingCD {
        
        guard let ploggingUI else { return PloggingCD() }
        
        do {
            let ploggingsCD = try repository.getEntities()
            
            guard let ploggingCD = ploggingsCD.first(where: {$0.id == ploggingUI.id}) else { return PloggingCD()}
            return ploggingCD
        } catch {
            print(error)
        }
        return PloggingCD()
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
        
        do {
            try repository.setEntity(ploggingUI: ploggingUI)
        } catch {
            print(error)
        }
        
    }
}

// MARK: - Set Images

extension PloggingDetailsViewController: DetailsCollectionDelegate {
    func didSetPhoto(photo: PhotoUI, action: String) {
        setImage(photo: photo, action: action)
        // TODO: save into Cloudkit
    }
}


// MARK: - New Email address
extension PloggingDetailsViewController: WhoIsTakingPartDelegate {
    func getEmailAddress() {
        participate()
    }
}
