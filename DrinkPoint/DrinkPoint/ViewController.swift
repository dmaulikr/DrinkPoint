//
//  ViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/9/16.
//  Copyright © 2016 DrinkPoint. All rights reserved.
//

import UIKit
import Crashlytics
import LaunchKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Crashlytics "Crash Button" (Uncomment for Release)
//        let button = UIButton(type: UIButtonType.RoundedRect)
//        button.frame = CGRectMake(20, 50, 100, 30)
//        button.setTitle("Crash", forState: UIControlState.Normal)
//        button.addTarget(self, action: #selector(ViewController.crashButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//        view.addSubview(button)

    }

    // Crashlytics "Crash Button" (Uncomment for Release)
//    @IBAction func crashButtonTapped(sender: AnyObject) {
//        Crashlytics.sharedInstance().crash()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}