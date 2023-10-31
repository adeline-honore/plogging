//
//  UserIdentifier.swift
//  Plogging
//
//  Created by HONORE Adeline on 01/11/2023.
//

import Foundation

class UserIdentifier {
    
    private let authService = Authservice()

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
}