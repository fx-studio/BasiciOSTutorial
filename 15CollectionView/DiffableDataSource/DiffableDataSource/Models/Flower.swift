//
//  Flower.swift
//  DiffableDataSource
//
//  Created by Le Phuong Tien on 4/29/20.
//  Copyright © 2020 Fx Studio. All rights reserved.
//

import Foundation

class Flower: Hashable {
  
  var id = UUID()
  var name: String
  var description: String
  var imageName: String
  
  init(name: String, description: String, imageName: String) {
    self.name = name
    self.description = description
    self.imageName = imageName
  }
  
  // Hash
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: Flower, rhs: Flower) -> Bool {
    lhs.id == rhs.id
  }
  
}

//MARK: - Dummy Data
extension Flower {
  static func allFlowers() -> [Flower] {
    var flowers: [Flower] = []
    
    let item1 = Flower(name: "African Daisy", description: "Gazania", imageName: "flower1")
    flowers.append(item1)
    
    let item2 = Flower(name: "Begonia", description: "Begoniaceae", imageName: "flower2")
    flowers.append(item2)
    
    let item3 = Flower(name: "California Poppy", description: "Eschscholzia californica", imageName: "flower3")
    flowers.append(item3)
    
    let item4 = Flower(name: "Day Lily", description: "Hemerocallis", imageName: "flower4")
    flowers.append(item4)
    
    let item5 = Flower(name: "Erigeron", description: "Seaside Daisy", imageName: "flower5")
    flowers.append(item5)
    
    let item6 = Flower(name: "Meconopsis", description: "Blue Himalayan Poppy", imageName: "flower6")
    flowers.append(item6)
    
    let item7 = Flower(name: "Osteospermum", description: "Calendula Family, Cape Daisy", imageName: "flower7")
    flowers.append(item7)
    
    let item8 = Flower(name: "Violet", description: "Violaceae Family", imageName: "flower8")
    flowers.append(item8)
    
    let item9 = Flower(name: "Yellow Bell", description: "Golden Trumpet", imageName: "flower9")
    flowers.append(item9)
    
    let item10 = Flower(name: "Gladiolus", description: "Iris Family", imageName: "flower10")
    flowers.append(item10)
    
    return flowers
  }
}
