//
//  User.swift
//  DemoTableView
//
//  Created by Le Phuong Tien on 11/19/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import Foundation

final class User {
    var name: String
    var age: Int
    var gender: Bool
    
    init(name: String, age: Int, gender: Bool) {
        self.name = name
        self.age = age
        self.gender = gender
    }
    
    func getSubTitle() -> String {
        return "\(gender ? "Male" : "Female") - \(age) year olds"
    }
}
