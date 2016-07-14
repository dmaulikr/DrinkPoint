//
//  PlinkViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/13/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit
import SpriteKit

class PlinkViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        let skView = self.view as! SKView
        let scene = PlinkScene(size: skView.frame.size)
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlinkViewController.handleApplicationWillResignActive(_:)), name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlinkViewController.handleApplicationDidBecomeActive(_:)), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func handleApplicationWillResignActive (note: NSNotification) {
        let skView = self.view as! SKView
        skView.paused = true
    }

    func handleApplicationDidBecomeActive (note: NSNotification) {
        let skView = self.view as! SKView
        skView.paused = false
    }
}