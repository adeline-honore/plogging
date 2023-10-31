//
//  AuthService.swift
//  Plogging
//
//  Created by HONORE Adeline on 01/11/2023.
//

import Foundation
import FirebaseAuth

class Authservice {
    func createUserIdentifier(email: String, password: String, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in

            if error == nil {
                completionHandler(FirebaseResult.success)
            } else {
                completionHandler(ErrorType.network)
            }
        }
    }

    func connectUser(email: String, password: String, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }

            if error == nil {
                completionHandler(FirebaseResult.success)
            } else {
                completionHandler(ErrorType.network)
            }
        }
    }
    
    func changePassword(mail: String, password: String, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
//        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
//
//            if error == nil {
//                completionHandler(FirebaseResult.success)
//            } else {
//                completionHandler(ErrorType.network)
//            }
//        }
}
