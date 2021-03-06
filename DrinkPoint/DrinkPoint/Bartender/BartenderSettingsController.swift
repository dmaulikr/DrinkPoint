//
//  BartenderSettingsController.swift
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
                Item(alcohol: true,  name: "Gin",          category: "hardDrink"),
                Item(alcohol: true,  name: "Vodka",        category: "hardDrink"),
                Item(alcohol: true,  name: "Rum",          category: "hardDrink"),
                Item(alcohol: true,  name: "Whiskey",      category: "hardDrink"),
                Item(alcohol: false, name: "Ice",          category: "ice"),
                Item(alcohol: false, name: "Water",        category: "softDrink"),
                Item(alcohol: false, name: "Salt",         category: "spice"),
                Item(alcohol: false, name: "Pepper",       category: "spice")]
            ItemController.sharedController.addPrepopulatedItems(arrayOfItems)
        }
    }
    
    static func checkOnHand() -> UIViewController? {
        if !NSUserDefaults.standardUserDefaults().boolForKey("DisplayedAddItems") {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "DisplayedAddItems")
            let nothingOnHandAlertController = UIAlertController(title: "More Items On Hand Offer Wider Varieties!", message: "Tap cart to add your favorite drink ingredients", preferredStyle: .Alert)
            let continueAction = UIAlertAction(title: "Got It!", style: .Default) { (action) in
                print(action)
            }
            nothingOnHandAlertController.addAction(continueAction)
            return nothingOnHandAlertController
        } else {
            print("Add more items for wider variety")
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