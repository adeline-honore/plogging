//
//  SignInOrUpViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 21/10/2023.
//

import UIKit
import FirebaseAuth

class SignInOrUpViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Properties

    private var signInOrUpView: SignInOrUpView!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        signInOrUpView = view as? SignInOrUpView
        setupKeyboardDismissRecognizer(self)

        signInOrUpView.emailTextField.becomeFirstResponder()
        signInOrUpView.emailTextField.delegate = self
        signInOrUpView.passwordTextField.delegate = self
    }

    // MARK: Sign Up

    @IBAction func didTapOnSignUpButton() {
        signupButtonWasPressed()
    }

    private func signupButtonWasPressed() {
        if (signInOrUpView.emailTextField.text?.isEmpty) != nil || ((signInOrUpView.passwordTextField.text?.isEmpty) != nil) {
            PopUpModalViewController().userAlert(element: .emptyIdentifier, viewController: self)
        } else if validateEmail(email: signInOrUpView.emailTextField.text ?? "") == false {
            PopUpModalViewController().userAlert(element: .invalidEmail, viewController: self)
        } else {
            createUser()
        }
    }

    private func createUser() {
        Auth.auth().createUser(withEmail: signInOrUpView.emailTextField.text!, password: signInOrUpView.passwordTextField.text!) { (authResult, error) in

            if error == nil {
                UserDefaults.standard.set(self.signInOrUpView.emailTextField.text, forKey: "emailAddress")
                _ = self.navigationController?.popViewController(animated: true)
                PopUpModalViewController().userAlert(element: .isTakingPart, viewController: self)
            } else {
                PopUpModalViewController().userAlert(element: .unableToCreateUser, viewController: self)
            }
        }
    }
}
