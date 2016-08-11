//
//  ErrorHandling.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 8/2/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit

struct ErrorHandling {
    
    static let ErrorOKButton  = "Got It!"
    static let ErrorDefaultMessage  = "Please try again"
    
    static func defaultErrorHandler(error: NSError?, title: String) {
        let alert = UIAlertController(title: title, message: ErrorDefaultMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: ErrorOKButton, style: UIAlertActionStyle.Default, handler: nil))
        
        let window = UIApplication.sharedApplication().windows[0]
        window.rootViewController?.presentViewControllerFromTopViewController(alert, animated: true, completion: nil)
    }
    
    static func presentAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: ErrorOKButton, style: UIAlertActionStyle.Default, handler: nil))
        let window = UIApplication.sharedApplication().windows[0]
        window.rootViewController?.presentViewControllerFromTopViewController(alert, animated: true, completion: nil)
    }
}