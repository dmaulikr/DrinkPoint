//
//  DrinkClinkDrink.swift
//  DrinkClink
//
//  Created by Paul Kirk Adams on 6/24/16.
//  Copyright © 2016 DrinkPoint. All rights reserved.
//

import SpriteKit

enum DrinkType: Int, CustomStringConvertible {
  case Unknown = 0, Martini, Wine, Beer, Whiskey, BloodyMary, BlueLagoon
  
  var spriteName: String {
    let spriteNames = [
      "Martini",
      "Wine",
      "Beer",
      "Whiskey",
      "BloodyMary",
      "BlueLagoon"]
    
    return spriteNames[rawValue - 1]
  }
  
  var highlightedSpriteName: String {
    return spriteName + "-Highlighted"
  }
  
  var description: String {
    return spriteName
  }
  
  static func random() -> DrinkType {
    return DrinkType(rawValue: Int(arc4random_uniform(6)) + 1)!
  }
}


func ==(lhs: Drink, rhs: Drink) -> Bool {
  return lhs.column == rhs.column && lhs.row == rhs.row
}

class Drink: CustomStringConvertible, Hashable {
  
  var column: Int
  var row: Int
  let drinkType: DrinkType
  var sprite: SKSpriteNode?
  
  init(column: Int, row: Int, drinkType: DrinkType) {
    self.column = column
    self.row = row
    self.drinkType = drinkType
  }
  
  var description: String {
    return "type:\(drinkType) square:(\(column),\(row))"
  }
  
  var hashValue: Int {
    return row*10 + column
  }
}