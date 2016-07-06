//
//  RootViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/9/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit
import GameKit
import Crashlytics
import LaunchKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBAudienceNetwork

class RootViewController: UIViewController, GKGameCenterControllerDelegate, FBAdViewDelegate, FBSDKLoginButtonDelegate {

    var drinkPointScore: Int64 = 0

    @IBOutlet var facebookButton: FBSDKLoginButton!
    @IBOutlet var userProfileImage: UIImageView!
    @IBOutlet var welcomeLabel: UILabel!
    
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

        // Crashlytics "Crash Button" (Uncomment for debugging)
        //        let button = UIButton(type: UIButtonType.RoundedRect)
        //        button.frame = CGRectMake(20, 50, 100, 30)
        //        button.setTitle("Crash", forState: UIControlState.Normal)
        //        button.addTarget(self, action: #selector(ViewController.crashButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        //        view.addSubview(button)

        // Use to test Facebook integration
        //        let facebookLoginButton: FBSDKLoginButton = FBSDKLoginButton()
        //        facebookLoginButton.center = self.view.center
        //        self.view!.addSubview(facebookLoginButton)

        FBAdSettings.addTestDevice("b981ff62ed0cc52075e3061484e089601b66e1cc")

        let adView: FBAdView = FBAdView(placementID: "825492567551864_833251636775957", adSize: kFBAdSizeHeight50Banner, rootViewController: self)
        adView.delegate = self
        adView.hidden = true
        self.view!.addSubview(adView)
        adView.loadAd()
        
        configureFacebook()

        authenticateLocalPlayer() // Checks whether user logged into Apple's Game Center
    }

    func configureFacebook() {
        facebookButton.readPermissions = ["public_profile", "email", "user_friends"];
        facebookButton.delegate = self
    }
    
    func adView(adView: FBAdView, didFailWithError error: NSError) {
        NSLog("Ad failed to load")
        adView.hidden = true
    }

    func adViewDidLoad(adView: FBAdView) {
        NSLog("Ad was loaded and ready to be displayed")
        adView.hidden = false
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields": "first_name, last_name, picture.type(large)"]).startWithCompletionHandler { (connection, result, error) -> Void in
            let strFirstName: String = (result.objectForKey("first_name") as? String)!
            let strLastName: String = (result.objectForKey("last_name") as? String)!
            let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
            self.welcomeLabel.text = "Welcome, \(strFirstName) \(strLastName)!"
            self.userProfileImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: strPictureURL)!)!)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        userProfileImage.image = nil
        welcomeLabel.text = ""
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

    // Crashlytics "Crash Button" (Uncomment for debugging)
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