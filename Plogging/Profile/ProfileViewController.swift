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
    private let popUpModal: PopUpModalViewController = PopUpModalViewController()

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        profileView = view as? ProfileView
        popUpModal.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let isConnectedUser = UserDefaults.standard.string(forKey: UserDefaultsName.emailAddress.rawValue) != nil

        let email = UserDefaults.standard.string(forKey: UserDefaultsName.emailAddress.rawValue) ?? ""
        profileView.configure(isConnected: isConnectedUser, email: email)
    }
    
    // MARK: - Log Out
    
    @IBAction func didTapLogOutButton() {
        popUpModal.userAlertWithChoice(element: .logOut, viewController: self)
    }
    
    private func wantToLogOut() {
//        UserDefaults.standard.set("", forKey: UserDefaultsName.emailAddress.rawValue)
//        UserDefaults.removeObject(UserDefaults())
    }
}

extension ProfileViewController: PopUpModalDelegate {
    func didValidateAction() {
        wantToLogOut()
    }
}
