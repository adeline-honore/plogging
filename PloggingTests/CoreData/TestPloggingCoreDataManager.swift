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
        var thisPloggingUI = PloggingUI(plogging: Plogging(), schedule: Date())
        
        thisPloggingUI.id = "AB1"
        thisPloggingUI.admin = "him-self"
        thisPloggingUI.beginning = Date()
        thisPloggingUI.place = "here"
        thisPloggingUI.latitude = 1.12345
        thisPloggingUI.longitude = 83.12345
        thisPloggingUI.ploggers = ["him-self", "an-other"]
        thisPloggingUI.isTakingPart = true
        thisPloggingUI.distance = 12
        
        return thisPloggingUI
    }()
    
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
            print("error, tests fails !")
        }
    }
    
    func testSetPlogging() {
        do {
            
            let settedPloggingUI: PloggingUI = {
                var thisPloggingUI = PloggingUI(plogging: Plogging(), schedule: Date())
                
                thisPloggingUI.id = "AB1"
                thisPloggingUI.admin = "him-self"
                thisPloggingUI.beginning = Date()
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
            XCTAssertTrue(ploggingUI.id == getPloggings.first?.id)
            XCTAssertTrue(settedPloggingUI.distance == getPloggings.first?.distance)
        } catch {
            print("error, tests fails !")
        }
    }

}
