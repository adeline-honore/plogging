//
//  TestPloggingCoreDataManager.swift
//  PloggingTests
//
//  Created by HONORE Adeline on 20/10/2023.
//

import XCTest
import CoreData
@testable import Plogging

class TestPloggingCoreDataManager: XCTestCase {

    var coreDataManager: PloggingCoreDataManager!
    var coreDataStack: CoreDataStack!

    let ploggingUI: PloggingUI = {
        var thisPloggingUI = PloggingUI(plogging: Plogging(), scheduleTimestamp: Int(), scheduleString: String(), isTakingPartUI: true)

        thisPloggingUI.id = "thisPloggingId"
        thisPloggingUI.admin = "him-self"
        thisPloggingUI.beginningTimestamp = 1701123861
        thisPloggingUI.beginningString = "27/11/2023 23:24"
        thisPloggingUI.place = "here"
        thisPloggingUI.latitude = 1.12345
        thisPloggingUI.longitude = 83.12345
        thisPloggingUI.ploggers = ["him-self", "an-other"]
        thisPloggingUI.isTakingPart = true
        thisPloggingUI.distance = 12
        thisPloggingUI.mainImageBinary = Data()

        return thisPloggingUI
    }()

    private let icon = UIImage(imageLiteralResourceName: "icon")

    override func setUpWithError() throws {
        coreDataStack = TestCoreDataStack()
        coreDataManager = PloggingCoreDataManager(
            coreDataStack: coreDataStack,
            managedObjectContext: coreDataStack.viewContext
        )

        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        coreDataStack = nil
        coreDataManager = nil
        try super.tearDownWithError()
    }

    func testGetPlogging() {
        do {

            try coreDataManager.createEntity(ploggingUI: ploggingUI)

            let getPloggings = try coreDataManager.getEntities()

            XCTAssertNotNil(getPloggings)
            XCTAssertTrue(getPloggings.count == 1)
            XCTAssertTrue(ploggingUI.id == getPloggings.first?.id)
        } catch {
            XCTFail("error, tests fails !")
        }
    }

    func testSetPlogging() {
        do {

            let settedPloggingUI: PloggingUI = {
                var thisPloggingUI = PloggingUI(plogging: Plogging(), scheduleTimestamp: Int(), scheduleString: String(), isTakingPartUI: true)

                thisPloggingUI.id = "thisPloggingId"
                thisPloggingUI.admin = "him-self"
                thisPloggingUI.beginningTimestamp = 1701123964
                thisPloggingUI.beginningString = "27/11/2023 23:26"
                thisPloggingUI.place = "here"
                thisPloggingUI.latitude = 1.12345
                thisPloggingUI.longitude = 83.12345
                thisPloggingUI.ploggers = ["him-self", "an-other"]
                thisPloggingUI.isTakingPart = true
                thisPloggingUI.distance = 14

                return thisPloggingUI
            }()

            try coreDataManager.createEntity(ploggingUI: ploggingUI)

            let getPloggings = try coreDataManager.getEntities()

            try coreDataManager.setEntity(ploggingUI: settedPloggingUI)

            XCTAssertNotNil(getPloggings)
            XCTAssertTrue(getPloggings.count == 1)
            XCTAssertTrue(settedPloggingUI.id == getPloggings.first?.id)
            XCTAssertTrue(String(settedPloggingUI.beginningTimestamp) == getPloggings.first?.beginning)
            XCTAssertTrue(settedPloggingUI.distance == Int(getPloggings.first?.distance ?? 0.0))
        } catch {
            XCTFail("error, tests fails !")
        }
    }

    func testRemovePlogging() {
        do {

            try coreDataManager.createEntity(ploggingUI: ploggingUI)

            let getPloggings = try coreDataManager.getEntities()

            XCTAssertNotNil(getPloggings)
            XCTAssertTrue(getPloggings.count == 1)
            XCTAssertTrue(ploggingUI.id == getPloggings.first?.id)
        } catch {
            XCTFail("error, tests fails !")
        }

        do {

            try coreDataManager.removeEntity(id: ploggingUI.id)

            let getPloggings = try coreDataManager.getEntities()

            XCTAssertNotNil(getPloggings)
            XCTAssertTrue(getPloggings.count == 0)
        } catch {
            XCTFail("error, tests fails !")
        }
    }

    func testPloggingUIInitFromPloggingCDOnLongitudeValue() {
        do {
            try coreDataManager.createEntity(ploggingUI: ploggingUI)

            let getPloggings = try coreDataManager.getEntities()
            guard let firstPloggingCD = getPloggings.first else { return XCTFail("error, tests fails !")}
            let ploggingUI: PloggingUI = PloggingUI(ploggingCD: firstPloggingCD, beginningInt: 1701123861, beginningString: "1701123861", isTakingPartUI: true, image: icon)

        XCTAssertEqual(ploggingUI.longitude, 83.12345)
        } catch {
            XCTFail("error, tests fails !")
        }
    }

    func testPloggingUIInitFromPloggingCDOnLatitudeValue() {
        do {
            try coreDataManager.createEntity(ploggingUI: ploggingUI)

            let getPloggings = try coreDataManager.getEntities()
            guard let firstPloggingCD = getPloggings.first else { return XCTFail("error, tests fails !")}
            let ploggingUI: PloggingUI = PloggingUI(ploggingCD: firstPloggingCD, beginningInt: 1701123861, beginningString: "1701123861", isTakingPartUI: true, image: icon)

        XCTAssertEqual(ploggingUI.latitude, 1.12345)
        } catch {
            XCTFail("error, tests fails !")
        }
    }

    func testPloggingUIInitFromPloggingCDOnIdValue() {
        do {
            try coreDataManager.createEntity(ploggingUI: ploggingUI)

            let getPloggings = try coreDataManager.getEntities()
            guard let firstPloggingCD = getPloggings.first else { return XCTFail("error, tests fails !")}
            let ploggingUI: PloggingUI = PloggingUI(ploggingCD: firstPloggingCD, beginningInt: 1701123861, beginningString: "1701123861", isTakingPartUI: true, image: icon)

        XCTAssertEqual(ploggingUI.id, "thisPloggingId"
)
        } catch {
            XCTFail("error, tests fails !")
        }
    }

    func testPloggingUIInitFromPloggingCDOnAdminValue() {
        do {
            try coreDataManager.createEntity(ploggingUI: ploggingUI)

            let getPloggings = try coreDataManager.getEntities()
            guard let firstPloggingCD = getPloggings.first else { return XCTFail("error, tests fails !")}
            let ploggingUI: PloggingUI = PloggingUI(ploggingCD: firstPloggingCD, beginningInt: 1701123861, beginningString: "1701123861", isTakingPartUI: true, image: icon)

        XCTAssertEqual(ploggingUI.admin, "him-self")
        } catch {
            XCTFail("error, tests fails !")
        }
    }

    func testPloggingUIInitFromPloggingCDOnDistanceValue() {
        do {
            try coreDataManager.createEntity(ploggingUI: ploggingUI)

            let getPloggings = try coreDataManager.getEntities()
            guard let firstPloggingCD = getPloggings.first else { return XCTFail("error, tests fails !")}
            let ploggingUI: PloggingUI = PloggingUI(ploggingCD: firstPloggingCD, beginningInt: 1701123861, beginningString: "1701123861", isTakingPartUI: true, image: icon)

        XCTAssertEqual(ploggingUI.distance, 12)
        } catch {
            XCTFail("error, tests fails !")
        }
    }
}
