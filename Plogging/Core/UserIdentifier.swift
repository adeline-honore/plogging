//
//  UserIdentifier.swift
//  Plogging
//
//  Created by HONORE Adeline on 01/11/2023.
//

import Foundation

class UserIdentifier {
    
    private let authService = Authservice()

    // MARK: - Call To API To Create New User
    func createUserRequest(email: String, password: String, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {

        authService.createUserIdentifier(email: email, password: password) { result in
            switch result {
            case .success:
                completionHandler(.success(FirebaseResult.success))
            case .failure:
                completionHandler(.failure(.network))
            }
        }
    }

    // MARK: - Call To API To Sign In
    func signInRequest(email: String, password: String, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {

        authService.connectUser(email: email, password: password) { result in
            switch result {
            case .success:
                completionHandler(.success(FirebaseResult.success))
            case .failure:
                completionHandler(.failure(.network))
            }
        }
    }

    // MARK: - Call To API To Set Password
    func setPasswordRequest(newPassword: String, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
        authService.changePassword(newPassword: newPassword) { result in
            switch result {
            case .success:
                completionHandler(.success(FirebaseResult.success))
            case .failure:
                completionHandler(.failure(.network))
            }
        }
    }

    // MARK: - Call To API When Password Is Forgotten
    func forgotPasswordRequest(email: String, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
        authService.forgotPasswordAPI(email: email) {
            result in
            switch result {
            case .success:
                completionHandler(.success(FirebaseResult.success))
            case .failure:
                completionHandler(.failure(.network))
            }
        }
    }

    // MARK: - Call To API To Sign Out
    func signOutRequest(completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {

        authService.disconnectUser() { result in
            switch result {
            case .success:
                completionHandler(.success(FirebaseResult.success))
            case .failure:
                completionHandler(.failure(.network))
            }
        }
    }
}
