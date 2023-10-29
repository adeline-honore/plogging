//
//  ChangePasswordViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 20/12/2022.
//

import UIKit

class ChangePasswordViewController: SetConstraintForKeyboardViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var passwordTextField: UITextField!

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.becomeFirstResponder()
        setupKeyboardDismissRecognizer(self)
    }

    // MARK: - Save button

    @IBAction func didTapSaveButton() {
    }

    // MARK: - Cancel button

    @IBAction func didTapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
