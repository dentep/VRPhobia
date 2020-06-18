//
//  HeartRateMonitorUITests.swift
//  HeartRateMonitorUITests
//
//  Created by Final Year Project Account on 2020/4/21.
//  Copyright © 2020 Final Year Project Account. All rights reserved.
//

import XCTest
@testable import HeartRateMonitor

class HeartRateMonitorUITests: XCTestCase {
    func testWalkthrough() {
        let app = XCUIApplication()
        app.launch()

        //start the measurement process
        let app2 = app
        let startButton = app2.buttons["START"]
        startButton.tap()
        
        //stop the measurement process
        app.buttons["STOP"].tap()
        app.textFields["John Smith"].tap()
        
        //user input (name)
        app2.keys["d"].tap()
        app2.keys["e"].tap()
        app2.keys["n"].tap()
        app2.keys["i"].tap()
        app2.keys["s"].tap()
        
        //pull down the keyobard
        app2.buttons["Return"].tap()

        //user input (age)
        app.textFields["30"].tap()
        app2.keys["2"].tap()
        app2.keys["3"].tap()

        //user input (phobia)
        app.textFields["Acrophobia"].tap()
        app2.keys["a"].tap()
        app2.keys["c"].tap()
        app2.keys["r"].tap()
        app2.keys["o"].tap()
        app2.keys["p"].tap()
        app2.keys["h"].tap()
        app2.keys["o"].tap()
        app2.keys["b"].tap()
        app2.keys["i"].tap()
        app2.keys["a"].tap()
        
        //finish
        app2.buttons["Return"].tap()
        app.buttons["CONTINUE"].tap()
        app.buttons["SHARE"].tap()
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
