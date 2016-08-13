//
//  EpigramPersistence.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/28/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import Foundation

private let SingletonSharedInstance = EpigramPersistence()

public class EpigramPersistence {

    private let userDefaultsKey = "io.pkadams67.drinkpoint.epigrams"

    class var sharedInstance: EpigramPersistence {
        return SingletonSharedInstance
    }

    func persistEpigram(epigram: Epigram) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var epigrams: [Epigram]
        if let epigramsArchived: AnyObject = userDefaults.objectForKey(userDefaultsKey) {
            epigrams = NSKeyedUnarchiver.unarchiveObjectWithData(epigramsArchived as! NSData) as! [Epigram]
        } else {
            epigrams = []
        }
        epigrams.insert(epigram, atIndex: 0)
        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(epigrams), forKey: userDefaultsKey)
    }

    func overwriteEpigrams(epigrams: [Epigram]) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(epigrams), forKey: userDefaultsKey)
    }

    func retrieveEpigrams()  -> [Epigram] {
        var epigrams: [Epigram]
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let epigramsArchived: AnyObject = userDefaults.objectForKey(userDefaultsKey) {
            epigrams = NSKeyedUnarchiver.unarchiveObjectWithData(epigramsArchived as! NSData) as! [Epigram]
        } else {
            epigrams = []
        }
        return epigrams
    }
}