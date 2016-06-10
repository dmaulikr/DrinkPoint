//
//  ViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/9/16.
//  Copyright © 2016 DrinkPoint. All rights reserved.
//

import UIKit
import GameKit
import Crashlytics
import LaunchKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBAudienceNetwork

class ViewController: UIViewController, GKGameCenterControllerDelegate, FBAdViewDelegate {

    var drinkPointScore: Int64 = 0

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        LaunchKit.sharedInstance().presentAppReleaseNotesIfNeededFromViewController(self) { (didPresent: Bool) -> Void in
            if didPresent {
                print("Release Notes card presented")
            }
        }
        // Uncomment for debugging
        LaunchKit.sharedInstance().debugAlwaysPresentAppReleaseNotes = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Crashlytics "Crash Button" (Uncomment for Release)
        //        let button = UIButton(type: UIButtonType.RoundedRect)
        //        button.frame = CGRectMake(20, 50, 100, 30)
        //        button.setTitle("Crash", forState: UIControlState.Normal)
        //        button.addTarget(self, action: #selector(ViewController.crashButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        //        view.addSubview(button)

        // Use to test Facebook integration
        let facebookLoginButton: FBSDKLoginButton = FBSDKLoginButton()
        facebookLoginButton.center = self.view.center
        self.view!.addSubview(facebookLoginButton)

        FBAdSettings.addTestDevice("b981ff62ed0cc52075e3061484e089601b66e1cc")
        let adView: FBAdView = FBAdView(placementID: "175149402879956_175211062873790", adSize: kFBAdSizeHeight50Banner, rootViewController: self)
        adView.delegate = self
        adView.hidden = true
        self.view!.addSubview(adView)
        adView.loadAd()

        authenticateLocalPlayer() // Checks whether user logged into Apple's Game Center
    }

    func adView(adView: FBAdView, didFailWithError error: NSError) {
        NSLog("Ad failed to load")
        adView.hidden = true
    }

    func adViewDidLoad(adView: FBAdView) {
        NSLog("Ad was loaded and ready to be displayed")
        adView.hidden = false
    }

    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if (viewController != nil) {
                self.presentViewController(viewController!, animated: true, completion: nil)
            }
            else {
                print("Is local player authenticated? \(GKLocalPlayer.localPlayer().authenticated)")
            }
        }
    }

    // Crashlytics "Crash Button" (Uncomment for Release)
    //    @IBAction func crashButtonTapped(sender: AnyObject) {
    //        Crashlytics.sharedInstance().crash()
    //    }

    func postScoreToLeaderboard() {
        if GKLocalPlayer.localPlayer().authenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: "drinkpoint_leaderboard")
            scoreReporter.value = drinkPointScore
            let scoreArray: [GKScore] = [scoreReporter]
            GKScore.reportScores(scoreArray, withCompletionHandler: nil)
        }
        print("DrinkPoint Score Reported to Game Center")
        self.presentLeaderboard()
    }

    func presentLeaderboard() {
        let leaderboardVC = GKGameCenterViewController()
        leaderboardVC.leaderboardIdentifier = "drinkpoint_leaderboard"
        leaderboardVC.gameCenterDelegate = self
        presentViewController(leaderboardVC, animated: true, completion: nil)
    }

    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}