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
        let rfact : NSString = "Happy to provide you with an awesome fact"
        //        let baseURL = NSURL(string: "http://numbersapi.com/random/trivia")
        //        let downloadTask = session.downloadTaskWithURL(baseURL, completionHandler: { (location, response, error) -> Void in
        //            if(error == nil){
        //                let objectData = NSData(contentsOfURL: location)
        //                let tmpData = NSString(contentsOfURL: location, encoding: NSUTF8StringEncoding, error: nil)
        //
        //                return rfact
        //            }
        //        })
        return rfact
    }
}