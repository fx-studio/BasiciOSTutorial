//
//  Book.swift
//  ProjectTemplate
//
//  Created by Le Phuong Tien on 1/2/20.
//  Copyright © 2020 Fx Studio. All rights reserved.
//

import Foundation
import RealmSwift

final class Book: Object {
    @objc dynamic var title = ""
    @objc dynamic var subTitle = ""
    @objc dynamic var price = 0
    
    override static func primaryKey() -> String? {
        return "title"
    }
}
