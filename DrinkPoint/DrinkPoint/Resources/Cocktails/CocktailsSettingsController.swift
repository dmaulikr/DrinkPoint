//
//  CocktailsSettingsController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/5/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit

class SettingsController {
    
    static func firstLaunch() {
        if(NSUserDefaults.standardUserDefaults().boolForKey("HasLaunchedOnce"))
        {
            IngredientController.sharedController.loadFromPersistentStorage()
        }
        else
        {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "HasLaunchedOnce")
            NSUserDefaults.standardUserDefaults().synchronize()
            let arrayOfIngredients = [
                Ingredient(alcohol: false, name: "Ice", category: "ice"),
                Ingredient(alcohol: false, name: "Water", category: "softDrink"),
                Ingredient(alcohol: false, name: "Salt", category: "spice"),
                Ingredient(alcohol: false, name: "Black Pepper", category: "spice"),
                Ingredient(alcohol: false, name: "Sugar", category: "spice")]
            IngredientController.sharedController.addPrepopulatedIngredients(arrayOfIngredients)
        }
    }
    
    static func checkEmptyPantry() -> UIViewController? {
        if !NSUserDefaults.standardUserDefaults().boolForKey("DisplayedAddIngredients") {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "DisplayedAddIngredients")
            let pantryAlertController = UIAlertController(title: "Pantry Needs More Items", message: "Tap cart icon at top left of screen", preferredStyle: .Alert)
            let continueAction = UIAlertAction(title: "Got It!", style: .Default) { (action) in
                print(action)
            }
            pantryAlertController.addAction(continueAction)
            return pantryAlertController
        } else {
            print("More ingredients required")
            return nil
        }
    }
    
    static func randomizeAlert() -> UIViewController? {
        if !NSUserDefaults.standardUserDefaults().boolForKey("DisplayedRecipes") {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "DisplayedRecipes")
            let randomizedAlertController = UIAlertController(title: "Generate Random Recipe", message: "Shake iPhone or tap Die for random recipe.", preferredStyle: .Alert)
            let continueAction = UIAlertAction(title: "Continue", style: .Default) { (action) in
                print(action)
            }
            randomizedAlertController.addAction(continueAction)
            return randomizedAlertController
        } else {
            print("Recipes not randomized")
            return nil
        }
    }
}