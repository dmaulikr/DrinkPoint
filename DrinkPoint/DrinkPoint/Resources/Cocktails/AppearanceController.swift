//
//  AppearanceController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/5/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit

class AppearanceController {
    
    class func setupAppearance() {
        UINavigationBar.appearance().tintColor = .lightColor()
        UITabBar.appearance().tintColor = .lightColor()
        UIBarButtonItem.appearance().tintColor = .lightColor()
    }
}

extension UIColor {
    
    class func darkColor() -> UIColor {
        return UIColor(red: 0.031, green: 0.102, blue: 0.125, alpha: 1.00) // Hex #081a20
    }
    
    class func lightColor() -> UIColor {
        return UIColor.whiteColor()
    }
}