//
//  CocktailsSettingsController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/5/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit

class SettingsController {
    
    static func firstLaunch() {
        if(NSUserDefaults.standardUserDefaults().boolForKey("HasLaunchedOnce")) {
            ItemController.sharedController.loadFromPersistentStorage()
        } else {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "HasLaunchedOnce")
            NSUserDefaults.standardUserDefaults().synchronize()
            let arrayOfItems = [
                Item(alcohol: false, name: "Ice", category: "ice"),
                Item(alcohol: false, name: "Water", category: "softDrink"),
                Item(alcohol: false, name: "Salt", category: "spice"),
                Item(alcohol: false, name: "Black Pepper", category: "spice"),
                Item(alcohol: false, name: "Sugar", category: "spice")]
            ItemController.sharedController.addPrepopulatedItems(arrayOfItems)
        }
    }
    
    static func checkOnHand() -> UIViewController? {
        if !NSUserDefaults.standardUserDefaults().boolForKey("DisplayedAddItems") {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "DisplayedAddItems")
            let nothingOnHandAlertController = UIAlertController(title: "More Items Needed!", message: "Tap cart icon at top left to add alcohol and mixers", preferredStyle: .Alert)
            let continueAction = UIAlertAction(title: "Got It!", style: .Default) { (action) in
                print(action)
            }
            nothingOnHandAlertController.addAction(continueAction)
            return nothingOnHandAlertController
        } else {
            print("More items needed")
            return nil
        }
    }
    
    static func randomAlert() -> UIViewController? {
        if !NSUserDefaults.standardUserDefaults().boolForKey("DisplayedRecipes") {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "DisplayedRecipes")
            let randomAlertController = UIAlertController(title: "Feel Adventurous?", message: "Shake iPhone or tap Red Die below", preferredStyle: .Alert)
            let continueAction = UIAlertAction(title: "Got It!", style: .Default) { (action) in
                print(action)
            }
            randomAlertController.addAction(continueAction)
            return randomAlertController
        } else {
            print("Recipes not randomized")
            return nil
        }
    }
}