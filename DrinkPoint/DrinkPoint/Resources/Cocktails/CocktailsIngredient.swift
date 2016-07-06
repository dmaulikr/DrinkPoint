//
//  CocktailsIngredient.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/5/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import Foundation

class Ingredient: Equatable {
    
    private let alcoholKey = "alcohol"
    private let nameKey = "name"
    private let categoryKey = "category"
    
    var alcohol: Bool
    var name: String
    var category: String
    
    init(name: String) {
        self.alcohol = true
        self.name = name
        self.category = ""
    }
    
    init(alcohol: Bool, name: String, category: String) {
        self.alcohol = alcohol
        self.name = name
        self.category = category
    }
    
    init?(dictionary: [String:AnyObject]) {
        
        guard let name = dictionary[nameKey] as? String,
                let category = dictionary[categoryKey] as? String,
        let alcohol = dictionary[alcoholKey] as? Bool else {
                self.alcohol = false
                self.name = ""
                self.category = ""
                return nil
        }
        self.name = name
        self.alcohol = alcohol
        self.category = category
    }
    
    func dictionaryCopy() -> [String: AnyObject] {
        let dictionary = [
            alcoholKey : self.alcohol,
            nameKey : self.name,
            categoryKey: self.category
        ]
        return dictionary as! [String : AnyObject]
    }
}

func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
    return lhs.name == rhs.name
}