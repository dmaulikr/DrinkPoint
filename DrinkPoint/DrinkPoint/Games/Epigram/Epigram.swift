//
//  Epigram.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/28/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import Foundation

public class Epigram: NSObject, NSCoding {
    
    private struct SerializationKeys {
        static let words = "words"
        static let picture = "picture"
        static let theme = "theme"
        static let date = "date"
        static let uuid = "uuid"
    }
    
    public var words: [String] = []
    public var picture: String = ""
    public var theme: String = ""
    public var date = NSDate()
    public private(set) var UUID = NSUUID()
    
    override init() {
        super.init()
    }
    
    private init(words: [String], picture: String, theme: String, date: NSDate, UUID: NSUUID) {
        self.words = words
        self.picture = picture
        self.theme = theme
        self.date = date
        self.UUID = UUID
    }
    
    convenience init(words: [String], picture: String, theme: String, date: NSDate) {
        self.init(words: words, picture: picture, theme: theme, date: date, UUID: NSUUID())
    }
    
    func getSentence() -> String {
        return words.joinWithSeparator(" ")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        words = aDecoder.decodeObjectForKey(SerializationKeys.words) as! [String]
        picture = aDecoder.decodeObjectForKey(SerializationKeys.picture) as! String
        theme = aDecoder.decodeObjectForKey(SerializationKeys.theme) as! String
        date = aDecoder.decodeObjectForKey(SerializationKeys.date) as! NSDate
        UUID = aDecoder.decodeObjectForKey(SerializationKeys.uuid) as! NSUUID
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(words, forKey: SerializationKeys.words)
        aCoder.encodeObject(picture, forKey: SerializationKeys.picture)
        aCoder.encodeObject(theme, forKey: SerializationKeys.theme)
        aCoder.encodeObject(date, forKey: SerializationKeys.date)
        aCoder.encodeObject(UUID, forKey: SerializationKeys.uuid)
    }
    
    override public func isEqual(object: AnyObject?) -> Bool {
        if let epigram = object as? Epigram {
            return UUID == epigram.UUID
        }
        return false
    }
}