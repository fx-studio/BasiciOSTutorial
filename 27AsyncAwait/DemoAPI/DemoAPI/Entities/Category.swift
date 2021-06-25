//
//  Category.swift
//  DemoAPI
//
//  Created by Tien Le P. VN.Danang on 6/25/21.
//

import Foundation

struct Category: Codable, Hashable {
    var strCategory: String
}

struct CategoryResult: Codable {
    var drinks: [Category]
}
