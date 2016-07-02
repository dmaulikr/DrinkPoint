//
//  GamesViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/10/16.
//  Copyright © 2016 DrinkPoint. All rights reserved.
//

import UIKit

class GamesViewController: UIViewController {

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        navigationController!.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}