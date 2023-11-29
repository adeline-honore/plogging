//
//  AuthentificationTestCase.swift
//  PloggingTests
//
//  Created by adeline honore on 15/11/2023.
//

import XCTest
@testable import Plogging

final class AuthentificationTestCase: XCTestCase {

    // Given
    private var authService: Authservice!
    private let email = "monemail@email.com"

    private func initSut(isFailed: Bool = false, testCase: TestCaseNetwork = .auth) {
        authService = Authservice()
    }

    override func tearDown() {
        super.setUp()
        authService = nil
    }

    func testSignInShouldPostSuccess() {

    }
}
