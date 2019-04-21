//
//  MarvelUITests.swift
//  MarvelUITests
//
//  Created by Alex Rodrigues on 20/04/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import XCTest

class MarvelUITests: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testIfTabbarIsThere() {
        XCTAssertTrue(app.tabBars["Tabbar"].exists)
    }

    func testIfTableIsThere() {
        let exp = expectation(description: "Waiting Screen wake up")
        _ = XCTWaiter.wait(for: [exp], timeout: 5.0)
        XCTAssertTrue(app.collectionViews["HomeCollectionView"].exists)
    }
    
    func testIfTableViewCanScroll() {
        let exp = expectation(description: "Waiting Screen wake up")
        _ = XCTWaiter.wait(for: [exp], timeout: 7.0)
        let collection = app.collectionViews["HomeCollectionView"]
        collection.swipeDown()
        collection.swipeUp()
    }
    
    func testIfCollectionViewCanClick() {
        let exp = expectation(description: "Waiting Screen wake up")
        _ = XCTWaiter.wait(for: [exp], timeout: 5.0)
        let collection = app.collectionViews["HomeCollectionView"]
        collection.cells.element(boundBy: 0)
    }
}
