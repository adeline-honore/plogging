//
//  AuthAPINetwork.swift
//  Plogging
//
//  Created by adeline honore on 02/12/2023.
//

import Foundation
import FirebaseAuth

protocol AuthNetworkProtocol {
    func createAPIUser(email: String, password: String, router: AuthRouterProtocol, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void)
    func connectUser(email: String, password: String, router: AuthRouterProtocol, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void)
    func setPassword(email: String, currentPassword: String, newPassword: String, router: AuthRouterProtocol, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void)
    func forgotPasswordRequestApi(email: String, router: AuthRouterProtocol, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void)
    func disconnectUser(router: AuthRouterProtocol, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void)
}

class AuthNetwork: AuthNetworkProtocol {

    func createAPIUser(email: String, password: String, router: AuthRouterProtocol, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void) {
        let auth = router.authentificationReference()

        auth.createUser(withEmail: email, password: password) { (authResult, error) in

            if error != nil {
                completionHandler(.success(FirebaseResult.success))
            } else {
                completionHandler(.failure(ErrorType.network))
            }
        }
    }

    func connectUser(email: String, password: String, router: AuthRouterProtocol, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void) {
        let auth = router.authentificationReference()

        auth.signIn(withEmail: email, password: password) { (authResult, error) in

            if error != nil {
                completionHandler(.success(FirebaseResult.success))
            } else {
                completionHandler(.failure(ErrorType.network))
            }
        }
    }

    func setPassword(email: String, currentPassword: String, newPassword: String, router: AuthRouterProtocol, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void) {
        let auth = router.authentificationReference()
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)

        auth.currentUser?.reauthenticate(with: credential) { (authResult, error) in
            if error != nil {
                completionHandler(.success(FirebaseResult.success))
            } else {
                completionHandler(.failure(ErrorType.network))
            }
        }
    }

    func forgotPasswordRequestApi(email: String, router: AuthRouterProtocol, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void) {
        let auth = router.authentificationReference()

        auth.sendPasswordReset(withEmail: email) { error in
            _ = Auth.auth().currentUser?.uid

            if error == nil {
                completionHandler(.success(FirebaseResult.success))
            } else {
                completionHandler(.failure(ErrorType.network))
            }
        }
    }

    func disconnectUser(router: AuthRouterProtocol, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void) {
        let auth = router.authentificationReference()

        do {
            try auth.signOut()
            completionHandler(.success(.success))
        } catch {
            completionHandler(.failure(ErrorType.network))
        }
    }
}
