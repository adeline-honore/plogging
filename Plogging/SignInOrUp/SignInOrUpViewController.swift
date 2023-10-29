//
//  SignInOrUpViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 21/10/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignInOrUpViewController: UIViewController {

    // MARK: - Properties
    
    private var signInOrUpView: SignInOrUpView!
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInOrUpView = view as? SignInOrUpView
        setupKeyboardDismissRecognizer(self)
        
        signInOrUpView.emailTextField.becomeFirstResponder()        
    }
    
    
    // MARK: Sign Up
    
    @IBAction func didTapOnSignUpButton() {
        signupButtonWasPressed()
    }
    
    private func signupButtonWasPressed() {
        if (signInOrUpView.emailTextField.text?.isEmpty) != nil || ((signInOrUpView.passwordTextField.text?.isEmpty) != nil) {
            userAlert(element: .emptyIdentifier)
        } else if validateEmail(email: signInOrUpView.emailTextField.text ?? "") == false {
            userAlert(element: .invalidEmail)
        } else {
            createUser()
        }
    }
    
    private func createUser() {
        Auth.auth().createUser(withEmail: signInOrUpView.emailTextField.text!, password: signInOrUpView.passwordTextField.text!) { (authResult, error) in
            
            if error == nil {
                UserDefaults.standard.set(self.signInOrUpView.emailTextField.text, forKey: "emailAddress")
                DatabaseURL.ref.child("Users").setValue(["Email": self.signInOrUpView.emailTextField.text, "Password": self.signInOrUpView.passwordTextField.text])
                _ = self.navigationController?.popViewController(animated: true)
                self.userAlert(element: .isTakingPart)
            } else {
                self.userAlert(element: .unableToCreateUser)
            }
        }
    }
}
