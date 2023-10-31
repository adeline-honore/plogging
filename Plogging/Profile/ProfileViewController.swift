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

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        profileView = view as? ProfileView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let isConnectedUser = UserDefaults.standard.string(forKey: UserDefaultsName.emailAddress.rawValue) != nil

        profileView.emailLabel.text = UserDefaults.standard.string(forKey: UserDefaultsName.emailAddress.rawValue)
        profileView.haveToLoginLabel.text = Texts.haveToLoginMessage.value
        profileView.configure(isConnected: isConnectedUser)
    }
}
