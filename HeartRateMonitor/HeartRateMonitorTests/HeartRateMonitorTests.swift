//
//  HeartRateMonitorTests.swift
//  HeartRateMonitorTests
//
//  Created by Final Year Project Account on 2020/4/21.
//  Copyright © 2020 Final Year Project Account. All rights reserved.
//


//Testing class looking for mistakes that regular expression did not catch
//It was found boundary check was implemeted incorrectly. Fixed in PopUp.swift class.

import XCTest
@testable import HeartRateMonitor

class HeartRateMonitorTests: XCTestCase {
    let popup = PopUp()
    var sut: PopUp!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "PopUp") as? PopUp
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    // MARK: - Name Tests
    
    /**
        Test name on:
         - Boundary (3 and 40)
         - Whitespace
         - Special Characters
     */
    
    let namesFail = [" ","123","_Denis"," denis","mark1","denis _","Denis @ Stepanov", "@denis", "dd", "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"]
    let namesPass = ["Denis", "Denis Stepanov", "Denis     ", "Denis StePaNoV", "Den", "ThisStringIncludesThirtyNineCharacters " ]

    func testName(){
        for name in namesFail {
            XCTAssertFalse(sut.validateName(name: name))
        }
        
        for name in namesPass {
            XCTAssertTrue(sut.validateName(name: name))
        }
    }
    
    // MARK: - Age Tests
    /**
        Test age on:
         - Boundary (3 and 40)
         - Whitespace
         - Only numbers
     */
    let ageFail = [0,120,130,140,99999]
    let agePass = [1,2,50,67,99,119]
    
    func testAge(){
        for age in ageFail {
            XCTAssertFalse(sut.validateAge(age: String(age)))
        }
        
        for age in agePass {
            XCTAssertTrue(sut.validateAge(age: String(age)))
        }
    }
    
    // MARK: - Phobia Tests
    /**
        Test age on:
         - Boundary (5 and 40)
         - Whitespace
         - Special Characters
     */
    let phobiaFail = [" ","123","_phobia"," phobia","phobia _","phobia @ Stepanov", "@phobia", "phob", "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"]
    let phobiaPass = ["Phobia", "Phobia Phobia", "Phobia     ",  "PhObIa pHoBiA", "ThisStringIncludesThirtyNineCharacters "]


    func testPhobia(){
        for phobia in phobiaFail {
            XCTAssertFalse(sut.validatePhobia(phobia: phobia))
        }
        
        for phobia in phobiaPass {
            XCTAssertTrue(sut.validatePhobia(phobia: phobia))
        }
    }
}
