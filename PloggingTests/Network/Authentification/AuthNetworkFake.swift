//
//  AuthNetworkFake.swift
//  PloggingTests
//
//  Created by adeline honore on 03/12/2023.
//

import Foundation
@testable import Plogging

class AuthNetworkFake: AuthNetworkProtocol {

    private let testCase: TestCase
    private var isFailed: Bool = false

    init(testCase: TestCase, isFailed: Bool) {
        self.testCase = testCase
        self.isFailed = isFailed
    }

    func createAPIUser(email: String, password: String, router: AuthRouterProtocol, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void) {
        guard !isFailed else {
            completionHandler(.failure(ErrorType.network))
            return
        }
        return completionHandler(.success(FirebaseResult.success))
    }

    func connectUser(email: String, password: String, router: AuthRouterProtocol, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void) {
        guard !isFailed else {
            completionHandler(.failure(ErrorType.network))
            return
        }
        return completionHandler(.success(FirebaseResult.success))
    }

    func setPassword(email: String, currentPassword: String, newPassword: String, router: AuthRouterProtocol, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void) {
        guard !isFailed else {
            completionHandler(.failure(ErrorType.network))
            return
        }
        return completionHandler(.success(FirebaseResult.success))
    }

    func forgotPasswordRequestApi(email: String, router: AuthRouterProtocol, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void) {
        guard !isFailed else {
            completionHandler(.failure(ErrorType.network))
            return
        }
        return completionHandler(.success(FirebaseResult.success))
    }

    func disconnectUser(router: AuthRouterProtocol, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void) {
        guard !isFailed else {
            completionHandler(.failure(ErrorType.network))
            return
        }
        return completionHandler(.success(FirebaseResult.success))
    }
}
