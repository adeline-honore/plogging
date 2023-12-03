//
//  UIViewControllerTestCase.swift
//  PloggingTests
//
//  Created by adeline honore on 03/12/2023.
//

import UIKit
import XCTest
@testable import Plogging

final class UIViewControllerTestCase: XCTestCase {

    // Given
    private var viewController: UIViewController!

    private func initSUT(testCase: TestCase = .uiViewController) {
        viewController = UIViewController()
    }

    override func tearDown() {
        super.setUp()
        viewController = nil
    }

    func testValidateEmailSucces() {
        // Given
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        let result = viewController.validateEmail(email: "validemail@valid.fr")
            switch result {
            case true:
                // Then
                expectation.fulfill()
            case false:
                XCTFail("It's not ok, test should returns success")
            }
        wait(for: [expectation], timeout: 0.01)
    }

    func testValidateEmailReturnFailure() {
        // Given
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        let result = viewController.validateEmail(email: "nonvalidemail")
            switch result {
            case false:
                // Then
                expectation.fulfill()
            case true:
                XCTFail("It's not ok, test should returns failure")
            }
        wait(for: [expectation], timeout: 0.01)
    }

    func testConvertDateToIntegerTimestampReturnSucces() {
        // Given
        initSUT()
        let date = Date(timeIntervalSince1970: 1697819040)
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        let result = viewController.convertDateToIntegerTimestamp(date: date)
            switch result {
            case 1697819040:
                // Then
                expectation.fulfill()
            default:
                XCTFail("It's not ok, test should returns success")
            }
        wait(for: [expectation], timeout: 0.01)
    }

    func testIsUserTakingPartReturnSucces() {
        // Given
        initSUT()
        let ploggers = ["adminemail", "otherplogger"]
        let myemail = "adminemail"
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        let result = viewController.isUserTakingPart(ploggingPloggers: ploggers, userEmail: myemail)
            switch result {
            case true:
                // Then
                expectation.fulfill()
            case false:
                XCTFail("It's not ok, test should returns success")
            }
        wait(for: [expectation], timeout: 0.01)
    }

    func testIsUserTakingPartReturnFailure() {
        // Given
        initSUT()
        let ploggers = ["adminemail", "otherplogger"]
        let myemail = "myemail"
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        let result = viewController.isUserTakingPart(ploggingPloggers: ploggers, userEmail: myemail)
            switch result {
            case false:
                // Then
                expectation.fulfill()
            case true:
                XCTFail("It's not ok, test should returns failure")
            }
        wait(for: [expectation], timeout: 0.01)
    }

    func testConvertPloggingCDBeginningToBeginningStringReturnSucces() {
        // Given
        initSUT()
        let timestampString = "1697819040"
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        let result = viewController.convertPloggingCDBeginningToBeginningString(dateString: timestampString)
            switch result {
            case "2023 Oct 20, 18:24":
                // Then
                expectation.fulfill()
            default:
                XCTFail("It's not ok, test should returns success")
            }
        wait(for: [expectation], timeout: 0.01)
    }

    func testConvertPloggingCDBeginningToBeginningTimestampReturnSucces() {
        // Given
        initSUT()
        let timestampString = "1234567"
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        let result = viewController.convertPloggingCDBeginningToBeginningTimestamp(timestampString: timestampString)
            switch result {
            case 1234567:
                // Then
                expectation.fulfill()
            default:
                XCTFail("It's not ok, test should returns success")
            }
        wait(for: [expectation], timeout: 0.01)
    }
}
