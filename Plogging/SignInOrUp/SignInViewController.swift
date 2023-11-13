//
//  SignInViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 21/10/2023.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Properties
    private var signInView: SignInView!
    private var userIdentifier = UserIdentifier()
    private var popUpModal = PopUpModalViewController()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        signInView = view as? SignInView
        signInView.configure()
        setupKeyboardDismissRecognizer(self)

        signInView.emailTextField.becomeFirstResponder()
        signInView.emailTextField.delegate = self
        signInView.passwordTextField.delegate = self
    }
    
    // MARK: - Sign In Request

    @IBAction func didTapSigInButton() {
        signInButtonWasPressed()
    }

    private func signInButtonWasPressed() {
        let email = signInView.emailTextField.text
        let password = signInView.passwordTextField.text

        if !isInternetAvailable() {
            popUpModal.userAlert(element: .internetNotAvailable, viewController: self)
        }
        else if (email == nil) || (password == nil) {
            popUpModal.userAlert(element: .emptyIdentifier, viewController: self)
        } else if validateEmail(email: signInView.emailTextField.text ?? "") == false {
            popUpModal.userAlert(element: .invalidEmail, viewController: self)
        } else {
            signIn(email: email ?? "", password: password ?? "")
        }
    }

    private func signIn(email: String, password: String) {
        userIdentifier.signInRequest(email: email, password: password){ result in
            switch result {
            case .success:
                UserDefaults.standard.set(email, forKey: "emailAddress")
                _ = self.navigationController?.popViewController(animated: true)
                self.popUpModal.userAlert(element: .salutationsMessage, viewController: self)
            case .failure:
                self.popUpModal.userAlert(element: .unableToConnectUser, viewController: self)
            }
        }
    }
}
