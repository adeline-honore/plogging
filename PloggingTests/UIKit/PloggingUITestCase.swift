//
//  PloggingUITestCase.swift
//  PloggingTests
//
//  Created by adeline honore on 06/12/2023.
//

import UIKit
import XCTest
@testable import Plogging

final class PloggingUITestCase: XCTestCase {
    private func plogging() -> Plogging {
        var plogging: Plogging = Plogging()
        plogging.admin = "userTest"
        plogging.id = "EEZZ-000-24-JAAUG-WWWW574"
        plogging.beginning = 1715938200
        plogging.distance = 16
        plogging.latitude = 48.8975424
        plogging.longitude = 2.3854289
        plogging.place = "Porte de la Villette"
        plogging.ploggers = ["adeline@email.fr"]

        return plogging
    }

    func testPloggingUIInitFromPlogging() {
        let ploggingUI: PloggingUI = PloggingUI(plogging: plogging(), scheduleTimestamp: plogging().beginning, scheduleString: PloggingUI().displayUIDateFromIntegerTimestamp(timestamp: plogging().beginning), isTakingPartUI: true)
        XCTAssertNotNil(ploggingUI)
    }

    func testIsValidPloggingUIReturnFalse() {
        let ploggingUITest: PloggingUI = PloggingUI(id: "ploggingId", admin: "userTest", beginningTimestamp: 12345, beginningString: "2023 Oct 20, 18h24", place: "", latitude: 12, longitude: 23, isTakingPart: true, distance: 12, ploggers: ["thisUser"])
        let isValidResult = ploggingUITest.isValid
        XCTAssertFalse(isValidResult)
    }

    func testIsValidPloggingUIReturnTrue() {
        let ploggingUITest: PloggingUI = PloggingUI(id: "ploggingId", admin: "userTest", beginningTimestamp: 12345, beginningString: "2023 Oct 20, 18h24", place: "Paris 1 er", latitude: 12, longitude: 23, isTakingPart: true, distance: 12, ploggers: ["thisUser"])
        let isValidResult = ploggingUITest.isValid
        XCTAssertTrue(isValidResult)
    }

    func testDisplayUIDateFromIntegerTimestamp() {
        let dateStringResult = PloggingUI().displayUIDateFromIntegerTimestamp(timestamp: 1697819040)
        XCTAssertEqual(dateStringResult, "2023 10 20, 18:24")
    }
}
