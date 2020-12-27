//
//  HomeViewModel.swift
//  ProtocolVSClosure
//
//  Created by Le Phuong Tien on 12/27/20.
//

import Foundation
protocol HomeViewModelDataSource {
    func getNumber1(viewmodel: HomeViewModel) -> Int
    func getNumber2(viewmodel: HomeViewModel) -> Int
}

protocol HomeViewModelDelegate {
    func viewmodel(viewmodel: HomeViewModel, didFinishedWith number1: Int, number2: Int, result: Float)
    func viewmodel(viewmodel: HomeViewModel, didFaileddWith number1: Int, number2: Int, errorMessage: String)
}

class HomeViewModel {
    
    // MARK: - Type alias
    typealias ResultCompletion = (Float, String?) -> Void
    typealias NumberCompletion = () -> Int
    
    // MARK: - Properties
    var number1: Int
    var number2: Int
    var result: Float = 0
    
    // MARK: - protocols
    var delegate: HomeViewModelDelegate?
    var dataSource: HomeViewModelDataSource?
    
    // MARK: - init
    init(number1: Int, number2: Int) {
        self.number1 = number1
        self.number2 = number2
    }
    
    // MARK: - Data with Protocol
    func getData() {
        if let dataSource = dataSource {
            number1 = dataSource.getNumber1(viewmodel: self)
            number2 = dataSource.getNumber2(viewmodel: self)
        } else {
            number1 = 0
            number2 = 0
        }
    }
    
    // MARK: - Action with Protocol
    func add() {
        getData()
        
        // process
        result = Float(number1 + number2)
        
        // return
        if let delegate = delegate {
            delegate.viewmodel(viewmodel: self, didFinishedWith: number1, number2: number2, result: result)
        }
    }
    
    func sub() {
        getData()
        
        // process
        result = Float(number1 - number2)
        
        // return
        if let delegate = delegate {
            delegate.viewmodel(viewmodel: self, didFinishedWith: number1, number2: number2, result: result)
        }
    }
    
    
    func mul() {
        getData()
        
        // process
        result = Float(number1 * number2)
        
        // return
        if let delegate = delegate {
            delegate.viewmodel(viewmodel: self, didFinishedWith: number1, number2: number2, result: result)
        }
    }
    
    func div() {
        getData()
        
        if let delegate = delegate {
            // validate
            if number2 != 0 {
                // process
                result = Float(number1) / Float(number2)
                
                // return
                delegate.viewmodel(viewmodel: self, didFinishedWith: number1, number2: number2, result: result)
            } else {
                // return
                delegate.viewmodel(viewmodel: self, didFaileddWith: number1, number2: number2, errorMessage: "Input error!")
            }
        }
    }
    
    // MARK: - Callback in function
    func getData(number1Completed: () -> Int, number2Completed: () -> Int) {
        self.number1 = number1Completed()
        self.number2 = number2Completed()
    }
    
    func add(number1: Int, number2: Int, completed:(Float, String?) -> Void) {
        self.number1 = number1
        self.number2 = number2
        self.result = Float(number1) + Float(number2)
        
        completed(result, nil)
    }
    
    func sub(number1: Int, number2: Int, completed:(Float, String?) -> Void) {
        self.number1 = number1
        self.number2 = number2
        self.result = Float(number1) * Float(number2)
        
        completed(result, nil)
    }
    
    func mul(number1: Int, number2: Int, completed:(Float, String?) -> Void) {
        self.number1 = number1
        self.number2 = number2
        self.result = Float(number1) - Float(number2)
        
        completed(result, nil)
    }
    
    func div(number1: Int, number2: Int, completed:(Float, String?) -> Void) {
        if number2 != 0 {
            self.number1 = number1
            self.number2 = number2
            self.result = Float(number1) / Float(number2)
            
            completed(result, nil)
        } else {
            completed(0, "Input Error!")
        }
    }
    
    // MARK: - Callback with alias
    func getData2(number1Completed: NumberCompletion, number2Completed: NumberCompletion) {
        self.number1 = number1Completed()
        self.number2 = number2Completed()
    }
    
    func add2(number1: Int, number2: Int, completed: ResultCompletion) {
        self.number1 = number1
        self.number2 = number2
        self.result = Float(number1) + Float(number2)
        
        completed(result, nil)
    }
    
    func sub2(number1: Int, number2: Int, completed:ResultCompletion) {
        self.number1 = number1
        self.number2 = number2
        self.result = Float(number1) * Float(number2)
        
        completed(result, nil)
    }
    
    func mul2(number1: Int, number2: Int, completed: ResultCompletion) {
        self.number1 = number1
        self.number2 = number2
        self.result = Float(number1) - Float(number2)
        
        completed(result, nil)
    }
    
    func div2(number1: Int, number2: Int, completed: ResultCompletion) {
        if number2 != 0 {
            self.number1 = number1
            self.number2 = number2
            self.result = Float(number1) / Float(number2)
            
            completed(result, nil)
        } else {
            completed(0, "Input Error!")
        }
    }
}
