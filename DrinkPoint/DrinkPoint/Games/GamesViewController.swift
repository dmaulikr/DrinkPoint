//
//  GamesViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/10/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit

class GamesViewController: UIViewController {

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}