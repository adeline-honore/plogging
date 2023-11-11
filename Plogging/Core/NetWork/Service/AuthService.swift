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
                completionHandler(.success(FirebaseResult.success))
            } else {
                completionHandler(.failure(ErrorType.network))
            }
        }
    }
    
    func connectUser(email: String, password: String, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if error == nil {
                completionHandler(.success(FirebaseResult.success))
            } else {
                completionHandler(.failure(ErrorType.network))
            }
        }
    }
    
    func changePassword(newPassword: String, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
        
        print(Auth.auth().currentUser)
        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in

            if error == nil {
                completionHandler(.success(FirebaseResult.success))
            } else {
                completionHandler(.failure(ErrorType.network))
            }
        }
    }
    
    func disconnectUser(completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
        do {
            try Auth.auth().signOut()
            completionHandler(.success(.success))
        } catch {
            completionHandler(.failure(ErrorType.network))
        }
    }
}
