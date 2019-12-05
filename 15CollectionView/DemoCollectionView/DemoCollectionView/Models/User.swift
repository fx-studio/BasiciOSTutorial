//
//  User.swift
//  DemoCollectionView
//
//  Created by Le Phuong Tien on 12/4/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import Foundation

final class User {
    var name: String
    var avatar: String
    
    init(name: String, avatar: String) {
        self.name = name
        self.avatar = avatar
    }
}

extension User {
    static func getDummyDatas() -> [User] {
        var users: [User] = []
        
        for i in 1...30 {
            let user = User(name: "User \(i)", avatar: "\(i%10)")
            users.append(user)
        }
        
        return users
    }
}
