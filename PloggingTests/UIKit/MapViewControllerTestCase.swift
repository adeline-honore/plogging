//
//  MapViewControllerTestCase.swift
//  PloggingTests
//
//  Created by adeline honore on 06/12/2023.
//

import UIKit
import XCTest
@testable import Plogging

final class MapViewControllerTestCase: XCTestCase {
    // Given
    private var mapViewController: MapViewController!

    private func initSUT(testCase: TestCase = .uiViewController) {
        mapViewController = MapViewController()
    }

    private func ploggingOne() -> Plogging {
        var plogging: Plogging = Plogging()
        plogging.admin = "adeline@email.fr"
        plogging.id = "EEZZ-000-24-JAAUG-WWWW574"
        plogging.beginning = 1715938200
        plogging.distance = 16
        plogging.latitude = 48.8975424
        plogging.longitude = 2.3854289
        plogging.place = "Porte de la Villette"
        plogging.ploggers = ["adeline@email.fr"]

        return plogging
    }

    private func ploggingTwo() -> Plogging {
        var plogging: Plogging = Plogging()
        plogging.admin = "unadmin@plogging.fr"
        plogging.id = "EEZZ-000-24-JAAUG-WWWW998"
        plogging.beginning = 1767938200
        plogging.distance = 18
        plogging.latitude = 48.8638284
        plogging.longitude = 2.3342584
        plogging.place = "1er Arr."
        plogging.ploggers = ["unadmin@plogging.fr", "adeline@email.fr", "unautre@autre.fr"]

        return plogging
    }

    override func tearDown() {
        super.setUp()
        mapViewController = nil
    }

    func testFilterPloggingList() {
        // Given
        initSUT()
        let ploggingAPIList: [Plogging] = [ploggingOne(), ploggingTwo()]
        // When
        let filteredPloggingList =
        mapViewController.filterPloggingList(ploggings: ploggingAPIList)
        // Then
        XCTAssertNotNil(filteredPloggingList)
    }

    func testMapPloggingsIsNotNil() {
        // Given
        initSUT()
        let ploggingAPIList: [Plogging] = [ploggingOne(), ploggingTwo()]
        // When
        MapViewController.ploggings = ploggingAPIList
        // Then
        XCTAssertNotNil(MapViewController.ploggings)
        MapViewController.ploggings = []
    }

    func testMapPloggingsFirstAdminValue() {
        // Given
        initSUT()
        let ploggingAPIList: [Plogging] = [ploggingOne(), ploggingTwo()]
        // When
        MapViewController.ploggings = ploggingAPIList
        // Then
        XCTAssertEqual(ploggingAPIList.first?.admin, "adeline@email.fr")
        MapViewController.ploggings = []
    }

    func testMapPloggingsLaststAdminValue() {
        // Given
        initSUT()
        let ploggingAPIList: [Plogging] = [ploggingOne(), ploggingTwo()]
        // When
        MapViewController.ploggings = ploggingAPIList
        // Then
        XCTAssertEqual(ploggingAPIList.last?.admin, "unadmin@plogging.fr")
        MapViewController.ploggings = []
    }
}
