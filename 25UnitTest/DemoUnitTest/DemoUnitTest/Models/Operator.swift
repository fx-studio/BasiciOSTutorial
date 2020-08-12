//
//  Operator.swift
//  DemoUnitTest
//
//  Created by Le Phuong Tien on 8/12/20.
//  Copyright © 2020 Fx Studio. All rights reserved.
//

import Foundation

final class FXOperator {
    var number1: Int
    var number2: Int
    var result: Int = 0
    
    init(number1: Int, number2: Int) {
        self.number1 = number1
        self.number2 = number2
    }
    
    func add() -> Int {
        result = number1 + number2
        return result
    }
    
    func sub() -> Int {
        result = number1 - number2
        return result
    }
    
    func mul() -> Int {
        result = number1 * number2
        return result
    }
    
    func div() -> Int {
        result = number1 / number2
        return result
    }
}
