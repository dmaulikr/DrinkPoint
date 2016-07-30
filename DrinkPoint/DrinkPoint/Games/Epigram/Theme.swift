//
//  Theme.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/28/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import Foundation

public class Theme {

    let name: String
    let words: [String]
    let pictures: [String]

    init?(jsonDictionary: [String: AnyObject]) {
        if let optionalName = jsonDictionary["name"] as? String,
           let optionalWords = jsonDictionary["words"] as? [String],
           let optionalPictures = jsonDictionary["pictures"] as? [String] {
            name = optionalName
            words = optionalWords
            pictures = optionalPictures
        } else {
            name = ""
            words = []
            pictures = []
            return nil
        }
    }

    public func getRandomWords(wordCount: Int) -> [String] {
        var wordsCopy = [String](words)
        wordsCopy.sortInPlace({ (_,_) in return arc4random() < arc4random() })
        return Array(wordsCopy[0..<wordCount])
    }

    public func getRandomPicture() -> String? {
        var picturesCopy = [String](pictures)
        picturesCopy.sortInPlace({ (_,_) in return arc4random() < arc4random() })
        return picturesCopy.first
    }

    class func getThemes() -> [Theme] {
        var themes = [Theme]()
        let path = NSBundle.mainBundle().pathForResource("Themes", ofType: "json")!
        if let jsonData = try? NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe),
           let jsonArray = (try? NSJSONSerialization.JSONObjectWithData(jsonData, options: [])) as? [AnyObject] {
            themes = jsonArray.flatMap() {
                return Theme(jsonDictionary: $0 as! [String: AnyObject])
            }
        }
        return themes
    }
}