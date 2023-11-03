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
    private var userIdentifier = UserIdentifier()
    private var popUpModal = PopUpModalViewController()

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
        let email = signInOrUpView.emailTextField.text
        let password = signInOrUpView.passwordTextField.text
        
        if (email == nil) || (password == nil) {
            PopUpModalViewController().userAlert(element: .emptyIdentifier, viewController: self)
        } else if validateEmail(email: signInOrUpView.emailTextField.text ?? "") == false {
            PopUpModalViewController().userAlert(element: .invalidEmail, viewController: self)
        } else {
            createUser(email: email ?? "", password: password ?? "")
        }
    }

    private func createUser(email: String, password: String) {
        userIdentifier.createUserRequest(email: email, password: password){ result in
            switch result {
            case .success:
                UserDefaults.standard.set(email, forKey: "emailAddress")
                _ = self.navigationController?.popViewController(animated: true)
                self.popUpModal.userAlert(element: .welcomeMessage, viewController: self)
            case .failure:
                self.popUpModal.userAlert(element: .unableToConnectUser, viewController: self)
            }
        }
    }
}
