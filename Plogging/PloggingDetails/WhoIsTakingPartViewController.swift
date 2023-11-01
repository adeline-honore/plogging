//
//  WhoIsTakingPartViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 26/04/2023.
//

import UIKit

protocol WhoIsTakingPartDelegate: AnyObject {
    func getEmailAddress()
}

//class WhoIsTakingPartViewController: SetConstraintForKeyboardViewController {
//    // MARK: - Properties
//
//    private var whoIsTakingPartView: WhoIsTakingPartView!
//    weak var delegate: WhoIsTakingPartDelegate?
//
//    // MARK: - Life cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        whoIsTakingPartView = view as? WhoIsTakingPartView
//        whoIsTakingPartView.configure()
//
//        whoIsTakingPartView.newEmailTextField.becomeFirstResponder()
//        setupKeyboardDismissRecognizer(self)
//    }
//
//    // MARK: Save email address
//
//    @IBAction func didTapSaveButton(_ sender: Any) {
//        saveEmail()
//    }
//
//    private func saveEmail() {
//
//        guard let emailInput = whoIsTakingPartView.newEmailTextField.text?.trimmingCharacters(in: .whitespaces) else {
//            return
//        }
//
//        if emailInput.isEmpty {
//            PopUpModalViewController().userAlert(element: .unavailableEmail, viewController: self)
//        } else if validateEmail(email: emailInput) == true {
//            UserDefaults.standard.setValue(whoIsTakingPartView.newEmailTextField.text, forKey: UserDefaultsName.emailAddress.rawValue)
//            delegate?.getEmailAddress()
//            self.dismiss(animated: true)
//        } else {
//            PopUpModalViewController().userAlert(element: .invalidEmail, viewController: self)
//        }
//    }
//
//    // MARK: - Dismmiss view controller
//
//    @IBAction func didTapCancelButton() {
//        self.dismiss(animated: true)
//    }
//}
