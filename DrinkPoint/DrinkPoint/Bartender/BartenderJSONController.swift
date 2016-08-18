//
//  BartenderJSONController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/5/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import Foundation

class JSONController {
    
    static func queryRecipes() -> [Recipe] {
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
        if let dictionaryObject = object as? [[String: AnyObject]]{
            for dictionary in dictionaryObject {
                if let recipeObject = Recipe(dictionary: dictionary){
                    recipes.append(recipeObject)
                }
            }
            return recipes
        } else {
            return []
        }
    }
    
    static func queryItems() -> [Item] {
        var items: [Item] = []
        guard let path = NSBundle.mainBundle().pathForResource("items", ofType: "json") else {return []}
        guard let json = NSData(contentsOfFile: path) else {return []}
        let object: AnyObject
        do {
            object = try NSJSONSerialization.JSONObjectWithData(json, options: [])
        } catch {
            print("JSON failed")
            return []
        }
        if let dictionaryObject = object as? [String: AnyObject]{
            guard let dictionaryArray = dictionaryObject["drinks"] as? [[String: AnyObject]] else {return []}
            for item in dictionaryArray {
                if let itemObject = Item(dictionary: item) {
                    items.append(itemObject)
                }
            }
            return items
        }
        return []
    }
}