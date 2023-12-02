//
//  AuthService.swift
//  Plogging
//
//  Created by HONORE Adeline on 01/11/2023.
//

import Foundation
import FirebaseAuth

protocol AuthServiceProtocol {
    func createApiUser(email: String, password: String, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void)
    func connectUser(email: String, password: String, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void)
    func setPassword(email: String, currentPassword: String, newPassword: String, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void)
    func forgotPasswordRequestApi(email: String, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void)
    func disconnectUser(completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void)
}

class Authservice: AuthServiceProtocol {

    private var network: AuthNetworkProtocol

    init(network: AuthNetworkProtocol) {
        self.network = network
    }

    func createApiUser(email: String, password: String, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void) {
        return network.createAPIUser(email: email, password: password, router: AuthRouter.createUser) { result in
            switch result {
            case .success:
                completionHandler(.success(FirebaseResult.success))
            case .failure:
                completionHandler(.failure(ErrorType.network))
            }
        }
    }

    func connectUser(email: String, password: String, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void) {
        return network.connectUser(email: email, password: password, router: AuthRouter.connectUser) { result in
            switch result {
            case .success:
                completionHandler(.success(FirebaseResult.success))
            case .failure:
                completionHandler(.failure(ErrorType.network))
            }
        }
    }

    func setPassword(email: String, currentPassword: String, newPassword: String, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void) {
        return network.setPassword(email: email, currentPassword: currentPassword, newPassword: newPassword, router: AuthRouter.setPassword) { result in
            switch result {
            case .success:
                completionHandler(.success(FirebaseResult.success))
            case .failure:
                completionHandler(.failure(ErrorType.network))
            }
        }
    }

    func forgotPasswordRequestApi(email: String, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void) {
        return network.forgotPasswordRequestApi(email: email, router: AuthRouter.forgotPassword) { result in
            switch result {
            case .success:
                completionHandler(.success(FirebaseResult.success))
            case .failure:
                completionHandler(.failure(ErrorType.network))
            }
        }
    }

    func disconnectUser(completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void) {
        return network.disconnectUser(router: AuthRouter.disconnectUser) { result in
            switch result {
            case .success:
                completionHandler(.success(FirebaseResult.success))
            case .failure:
                completionHandler(.failure(ErrorType.network))
            }
        }
    }
}
