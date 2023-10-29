//
//  ProfileView.swift
//  Plogging
//
//  Created by HONORE Adeline on 20/12/2022.
//

import UIKit

class ProfileView: UIView {
    
    @IBOutlet weak var initialImageView: UIImageView!
    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var pseudoLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var haveToLoginView: UIView!
    @IBOutlet weak var haveToLoginTextLabel: UILabel!
    @IBOutlet weak var haveToLoginButton: UIButton!
}

extension ProfileView {
    func configure(isConnected: Bool) {
        circleImageRounded(initialImageView)
        
        initialImageView.isHidden = !isConnected
        initialLabel.isHidden = !isConnected
        pseudoLabel.isHidden = !isConnected
        firstNameLabel.isHidden = !isConnected
        lastNameLabel.isHidden = !isConnected
        emailLabel.isHidden = !isConnected
        haveToLoginView.isHidden = isConnected
        haveToLoginTextLabel.isHidden = isConnected
        haveToLoginTextLabel.isHidden = isConnected
        
    }
}
