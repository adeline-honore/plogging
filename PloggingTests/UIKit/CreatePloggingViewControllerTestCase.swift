//
//  CreatePloggingViewControllerTestCase.swift
//  PloggingTests
//
//  Created by adeline honore on 06/12/2023.
//

import UIKit
import XCTest
@testable import Plogging

final class CreatePloggingViewControllerTestCase: XCTestCase {
    // Given
    private var createPloggingViewController: CreatePloggingViewController!

    private func initSUT(testCase: TestCase = .uiViewController) {
        createPloggingViewController = CreatePloggingViewController()
    }

    func testStartIntegerTimestamp() {
        // Given
        initSUT()
        // When
        // Then
        XCTAssertEqual(createPloggingViewController.startIntegerTimestamp, 0)
    }

    func testReturnDistanceFromPickerIsNotNil() {
        // Given
        initSUT()
        // When
        let checkReturnDistance =
        createPloggingViewController.returnDistance()
        // Then
        XCTAssertNotNil(checkReturnDistance)
    }

    func testReturnDistanceFromPickerValues() {
        // Given
        initSUT()
        let distanceList = ["", "2", "4", "6", "8", "10", "12", "14", "16", "18", "20"]
        // When
        let checkReturnDistance =
        createPloggingViewController.returnDistance()
        // Then
        XCTAssertEqual(checkReturnDistance, distanceList)
    }
}
