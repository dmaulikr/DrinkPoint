//
//  UIViewControllerExtension.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 8/2/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    public func presentViewControllerFromTopViewController(viewControllerToPresent: UIViewController, animated: Bool = false, completion: (() -> Void)? = nil) {
        if self is UINavigationController {
            let navigationController = self as! UINavigationController
            navigationController.topViewController!.presentViewControllerFromTopViewController(viewControllerToPresent, animated: animated, completion: nil)
        } else if (presentedViewController != nil) {
            presentedViewController!.presentViewControllerFromTopViewController(viewControllerToPresent, animated: true, completion: nil)
        } else {
            presentViewController(viewControllerToPresent, animated: animated, completion: completion)
        }
    }
}