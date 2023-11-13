//
//  SignInView.swift
//  Plogging
//
//  Created by adeline honore on 03/11/2023.
//

import UIKit

class SignInView: UIView {
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
}

extension SignInView {
    func configure() {
        signInLabel.text = "Enter your identifiers to log in"
    }
}
