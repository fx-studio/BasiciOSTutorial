//
//  Calculator.swift
//  MVC
//
//  Created by Le Phuong Tien on 11/13/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import Foundation

final class Calculator {
    func add(a: Float, b: Float) -> Float {
        return a + b
    }
    
    func sub(a: Float, b: Float) -> Float {
        return a - b
    }
    
    func mul(a: Float, b: Float) -> Float {
        return a * b
    }
    
    func div(a: Float, b: Float) -> Float {
        if b == 0 {
            return 0
        } else {
            return a / b
        }
    }
}
