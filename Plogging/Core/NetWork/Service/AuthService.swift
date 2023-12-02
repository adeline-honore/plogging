//
//  AuthService.swift
//  Plogging
//
//  Created by HONORE Adeline on 01/11/2023.
//

import Foundation
import FirebaseAuth

protocol AuthServiceProtocol {
    func createApiUser(plogging: Plogging, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void)
    func connectUser(withEmail: String, password: String, completionHandler: @escaping (Result<[FirebaseResult], Error>) -> Void)
    func forgotPasswordRequestApi(completionHandler: @escaping (Result<[FirebaseResult], Error>) -> Void)
    func disconnectUser(completionHandler: @escaping (Result<[FirebaseResult], Error>) -> Void)
}

//class Authservice: AuthServiceProtocol {
    








//    // MARK: - Call To API To Create New User
//    func createUserIdentifier(email: String, password: String, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
//        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
//
//            if error == nil {
//                completionHandler(.success(FirebaseResult.success))
//            } else {
//                completionHandler(.failure(ErrorType.network))
//            }
//        }
//    }
//
//    // MARK: - Call To API To Sign In
//    func connectUser(email: String, password: String, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
//        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
//            if error == nil {
//                completionHandler(.success(FirebaseResult.success))
//            } else {
//                completionHandler(.failure(ErrorType.network))
//            }
//        }
//    }
//
//    // MARK: - Call To API To Set Password
//    func changePassword(email: String, currentPassword: String, newPassword: String, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
//        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
//
//        Auth.auth().currentUser?.reauthenticate(with: credential ) { error, _  in
//            if error == nil {
//                completionHandler(.success(FirebaseResult.success))
//            } else {
//                completionHandler(.failure(ErrorType.network))
//            }
//        }
//    }
//
//    // MARK: - Call To API When Password Is Forgotten
//    func forgotPasswordAPI(email: String, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
//        Auth.auth().sendPasswordReset(withEmail: email) { error in
//            _ = Auth.auth().currentUser?.uid
//
//            if error == nil {
//                completionHandler(.success(FirebaseResult.success))
//            } else {
//                completionHandler(.failure(ErrorType.network))
//            }
//        }
//    }
//
//    // MARK: - Call To API To Sign Out
//    func disconnectUser(completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
//        do {
//            try Auth.auth().signOut()
//            completionHandler(.success(.success))
//        } catch {
//            completionHandler(.failure(ErrorType.network))
//        }
//    }
//}
