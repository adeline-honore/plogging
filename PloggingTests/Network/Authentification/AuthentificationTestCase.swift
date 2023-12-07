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
    private let password = "Azerty123"

    private func initSUT(isFailed: Bool = false, testCase: TestCase = .auth) {
        authService = Authservice(network: AuthNetworkFake(testCase: .auth, isFailed: isFailed))
    }

    override func tearDown() {
        super.setUp()
        authService = nil
    }

    func testCreateAPIUserShouldPostSuccess() {
        // Given
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        authService.createApiUser(email: email, password: password) { result in
            switch result {
            case .success:
                // Then
                expectation.fulfill()
            case .failure:
                XCTFail("It's not ok, test should returns success")
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testCreateAPIUserShouldReturnFailure() {
        // Given
        initSUT(isFailed: true)
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        authService.createApiUser(email: email, password: password) { result in
            switch result {
            case .failure:
                // Then
                expectation.fulfill()
            case .success:
                XCTFail("It's not ok, test should returns failure")
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testSignInShouldPostSuccess() {
        // Given
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        authService.connectUser(email: email, password: password) { result in
            switch result {
            case .success:
                // Then
                expectation.fulfill()
            case .failure:
                XCTFail("It's not ok, test should returns success")
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testSignInShouldReturnFailure() {
        // Given
        initSUT(isFailed: true)
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        authService.connectUser(email: email, password: password) { result in
            switch result {
            case .failure:
                // Then
                expectation.fulfill()
            case .success:
                XCTFail("It's not ok, test should returns failure")
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testSetPasswordShouldPostSuccess() {
        // Given
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        authService.setPassword(email: email, currentPassword: password, newPassword: "Qsdf123") { result in
            switch result {
            case .success:
                // Then
                expectation.fulfill()
            case .failure:
                XCTFail("It's not ok, test should returns success")
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testSetPasswordShouldPostSuccessFirebaseResult() {
        // Given
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        authService.setPassword(email: email, currentPassword: password, newPassword: "Qsdf123") { result in
            switch result {
            case .success(let object):
                // Then
                expectation.fulfill()
                XCTAssertEqual(object, FirebaseResult.success)
            case .failure:
                XCTFail("It's not ok, test should returns success")
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testSetPasswordShouldReturnFailure() {
        // Given
        initSUT(isFailed: true)
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        authService.setPassword(email: email, currentPassword: password, newPassword: "Qsdf123") { result in
            switch result {
            case .failure:
                // Then
                expectation.fulfill()
            case .success:
                XCTFail("It's not ok, test should returns failure")
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testForgotPasswordShouldPostSuccess() {
        // Given
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        authService.forgotPasswordRequestApi(email: email) { result in
            switch result {
            case .success:
                // Then
                expectation.fulfill()
            case .failure:
                XCTFail("It's not ok, test should returns success")
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testForgotPasswordShouldPostSuccessFirebaseResult() {
        // Given
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        authService.forgotPasswordRequestApi(email: email) { result in
            switch result {
            case .success(let object):
                // Then
                expectation.fulfill()
                XCTAssertEqual(object, FirebaseResult.success)
            case .failure:
                XCTFail("It's not ok, test should returns success")
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testForgotPasswordShouldReturnFailure() {
        // Given
        initSUT(isFailed: true)
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        authService.forgotPasswordRequestApi(email: email) { result in
            switch result {
            case .failure:
                // Then
                expectation.fulfill()
            case .success:
                XCTFail("It's not ok, test should returns failure")
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testLogOutShouldPostSuccess() {
        // Given
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        authService.disconnectUser { result in
            switch result {
            case .success:
                // Then
                expectation.fulfill()
            case .failure:
                XCTFail("It's not ok, test should returns success")
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testLogOutShouldPostSuccessFirebaseResult() {
        // Given
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        authService.disconnectUser { result in
            switch result {
            case .success(let object):
                // Then
                expectation.fulfill()
                XCTAssertEqual(object, FirebaseResult.success)
            case .failure:
                XCTFail("It's not ok, test should returns success")
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testLogOutShouldReturnFailure() {
        // Given
        initSUT(isFailed: true)
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        authService.disconnectUser { result in
            switch result {
            case .failure:
                // Then
                expectation.fulfill()
            case .success:
                XCTFail("It's not ok, test should returns failure")
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
