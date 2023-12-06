//
//  PloggingDetailsViewControllerTestCase.swift
//  PloggingTests
//
//  Created by adeline honore on 06/12/2023.
//

import UIKit
import XCTest
@testable import Plogging

final class PloggingDetailsViewControllerTestCase: XCTestCase {

    // Given
    private var ploggingDetailsViewController: PloggingDetailsViewController!
    private var viewController: UIViewController!

    private func initSUT(testCase: TestCase = .uiViewController) {
        ploggingDetailsViewController = PloggingDetailsViewController()
    }

    private var ploggingUITest: PloggingUI = PloggingUI(id: "ploggingId", admin: "userTest", beginningTimestamp: 12345, beginningString: "2023 Oct 20, 18h24", place: "", latitude: 12, longitude: 23, isTakingPart: true, distance: 12, ploggers: ["thisUser"])

    func testPloggingUIIsNotNil() {
        // Given
        initSUT()
        // When
        ploggingDetailsViewController.ploggingUI = ploggingUITest
        // Then
        XCTAssertNotNil(ploggingDetailsViewController.ploggingUI)
    }

    func testIfUserIsAdminOfPlogging() {
        // Given
        initSUT()
        let userDefaultAppEmail = UserDefaults.standard.string(forKey: "emailAddress")
        UserDefaults.standard.set("userTest", forKey: "emailAddress")
        ploggingDetailsViewController.ploggingUI = ploggingUITest
        // When
        let result = ploggingDetailsViewController.isUserIsAdmin(ploggingUI: ploggingUITest)
        // Then
        XCTAssertTrue(result)
        UserDefaults.standard.set(userDefaultAppEmail, forKey: "emailAddress")
    }
}
