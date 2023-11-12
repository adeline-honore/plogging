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

    private let popUpModal: PopUpModalViewController = PopUpModalViewController()

    private var ploggingService = PloggingService()
    private let repository = PloggingCoreDataManager(
        coreDataStack: CoreDataStack(),
        managedObjectContext: CoreDataStack().viewContext)

    var ploggingUI: PloggingUI?

    weak var delegate: PloggingDetailsViewControllerDelegate?

    private var isConnectedUser: Bool = false

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

        isAdmin = ploggingUI.admin == UserDefaults.standard.string(forKey: "emailAddress") ? true : false

        ploggingDetailsView.configure(plogging: ploggingUI, isAdmin: isAdmin)

        isConnectedUser = UserDefaults.standard.string(forKey: "emailAddress") != nil
    }

    // MARK: - Toogle to take part at race For No Admin User

    @IBAction func didTapIsTakingPartButton() {
        // only if user is not admin of race
        if isInternetAvailable() && isConnectedUser {
            toggleTakePart()
        } else if isInternetAvailable() && !isConnectedUser {
            popUpModal.delegate = self
            popUpModal.userAlertWithChoice(element: .haveToLogin, viewController: self)
        } else {
            PopUpModalViewController().userAlert(element: .unableToSaveChangeInternet, viewController: self)
        }
    }

    private func toggleTakePart() {
        if ploggingUI?.isTakingPart == true {
            // if user already takes part at this plogging race then remove participation
            PopUpModalViewController().userAlertWithChoice(element: .wantToNoParticipate, viewController: self)
        } else {
            PopUpModalViewController().userAlertWithChoice(element: .wantToParticipate, viewController: self)
        }
    }

    private func saveTakePartChoice() {
        guard let emailIndex = ploggingUI?.ploggers?.firstIndex(where: {$0 == UserDefaults.standard.string(forKey: "emailAddress")}) else {
            return
        }

        // if user already takes part at this plogging race then remove participation
        if ploggingUI?.isTakingPart == true {
            ploggingUI?.isTakingPart = false
            ploggingUI?.ploggers?.remove(at: emailIndex)
        } else {
            ploggingUI?.isTakingPart = true
            ploggingUI?.ploggers?.append(UserDefaults.standard.string(forKey: "emailAddress") ?? "")
        }

        guard let ploggingUI else { return }

        ploggingService.setPlogging(ploggingUI: ploggingUI) { result in
            switch result {
            case .success:
                self.saveIntoInternalDatabase(ploggingUI: ploggingUI)
            case .failure:
                PopUpModalViewController().userAlert(element: .network, viewController: self)
            }
        }
    }

    private func saveIntoInternalDatabase(ploggingUI: PloggingUI) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            do {
                try self.repository.setEntity(ploggingUI: ploggingUI)
            } catch {
                PopUpModalViewController().userAlert(element: .internalDatabase, viewController: self)
            }

            self.ploggingDetailsView.manageIsTakingPartButton(button: self.ploggingDetailsView.isTakingPartButton, isTakingPart: ploggingUI.isTakingPart)
            ploggingUI.isTakingPart ? PopUpModalViewController().userAlert(element: .isTakingPart, viewController: self) : PopUpModalViewController().userAlert(element: .isNotTakingPart, viewController: self)
        }
    }

    // MARK: - Set main image For Admin

    @IBAction func didTapEditMainImage() {
        if isInternetAvailable() {
            chooseImage(source: .photoLibrary)
        } else {
            PopUpModalViewController().userAlert(element: .unableToSaveChangeInternet, viewController: self)
        }
    }

    // MARK: - Open mail App app and send mail

    @IBAction func didTapMessageButton() {
        if isAdmin {
            let addressMailList = ploggingUI?.ploggers

            if let emailURLList = URL(string: "mailto:\(String(describing: addressMailList))"), UIApplication.shared.canOpenURL(emailURLList) {
                UIApplication.shared.open(emailURLList, options: [:], completionHandler: nil)
            } else {
                PopUpModalViewController().userAlert(element: .mailAppUnavailable, viewController: self)
            }
        } else {
            let addressMail = ploggingUI?.admin

            if let emailURL = URL(string: "mailto:\(String(describing: addressMail))"), UIApplication.shared.canOpenURL(emailURL) {
                UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
            } else {
                PopUpModalViewController().userAlert(element: .mailAppUnavailable, viewController: self)
            }
        }
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

//extension PloggingDetailsViewController: DetailsCollectionDelegate {
//    func didSetPhoto(photo: PhotoUI, action: String) {
//        setImage(photo: photo, action: action)
//        // TODO: save into Cloudkit
//    }
//}

extension PloggingDetailsViewController: PopUpModalDelegate {
    func didValidateAction() {
        performSegue(withIdentifier: SegueIdentifier.fromDetailsToSignInOrUp.rawValue, sender: self)
    }
}
