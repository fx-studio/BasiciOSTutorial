//
//  OperatorTest.swift
//  DemoUnitTestTests
//
//  Created by Le Phuong Tien on 8/12/20.
//  Copyright © 2020 Fx Studio. All rights reserved.
//

import XCTest
@testable import DemoUnitTest

class OperatorTest: XCTestCase {
    
    var fxOperator: FXOperator?

    override func setUpWithError() throws {
        fxOperator = FXOperator(number1: 1, number2: 2)
    }

    override func tearDownWithError() throws {
    }
    
    func testInput() throws {
        XCTAssertEqual(fxOperator?.number1, 1, "Nhập đúng 1 = 1")
    }
    
    func testInputFail() throws {
        XCTAssertNotEqual(fxOperator?.number2, 1, "Nhập khác 1")
    }
    
    func testAdd() throws {
        let result = fxOperator?.add()
        XCTAssertEqual(result, 3, "1 + 2 = 3")
    }
    
    func testSub() throws {
        let result = fxOperator?.sub()
        XCTAssertEqual(result, -1, "1 - 2 = -1")
    }
    
    func testMul() throws {
        let result = fxOperator?.mul()
        XCTAssertEqual(result, 2, "1 * 2 = 2")
    }
    
    func testDiv() throws {
        let result = fxOperator?.div()
        XCTAssertEqual(result, 0, "1 / 2 = 0")
    }

    func testPerformanceExample() throws {
        self.measure {
        }
    }
}
