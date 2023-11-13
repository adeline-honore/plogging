//
//  ForgotPasswordViewController.swift
//  Plogging
//
//  Created by adeline honore on 13/11/2023.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var forgotPasswordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!

    // MARK: - Properties

    private var popUpModal = PopUpModalViewController()
    private var userIdentifier = UserIdentifier()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - User Forgot Password

    @IBAction func didTapForgotButton() {
        checkEmailAddress()
    }

    private func checkEmailAddress() {
        let email = forgotPasswordTextField.text

        if !isInternetAvailable() {
            popUpModal.userAlert(element: .internetNotAvailable, viewController: self)
        }
        else if (email == nil) {
            popUpModal.userAlert(element: .emptyIdentifier, viewController: self)
        } else if validateEmail(email: forgotPasswordTextField.text ?? "") == false {
            popUpModal.userAlert(element: .invalidEmail, viewController: self)
        } else {
            forgotPassword(email: email!)
        }
    }
    
    private func forgotPassword(email: String) {
        userIdentifier.forgotPasswordRequest(email: email) { result in
            switch result {
            case .success:
                UserDefaults.standard.set(email, forKey: "emailAddress")
                _ = self.navigationController?.popViewController(animated: true)
                self.popUpModal.userAlert(element: .forgotPaswwordRequestSuccess, viewController: self)
            case .failure:
                self.popUpModal.userAlert(element: .forgotPasswordRequestFailed, viewController: self)
            }
        }
    }
}
