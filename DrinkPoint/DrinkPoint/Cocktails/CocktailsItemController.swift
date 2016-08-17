//
//  CocktailsItemController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/5/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import Foundation

class ItemController {
    
    private let itemsKey = "items"
    static let sharedController = ItemController()
    
    var onHand: [Item] = [] {
        didSet {
            let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
            dispatch_async(backgroundQueue, { () -> Void in
                RecipeController.sharedInstance.populatePossibleRecipes()
            })
        }
    }
    
    func addItem(item: Item) {
        if !(onHand.contains(item)) {
            onHand.append(item)
            self.saveToPersistentStorage()
        }
    }
    
    func addPrepopulatedItems(items: [Item]) {
        for item in items {
            addItem(item)
        }
    }
    
    func removeItem(item: Item) {
        if let itemIndex = onHand.indexOf(item) {
            onHand.removeAtIndex(itemIndex)
            self.saveToPersistentStorage()
        }
    }
    
    func loadFromPersistentStorage() {
        let itemDictionariesFromDefaults = NSUserDefaults.standardUserDefaults().objectForKey(itemsKey) as? [Dictionary<String, AnyObject>]
        if let itemDictionaries = itemDictionariesFromDefaults {
            self.onHand = itemDictionaries.map({Item(dictionary: $0)!})
        }
    }
    
    func saveToPersistentStorage() {
        let itemDictionaries = self.onHand.map({$0.dictionaryCopy()})
        NSUserDefaults.standardUserDefaults().setObject(itemDictionaries, forKey: itemsKey)
    }
}