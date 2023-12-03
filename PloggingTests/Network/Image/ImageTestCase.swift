//
//  ImageTestCase.swift
//  PloggingTests
//
//  Created by adeline honore on 03/12/2023.
//

import XCTest
@testable import Plogging

final class ImageTestCase: XCTestCase {

    private let getImageId = "getImagId"
    private let newPloggingId = "newPloggingId"
    private var imageService: ImageService!
    private let mainImageBinary = Data()

    override func tearDown() {
        super.setUp()
        imageService = nil
    }

    private func initSUT(isFailed: Bool = false) {
        imageService = ImageService(network: ImageNetworkFake(testCase: .image, isFailed: isFailed))
    }

    // MARK: - Get Main Image From API
    func testGetImageDataFailure() {
        // Given
        initSUT(isFailed: true)
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        imageService.getImage(ploggingId: getImageId) { result in
            switch result {
            case .failure:
                // Then
                expectation.fulfill()
            case .success:
                XCTFail("It's not ok, test should returns failure")
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testGetImageDataSuccess() {
        // Given
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        // Then
        imageService.getImage(ploggingId: getImageId) { result in
            switch result {
            case .success:
                // Then
                expectation.fulfill()
            case .failure:
                XCTFail("It's not ok, test should returns success")
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }

    // MARK: - Upload Main Image Into API

    func testUploadImageReturnFailure() {
        // Given
        initSUT(isFailed: true)
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        imageService.uploadPhoto(mainImageBinary: mainImageBinary, ploggingId: newPloggingId) { result in
            switch result {
            case .failure:
                // Then
                expectation.fulfill()
            case .success:
                XCTFail("It's not ok, test should returns failure")
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testUploadImageDataSuccess() {
        // Given
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        // Then
        imageService.uploadPhoto(mainImageBinary: mainImageBinary, ploggingId: newPloggingId) { result in
            switch result {
            case .success:
                // Then
                expectation.fulfill()
            case .failure:
                XCTFail("It's not ok, test should returns success")
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }
}
