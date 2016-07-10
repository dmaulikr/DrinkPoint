//
//  CocktailsRecipe.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/5/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import Foundation

class Recipe {
    
    private let nameKey = "name"
    private let ingredientsKey = "ingredients"
    private let volumeKey = "volume"
    private let instructionsKey = "instructions"
    
    var name: String = ""
    var ingredients: [[String:String]] = []
    var instructions: String = ""
    var totalIngredients: Int?
    var userIngredients: Int?
    
    init?(dictionary: [String: AnyObject]) {
        guard let name = dictionary[nameKey] as? String,
                let instructions = dictionary[instructionsKey] as? String,
            let ingredients = dictionary[ingredientsKey] as? [[String:String]] else {
                self.instructions = ""
                self.name = ""
                self.ingredients = [["":""]]
                return nil
        }
        self.name = name
        self.instructions = instructions
        self.ingredients = ingredients
    }
}