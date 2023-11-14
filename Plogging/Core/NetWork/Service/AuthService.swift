//
//  AuthService.swift
//  Plogging
//
//  Created by HONORE Adeline on 01/11/2023.
//

import Foundation
import FirebaseAuth

class Authservice {

    // MARK: - Call To API To Create New User
    func createUserIdentifier(email: String, password: String, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            if error == nil {
                completionHandler(.success(FirebaseResult.success))
            } else {
                completionHandler(.failure(ErrorType.network))
            }
        }
    }

    // MARK: - Call To API To Sign In
    func connectUser(email: String, password: String, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error == nil {
                completionHandler(.success(FirebaseResult.success))
            } else {
                completionHandler(.failure(ErrorType.network))
            }
        }
    }

    // MARK: - Call To API To Set Password
    func changePassword(newPassword: String, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
            _ = Auth.auth().currentUser?.uid

            if error == nil {
                completionHandler(.success(FirebaseResult.success))
            } else {
                completionHandler(.failure(ErrorType.network))
            }
        }
    }

    // MARK: - Call To API When Password Is Forgotten
    func forgotPasswordAPI(email: String, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            _ = Auth.auth().currentUser?.uid

            if error == nil {
                completionHandler(.success(FirebaseResult.success))
            } else {
                completionHandler(.failure(ErrorType.network))
            }
        }
    }

    // MARK: - Call To API To Sign Out
    func disconnectUser(completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
        do {
            try Auth.auth().signOut()
            completionHandler(.success(.success))
        } catch {
            completionHandler(.failure(ErrorType.network))
        }
    }
}
