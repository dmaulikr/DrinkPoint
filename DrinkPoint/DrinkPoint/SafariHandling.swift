//
//  SafariHandling.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 8/2/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit
import SafariServices

class SafariHandling {
    static func presentSafariVC(url: NSURL) {
        let safariVC = SFSafariViewController(URL: url)
        let window = UIApplication.sharedApplication().windows[0]
        window.rootViewController?.presentViewControllerFromTopViewController(safariVC, animated: true, completion: nil)
    }
}