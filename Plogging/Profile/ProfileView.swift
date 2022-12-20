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
}

extension ProfileView {
    func configure() {
        circleImageRounded(initialImageView)
    }
}
