//
//  ChangePasswordViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 20/12/2022.
//

import UIKit

class ChangePasswordViewController: SetConstraintForKeyboardViewController {

    // MARK: - IBOutlet

    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var noInternetLabel: UILabel!
    @IBOutlet weak var setPasswordButton: UIButton!
    
    // MARK: - Properties

    private var userIdentifier = UserIdentifier()
    private let popUpModal: PopUpModalViewController = PopUpModalViewController()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.becomeFirstResponder()
        setupKeyboardDismissRecognizer(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        passwordLabel.isHidden = !isInternetAvailable()
        passwordTextField.isHidden = !isInternetAvailable()
        noInternetLabel.isHidden = isInternetAvailable()
        noInternetLabel.text = Texts.internetIsUnavailable.value
        setPasswordButton.isHidden = !isInternetAvailable()
    }

    // MARK: - Set Password

    @IBAction func didTapSaveButton() {
        wantToSetPassword()
    }

    private func wantToSetPassword() {

        guard let newPassword = passwordTextField.text, !newPassword.isEmpty else {
            popUpModal.userAlert(element: .emptyIdentifier, viewController: self)
            return
            }

        userIdentifier.setPasswordRequest(newPassword: newPassword) { result in
            switch result {
            case .success:
                self.popUpModal.userAlert(element: .passwordSetted, viewController: self)
            case .failure:
                self.popUpModal.userAlert(element: .unableToSetPassword, viewController: self)
            }
        }
    }
}
