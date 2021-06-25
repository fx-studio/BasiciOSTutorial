//
//  Drink.swift
//  DemoAPI
//
//  Created by Tien Le P. VN.Danang on 6/25/21.
//

import Foundation

struct Drink: Codable {
    var strDrink: String
    var strDrinkThumb: String
    var idDrink: String
}

struct DrinkResult: Codable {
    var drinks: [Drink]
}
