//
//  UIViewTestCase.swift
//  PloggingTests
//
//  Created by adeline honore on 03/12/2023.
//

import UIKit
import XCTest
@testable import Plogging

final class UIViewTestCase: XCTestCase {

    // Given
    private var view: UIView!

    private func initSUT(testCase: TestCase = .uiView) {
        view = UIView()
    }

    override func tearDown() {
        super.setUp()
        view = nil
    }

    func testGetPloggingDurationReturnSucces() {
        // Given
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Should return success")
        // Then
        let result = view.getPloggingDuration(distance: 12)
        switch result {
        case "approximate duration of the race : 3h":
            expectation.fulfill()
        default:
            XCTFail("It's not ok, test should returns success")
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
