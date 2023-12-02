//
//  ChangePasswordViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 20/12/2022.
//

import UIKit

class ChangePasswordViewController: SetConstraintForKeyboardViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var currentPasswordLabel: UILabel!
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var noInternetLabel: UILabel!
    @IBOutlet weak var setPasswordButton: UIButton!

    // MARK: - Properties

    private var authService = Authservice(network: AuthNetwork())
    private let popUpModal: PopUpModalViewController = PopUpModalViewController()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        currentPasswordTextField.becomeFirstResponder()
        setupKeyboardDismissRecognizer(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        currentPasswordLabel.isHidden = !isInternetAvailable()
        currentPasswordTextField.isHidden = !isInternetAvailable()
        passwordLabel.isHidden = !isInternetAvailable()
        passwordTextField.isHidden = !isInternetAvailable()
        confirmPasswordLabel.isHidden = !isInternetAvailable()
        confirmPasswordLabel.isHidden = !isInternetAvailable()
        noInternetLabel.isHidden = isInternetAvailable()
        noInternetLabel.text = Texts.internetIsUnavailable.value
        setPasswordButton.isHidden = !isInternetAvailable()
    }

    // MARK: - Set Password

    @IBAction func didTapSaveButton() {
        wantToSetPassword()
    }

    private func wantToSetPassword() {

        guard let currentPassword = currentPasswordTextField.text,
              !currentPassword.isEmpty,
              let newPassword = passwordTextField.text,
              !newPassword.isEmpty,
              let confirmPassword = confirmPasswordTextField.text,
              !confirmPassword.isEmpty else {
            popUpModal.userAlert(element: .emptyIdentifier, viewController: self)
            return
        }

        guard let email = UserDefaults.standard.string(forKey: "emailAddress") else { return }

        if newPassword != confirmPassword {
            popUpModal.userAlert(element: .passwordNoSimilar, viewController: self)
            return
        }

        authService.setPassword(email: email, currentPassword: currentPassword, newPassword: newPassword) { result in
            switch result {
            case .success:
                self.popUpModal.userAlert(element: .passwordSetted, viewController: self)
            case .failure:
                self.popUpModal.userAlert(element: .unableToSetPassword, viewController: self)
            }
        }
    }
}
