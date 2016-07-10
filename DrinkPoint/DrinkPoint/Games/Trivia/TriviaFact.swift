//
//  TriviaFact.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/2/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import Foundation

struct TriviaFact {

    let session = NSURLSession.sharedSession()
    
    func randomFact() -> NSString {
        let randomFact: NSString = "Happy to present an awesome fact!"
        return randomFact
    }
}