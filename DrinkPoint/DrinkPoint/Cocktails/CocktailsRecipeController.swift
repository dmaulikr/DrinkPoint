//
//  CocktailsRecipeController.swift
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
        self.possibleRecipes = filterRecipes(IngredientController.sharedController.myPantry, recipes: JSONController.queryRecipes())
    }
    
    func filterRecipes(pantry: [Ingredient], recipes: [Recipe]) -> [Recipe] {
        var canMake = true
        var filteredRecipes = [Recipe]()
        var pantryStrings = [String]()
        for ingredient in pantry {
            let nameString = ingredient.name.lowercaseString
            pantryStrings.append(nameString)
        }
        for recipe in recipes {
            var recipeIngredients = [String]()
            for ingredient in recipe.ingredients {
                let ingredientName = ingredient["name"]!.lowercaseString
                recipeIngredients.append(ingredientName)
            }
            let ingredientCount = recipeIngredients.count
            var containCount = 0
            canMake = true
            for recipeItem in recipeIngredients {
                if pantryStrings.contains(recipeItem) {
                    containCount += 1
                }
            }
            if ingredientCount > containCount + 1 {
                canMake = false
            }
            if ingredientCount == containCount + 1 && ingredientCount <= 2 {
                canMake = false
            }
            if canMake == true {
                filteredRecipes.append(recipe)
                print(recipe.name)
                recipe.totalIngredients = ingredientCount
                recipe.userIngredients = containCount
            }
        }
        return filteredRecipes
    }
}