//
//  WatchMeGoUITests.swift
//  WatchMeGoUITests
//
//  Created by Liza on 18/07/2025.
//

import XCTest

final class WatchMeGoUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    @MainActor
    func testAppLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        
        sleep(3)
        XCTAssertTrue(app.exists)
    }
    
    @MainActor
    func testLoginScreenAfterSplash() throws {
        let app = XCUIApplication()
        app.launch()
        
        sleep(3)
        
        XCTAssertTrue(app.staticTexts["Welcome Back!"].exists)
        XCTAssertTrue(app.staticTexts["Ready to crush your goals?"].exists)
        XCTAssertTrue(app.buttons["Sign In"].exists)
        XCTAssertTrue(app.buttons["No account? Register"].exists)
    }
    
    @MainActor
    func testRegisterScreenElements() throws {
        let app = XCUIApplication()
        app.launch()
        
        sleep(3)
        app.buttons["No account? Register"].tap()
        sleep(1)
        
        XCTAssertTrue(app.staticTexts["Join the Challenge!"].exists)
        XCTAssertTrue(app.staticTexts["Start your fitness journey today"].exists)
        XCTAssertTrue(app.buttons["Create Account"].exists)
        XCTAssertTrue(app.buttons["Already have an account? Sign In"].exists)
    }
    
    @MainActor
    func testNavigationFlow() throws {
        let app = XCUIApplication()
        app.launch()
        
        sleep(3)
        
        app.buttons["No account? Register"].tap()
        sleep(1)
        XCTAssertTrue(app.staticTexts["Join the Challenge!"].exists)
        
        app.buttons["Already have an account? Sign In"].tap()
        sleep(1)
        XCTAssertTrue(app.staticTexts["Welcome Back!"].exists)
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
