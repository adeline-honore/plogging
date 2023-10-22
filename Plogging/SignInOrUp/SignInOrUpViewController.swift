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
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: Sign Up
    
    @IBAction func didTapOnSignUpButton() {
        signupButtonWasPressed()
    }
    
    private func signupButtonWasPressed() {
        
        if emailTextField.text == "" && passwordTextField.text == "" {
            userAlert(element: .emptyIdentifier)
        } else if validateEmail(email: emailTextField.text ?? "") == false {
            userAlert(element: .invalidEmail)
        } else if validateEmail(email: emailTextField.text ?? "") == true {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
                if error != nil {
                    print("erreur signup : \(error.debugDescription)")
                } else {
// TODO userdeault 
                }
            }
        }
    }
}
