//
//  PlinkChain.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/24/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

class Chain: Hashable, CustomStringConvertible {

    var drinks = [Drink]()

    enum ChainType: CustomStringConvertible {
        case Horizontal
        case Vertical

        var description: String {
            switch self {
            case .Horizontal: return "Horizontal"
            case .Vertical: return "Vertical"
            }
        }
    }

    var chainType: ChainType
    var score = 0

    init(chainType: ChainType) {
        self.chainType = chainType
    }

    func addDrink(drink: Drink) {
        drinks.append(drink)
    }

    func firstDrink() -> Drink {
        return drinks[0]
    }

    func lastDrink() -> Drink {
        return drinks[drinks.count - 1]
    }

    var length: Int {
        return drinks.count
    }

    var description: String {
        return "type:\(chainType) drinks:\(drinks)"
    }

    var hashValue: Int {
        return drinks.reduce (0) { $0.hashValue ^ $1.hashValue }
    }    
}

func ==(lhs: Chain, rhs: Chain) -> Bool {
    return lhs.drinks == rhs.drinks
}