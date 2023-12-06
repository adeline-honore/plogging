//
//  PloggingDetailsViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 20/10/2022.
//

import UIKit

enum UserAction {
    case toggleTakePart
    case wantToLogIn
    case null
}

class PloggingDetailsViewController: UIViewController {

    // MARK: - Properties

    private var ploggingDetailsView: PloggingDetailsView!
    private var isAdmin: Bool = false

    private let popUpModal: PopUpModalViewController = PopUpModalViewController()

    private var ploggingService = PloggingService(network: PloggingNetwork())
    private var imageService = ImageService(network: ImageNetwork())
    private let repository = PloggingCoreDataManager(
        coreDataStack: CoreDataStack(),
        managedObjectContext: CoreDataStack().viewContext)

    var ploggingUI: PloggingUI?

    private var isConnectedUser: Bool = false

    private var userAction: UserAction = .null

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

    @IBAction func didSetIsTakingPartValue() {
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
        popUpModal.delegate = self
        userAction = .toggleTakePart
        if ploggingUI?.isTakingPart == true {
            // if user already takes part at this plogging race then remove participation
            popUpModal.userAlertWithChoice(element: .wantToNoParticipate, viewController: self)
        } else {
            popUpModal.userAlertWithChoice(element: .wantToParticipate, viewController: self)
        }
    }

    private func saveTakePartChoice() {
        // if user already takes part at this plogging race then remove participation
        if ploggingUI?.isTakingPart == true {
            let emailIndex = ploggingUI?.ploggers.firstIndex(where: {$0 == UserDefaults.standard.string(forKey: "emailAddress")})
            ploggingUI?.isTakingPart = false
            ploggingUI?.ploggers.remove(at: emailIndex ?? 0)
        } else {
            ploggingUI?.isTakingPart = true
            ploggingUI?.ploggers.append(UserDefaults.standard.string(forKey: "emailAddress") ?? "")
        }

        guard let ploggingUI else { return }

        let ploggingToSet: Plogging = Plogging(ploggingUI: ploggingUI)

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            ploggingService.createOrUpdatePlogging(plogging: ploggingToSet) { result in
                switch result {
                case .success:
                    self.saveIntoInternalDatabase(ploggingUI: ploggingUI)
                case .failure:
                    PopUpModalViewController().userAlert(element: .network, viewController: self)
                }
            }
        }
    }

    private func saveIntoInternalDatabase(ploggingUI: PloggingUI) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            if ploggingUI.isTakingPart {
                do {
                    try self.repository.createEntity(ploggingUI: ploggingUI)
                } catch {
                    self.popUpModal.userAlert(element: .internalDatabase, viewController: self)
                }
            } else {
                do {
                    try self.repository.removeEntity(id: ploggingUI.id)
                } catch {
                    self.popUpModal.userAlert(element: .internalDatabase, viewController: self)
                }
            }
            if ploggingUI.isTakingPart {
                self.popUpModal.userAlert(element: .isTakingPart, viewController: self)
            } else {
                self.popUpModal.userAlert(element: .isNotTakingPart, viewController: self)
            }
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

    private func saveChangeImageInAPI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            guard let mainImageBinary = ploggingUI?.mainImage?.jpegData(compressionQuality: 0.8), let id = ploggingUI?.id else {
                self.popUpModal.userAlert(element: .unableToSaveChangeInternet, viewController: self)
                return
            }

            self.imageService.uploadPhoto(mainImageBinary: mainImageBinary, ploggingId: id) { result in
                switch result {
                case .success:
                    self.saveChangeImageInCoredata()
                case .failure:
                    self.popUpModal.userAlert(element: .unableToSaveChangeInternet, viewController: self)
                }
            }
        }
    }

    private func saveChangeImageInCoredata() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let thisPloggingUI = ploggingUI else { return }
            do {
                try self.repository.setEntity(ploggingUI: thisPloggingUI)

                self.popUpModal.userAlert(element: AlertType.ploggingSetWithSuccess, viewController: self)
            } catch {
                self.popUpModal.userAlert(element: AlertType.ploggingNotSaved, viewController: self)
            }
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

        saveChangeImageInAPI()
    }
}

extension PloggingDetailsViewController: PopUpModalDelegate {
    func didValidateAction() {
        if userAction == .toggleTakePart {
            saveTakePartChoice()
        } else if userAction == .wantToLogIn {
            performSegue(withIdentifier: SegueIdentifier.fromDetailsToSignInOrUp.rawValue, sender: self)
        }
    }
}
