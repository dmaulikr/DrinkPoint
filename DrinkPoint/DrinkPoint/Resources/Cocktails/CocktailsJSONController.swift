//
//  CocktailsJSONController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/5/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import Foundation

class JSONController {
    
    static func queryRecipes()->[Recipe]{
        var recipes: [Recipe] = []
        guard let path = NSBundle.mainBundle().pathForResource("recipes", ofType: "json") else {return []}
        guard let json = NSData(contentsOfFile: path) else {return []}
        let object: AnyObject
        do {
            object = try NSJSONSerialization.JSONObjectWithData(json, options: [])
        } catch {
            print("JSON failed")
            return []
        }
        if let dicObject = object as? [[String:AnyObject]]{
            for dictionary in dicObject {
                if let recipeObject = Recipe(dic: dictionary){
                    recipes.append(recipeObject)
                }
            }
            return recipes
        } else {
            return []
        }
    }
    
    static func queryIngredients()->[Ingredient]{
        var ingredients: [Ingredient] = []
        guard let path = NSBundle.mainBundle().pathForResource("ingredients", ofType: "json") else {return []}
        guard let json = NSData(contentsOfFile: path) else {return []}
        let object: AnyObject
        do {
            object = try NSJSONSerialization.JSONObjectWithData(json, options: [])
        } catch {
            print("JSON failed")
            return []
        }
        if let dicObject = object as? [String : AnyObject]{
            guard let dicArray = dicObject["drinks"] as? [[String: AnyObject]] else {return []}
            for ingredient in dicArray {
                if let ingredientObject = Ingredient(dictionary: ingredient){
                    ingredients.append(ingredientObject)
                }
            }
            return ingredients
        }
        return []
    }
}