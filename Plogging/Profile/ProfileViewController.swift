//
//  ProfileViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 20/12/2022.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - Properties

    private var profileView: ProfileView!
    private var userIdentifier = UserIdentifier()
    private let popUpModal: PopUpModalViewController = PopUpModalViewController()

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        profileView = view as? ProfileView
        popUpModal.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let isConnectedUser = UserDefaults.standard.string(forKey: "emailAddress") != nil

        let email = UserDefaults.standard.string(forKey: "emailAddress") ?? ""
        profileView.configure(isConnected: isConnectedUser, email: email)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.fromProfileToMap.identifier {
            _ = segue.destination as? MapViewController
        }
    }
    
    // MARK: - Log Out
    
    @IBAction func didTapLogOutButton() {
        popUpModal.userAlertWithChoice(element: .logOut, viewController: self)
    }
    
    private func wantToLogOut() {
        userIdentifier.signOutRequest { result in
            switch result {
            case .success:
                self.logOutSucces()
            case .failure:
                self.popUpModal.userAlert(element: .unableToDisconnectUser, viewController: self)
            }
        }
    }
    
    private func logOutSucces() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UserDefaults.standard.set(nil, forKey: "emailAddress")
            self.performSegue(withIdentifier: SegueIdentifier.fromProfileToMap.identifier, sender: self)
        }
    }
}

extension ProfileViewController: PopUpModalDelegate {
    func didValidateAction() {
        wantToLogOut()
    }
}
