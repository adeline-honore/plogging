//
//  PloggingTestCase.swift
//  PloggingTests
//
//  Created by adeline honore on 03/12/2023.
//

import XCTest
@testable import Plogging

final class PloggingTestCase: XCTestCase {

    private var ploggingService: PloggingService!

    override func tearDown() {
        super.setUp()
        ploggingService = nil
    }

    private func initSUT(isFailed: Bool = false) {
        ploggingService = PloggingService(network: PloggingNetworkFake(testCase: .plogging, isFailed: isFailed))
    }

    private func ploggingToGet() -> Plogging {
        var plogging: Plogging = Plogging()
        plogging.admin = "honore_adeline@yahoo.fr"
        plogging.id = "EEZZ-000-24-JAAUG-WWWW574"
        plogging.beginning = 1715938200
        plogging.distance = 16
        plogging.latitude = 48.8975424
        plogging.longitude = 2.3854289
        plogging.place = "Porte de la Villette"
        plogging.ploggers = ["honore_adeline@yahoo.fr"]

        return plogging
    }

    private func ploggingToCreate() -> Plogging {
        var plogging: Plogging = Plogging()
        plogging.admin = "unadmin@plogging.fr"
        plogging.id = "EEZZ-000-24-JAAUG-WWWW998"
        plogging.beginning = 1767938200
        plogging.distance = 18
        plogging.latitude = 48.8638284
        plogging.longitude = 2.3342584
        plogging.place = "1er Arr."
        plogging.ploggers = ["unadmin@plogging.fr", "honore_adeline@yahoo.fr", "unautre@autre.fr"]

        return plogging
    }

    private func ploggingToSet() -> Plogging {
        var plogging: Plogging = Plogging()
        plogging.admin = "honore_adeline@yahoo.fr"
        plogging.id = "EEZZ-000-24-JAAUG-WWWW574"
        plogging.beginning = 1715938200
        plogging.distance = 16
        plogging.latitude = 48.8975424
        plogging.longitude = 2.3854289
        plogging.place = "Porte de la Villette"
        plogging.ploggers = ["honore_adeline@yahoo.fr", "unautre@autre.fr"]

        return plogging
    }

    // MARK: - Get Plogging List

    func testGetPloggingListShouldPostSuccess() throws {
        // Given
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        // Then
        ploggingService.getPloggingList { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("Should return failure")
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetPloggingPostListSuccessOnCount() {
        // Given
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        // Then
        ploggingService.getPloggingList { result in
            switch result {
            case .success:
                XCTAssertEqual(try? result.get().count, 2)
                expectation.fulfill()
            case .failure:
                XCTFail("Should return failure")
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetPloggingListPostSuccessOnEndIndex() {
        // Given
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        // Then
        ploggingService.getPloggingList { result in
            switch result {
            case .success:
                XCTAssertEqual(try? result.get().endIndex, 2)
                expectation.fulfill()
            case .failure:
                XCTFail("Should return failure")
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetPloggingListPostSuccessOnFirstPloggingId() {
        // Given
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        // Then
        ploggingService.getPloggingList { result in
            switch result {
            case .success:
                XCTAssertEqual(try? result.get().first?.id, self.ploggingToGet().id)
                expectation.fulfill()
            case .failure:
                XCTFail("Should return failure")
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetPloggingListPostSuccessOnFirstPloggingAdmin() {
        // Given
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        // Then
        ploggingService.getPloggingList { result in
            switch result {
            case .success:
                XCTAssertEqual(try? result.get().first?.admin, self.ploggingToGet().admin)
                expectation.fulfill()
            case .failure:
                XCTFail("Should return failure")
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetPloggingListPostSuccessOnFirstPloggingBeginning() {
        // Given
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        // Then
        ploggingService.getPloggingList { result in
            switch result {
            case .success:
                XCTAssertEqual(try? result.get().first?.beginning, self.ploggingToGet().beginning)
                expectation.fulfill()
            case .failure:
                XCTFail("Should return failure")
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetPloggingListPostSuccessOnFirstPloggingPlace() {
        // Given
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        // Then
        ploggingService.getPloggingList { result in
            switch result {
            case .success:
                XCTAssertEqual(try? result.get().first?.place, self.ploggingToGet().place)
                expectation.fulfill()
            case .failure:
                XCTFail("Should return failure")
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetPloggingListShouldReturnFailure() {
        // Given
        initSUT(isFailed: true)
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        ploggingService.getPloggingList { result in
            switch result {
            case .success:
                XCTFail("Should return failure")
            case .failure:
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }

    // MARK: - Get Plogging List

    func testCreatePloggingShouldPostSuccess() throws {
        // Given
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        // Then
        ploggingService.createOrUpdatePlogging(plogging: self.ploggingToCreate()) { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("Should return failure")
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testCreatePloggingShouldReturnFailure() {
        // Given
        initSUT(isFailed: true)
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        ploggingService.getPloggingList { result in
            switch result {
            case .success:
                XCTFail("Should return failure")
            case .failure:
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testSetPloggingShouldPostSuccess() throws {
        // Given
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        // Then
        ploggingService.createOrUpdatePlogging(plogging: self.ploggingToSet()) { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("Should return failure")
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testSetPloggingShouldReturnFailure() {
        // Given
        initSUT(isFailed: true)
        // When
        let expectation = XCTestExpectation(description: "Should return failure")
        // Then
        ploggingService.getPloggingList { result in
            switch result {
            case .success:
                XCTFail("Should return failure")
            case .failure:
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
