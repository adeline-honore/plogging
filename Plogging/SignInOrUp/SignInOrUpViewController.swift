//
//  SignInOrUpViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 21/10/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignInOrUpViewController: SetConstraintForKeyboardViewController {

    // MARK: - Properties
    
    private var signInOrUpView: SignInOrUpView!
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInOrUpView = view as? SignInOrUpView
        setupKeyboardDismissRecognizer(self)
        
        signInOrUpView.emailTextField.delegate = self
        signInOrUpView.passwordTextField.delegate = self
    }
    
    
    // MARK: Sign Up
    
    @IBAction func didTapOnSignUpButton() {
        signupButtonWasPressed()
    }
    
    private func signupButtonWasPressed() {
        if signInOrUpView.emailTextField.text == "" && signInOrUpView.passwordTextField.text == "" {
            userAlert(element: .emptyIdentifier)
        } else if validateEmail(email: signInOrUpView.emailTextField.text ?? "") == false {
            userAlert(element: .invalidEmail)
        } else if validateEmail(email: signInOrUpView.emailTextField.text ?? "") == true {
            Auth.auth().createUser(withEmail: signInOrUpView.emailTextField.text!, password: signInOrUpView.passwordTextField.text!) { (authResult, error) in
                if error != nil {
                    print("erreur signup : \(error.debugDescription)")
                } else {
// TODO userdeault 
                }
            }
        }
    }
}

extension SignInOrUpViewController: UITextFieldDelegate {
    override class func didChangeValue(forKey key: String) {
        print(key)
    }
}
