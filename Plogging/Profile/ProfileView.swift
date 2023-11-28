//
//  ProfileView.swift
//  Plogging
//
//  Created by HONORE Adeline on 20/12/2022.
//

import UIKit

class ProfileView: UIView {

    @IBOutlet weak var initialImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var setPasswordButton: UIButton!
    @IBOutlet weak var haveToLoginLabel: UILabel!
    @IBOutlet weak var haveToLoginButton: UIButton!
}

extension ProfileView {
    func configure(isConnected: Bool, email: String) {
        circleImageRounded(initialImageView)

        haveToLoginLabel.text = Texts.haveToLoginMessage.value
        welcomeLabel.isHidden = !isConnected
        emailLabel.text = email
        logOutButton.isHidden = !isConnected
        emailLabel.isHidden = !isConnected
        setPasswordButton.isHidden = !isConnected
        haveToLoginLabel.isHidden = isConnected
        haveToLoginButton.isHidden = isConnected
    }
}
