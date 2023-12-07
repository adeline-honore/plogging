//
//  OnboardingViewControllerTestCase.swift
//  PloggingTests
//
//  Created by adeline honore on 07/12/2023.
//

import UIKit
import XCTest
@testable import Plogging
final class OnboardingViewControllerTestCase: XCTestCase {

    // Given
    private var viewController: OnboardingViewController!
    private func initSUT(testCase: TestCase = .uiViewController) {
        viewController = OnboardingViewController(imageName: "icon", textLabelText: Texts.onBoardingTitle.value, nextContinueButtonTitle: "Next", delegateVC: PresentationViewController() as OnboardingViewControllerDelegate)
    }

    override func tearDown() {
        super.setUp()
        viewController = nil
    }

    func testValidateEmailSuccess() {
        // Given
        initSUT()
        // When
        let result = OnboardingViewController(imageName: "icon", textLabelText: Texts.onBoardingTitle.value, nextContinueButtonTitle: "Next", delegateVC: PresentationViewController() as OnboardingViewControllerDelegate)
        // Then
        XCTAssertNotNil(result)
    }
}
