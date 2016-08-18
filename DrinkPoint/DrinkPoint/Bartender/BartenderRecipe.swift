//
//  BartenderRecipe.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/5/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import Foundation

class Recipe {
    
    private let nameKey = "name"
    private let itemsKey = "items"
    private let volumeKey = "volume"
    private let instructionsKey = "instructions"
    
    var name: String = ""
    var items: [[String: String]] = []
    var instructions: String = ""
    var totalItems: Int?
    var userItems: Int?
    
    init?(dictionary: [String: AnyObject]) {
        guard let name = dictionary[nameKey] as? String,
                let instructions = dictionary[instructionsKey] as? String,
            let items = dictionary[itemsKey] as? [[String: String]] else {
                self.instructions = ""
                self.name = ""
                self.items = [["": ""]]
                return nil
        }
        self.name = name
        self.instructions = instructions
        self.items = items
    }
}