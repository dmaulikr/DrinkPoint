//
//  TripleSwap.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/24/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

func ==(lhs: Swap, rhs: Swap) -> Bool {
  return (lhs.drinkA == rhs.drinkA && lhs.drinkB == rhs.drinkB) ||
    (lhs.drinkB == rhs.drinkA && lhs.drinkA == rhs.drinkB)
}

struct Swap: CustomStringConvertible, Hashable {
  let drinkA: Drink
  let drinkB: Drink
  
  init(drinkA: Drink, drinkB: Drink) {
    self.drinkA = drinkA
    self.drinkB = drinkB
  }
  
  var description: String {
    return "swap \(drinkA) with \(drinkB)"
  }
  
  var hashValue: Int {
    return drinkA.hashValue ^ drinkB.hashValue
  }
}
