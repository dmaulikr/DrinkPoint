//
//  SettingsViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/11/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController!.navigationBar.barTintColor = UIColor(red: 0.031, green: 0.102, blue: 0.125, alpha: 1.00) // Hex #081a20
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        navigationController!.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor()]

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
