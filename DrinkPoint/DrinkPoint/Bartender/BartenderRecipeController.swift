//
//  BartenderRecipeController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/5/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import Foundation

class RecipeController {
    
    static let sharedInstance = RecipeController()
    var possibleRecipes: [Recipe] = []
    
    func populatePossibleRecipes() {
        self.possibleRecipes = filterRecipes(ItemController.sharedController.onHand, recipes: JSONController.queryRecipes())
    }
    
    func filterRecipes(onHand: [Item], recipes: [Recipe]) -> [Recipe] {
        var canMake = true
        var filteredRecipes = [Recipe]()
        var onHandStrings = [String]()
        for item in onHand {
            let nameString = item.name.lowercaseString
            onHandStrings.append(nameString)
        }
        for recipe in recipes {
            var recipeItems = [String]()
            for item in recipe.items {
                let itemName = item["name"]!.lowercaseString
                recipeItems.append(itemName)
            }
            let itemCount = recipeItems.count
            var containCount = 0
            canMake = true
            for recipeItem in recipeItems {
                if onHandStrings.contains(recipeItem) {
                    containCount += 1
                }
            }
            if itemCount > containCount + 1 {
                canMake = false
            }
            if itemCount == containCount + 1 && itemCount <= 2 {
                canMake = false
            }
            if canMake == true {
                filteredRecipes.append(recipe)
                print(recipe.name)
                recipe.totalItems = itemCount
                recipe.userItems = containCount
            }
        }
        return filteredRecipes
    }
}