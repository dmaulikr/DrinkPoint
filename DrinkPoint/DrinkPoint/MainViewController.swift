//
//  MainViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/9/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit
import GameKit
import Crashlytics
import LaunchKit
import TwitterKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBAudienceNetwork

class MainViewController: UIViewController, GKGameCenterControllerDelegate, FBAdViewDelegate, FBSDKLoginButtonDelegate {
    
    var drinkPointScore: Int64 = 0
        
    @IBOutlet var userProfileImage: UIImageView!
    @IBOutlet var welcomeLabel: UILabel!

    // Crashlytics "Crash Button" (disable for debugging)
    //    @IBAction func crashButtonTapped(sender: AnyObject) {
    //        Crashlytics.sharedInstance().crash()
    //    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        configureCrashButton() // disable for release
        self.navigationController?.navigationBarHidden = false
        configureTwitterLogin()
        configureFacebookAd()
        configureFacebookLogin()
        authenticateLocalPlayer()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        LaunchKit.sharedInstance().presentAppReleaseNotesIfNeededFromViewController(self) { (didPresent: Bool) -> Void in
            if didPresent {
                print("Release Notes card presented")
            }
        }
        // disable for release
        LaunchKit.sharedInstance().debugAlwaysPresentAppReleaseNotes = true
    }
    
//    func configureCrashButton() {
//        let button = UIButton(type: UIButtonType.RoundedRect)
//        button.frame = CGRectMake(20, 50, 100, 30)
//        button.setTitle("Crash", forState: UIControlState.Normal)
//        button.addTarget(self, action: #selector(MainViewController.crashButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//        view.addSubview(button)
//    }
    
    func configureTwitterLogin() {
        let twitterLoginButton = TWTRLogInButton { (session, error) in
            if let unwrappedSession = session {
                let alert = UIAlertController(title: "Logged In",
                    message: "User \(unwrappedSession.userName) has logged in",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                NSLog("Login error: %@", error!.localizedDescription);
            }
        }
        twitterLoginButton.center.x = self.view.center.x
        twitterLoginButton.center.y = self.view.center.y + 210
        self.view.addSubview(twitterLoginButton)
    }
    
    func configureFacebookAd() {
        FBAdSettings.addTestDevice("b981ff62ed0cc52075e3061484e089601b66e1cc")
        let adView: FBAdView = FBAdView(placementID: "825492567551864_833251636775957", adSize: kFBAdSizeHeight50Banner, rootViewController: self)
        adView.delegate = self
        adView.hidden = true
        self.view!.addSubview(adView)
        adView.loadAd()
    }
    
    func configureFacebookLogin() {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
            let facebookLoginButton: FBSDKLoginButton = FBSDKLoginButton()
            facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
            facebookLoginButton.delegate = self
            facebookLoginButton.center.x = self.view.center.x
            facebookLoginButton.center.y = self.view.center.y + 167
            self.view.addSubview(facebookLoginButton)
        } else {
            let facebookLoginButton: FBSDKLoginButton = FBSDKLoginButton()
            facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
            facebookLoginButton.delegate = self
            facebookLoginButton.center.x = self.view.center.x
            facebookLoginButton.center.y = self.view.center.y + 165
            self.view.addSubview(facebookLoginButton)
        }
    }
    
    func adView(adView: FBAdView, didFailWithError error: NSError) {
        NSLog("Facebook Ad failed to load")
        adView.hidden = true
    }
    
    func adViewDidLoad(adView: FBAdView) {
        NSLog("Facebook Ad loaded and ready to be displayed")
        adView.hidden = false
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User logged into Facebook")
        if ((error) != nil) {
        } else if result.isCancelled {
            // Handle cancellations
        } else {
            if result.grantedPermissions.contains("email") {
                FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields": "first_name, last_name, picture.type(large)"]).startWithCompletionHandler { (connection, result, error) -> Void in
                    let strFirstName: String = (result.objectForKey("first_name") as? String)!
                    let strLastName: String = (result.objectForKey("last_name") as? String)!
                    let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                    self.welcomeLabel.text = "Welcome, \(strFirstName) \(strLastName)!"
                    self.userProfileImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: strPictureURL)!)!)
                }
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        userProfileImage.image = nil
        welcomeLabel.text = ""
        print("User logged out of Facebook")
    }
    
    func returnUserData() {
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                print("Fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                print("User Email is: \(userEmail)")
            }
        })
    }
    
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if (viewController != nil) {
                self.presentViewController(viewController!, animated: true, completion: nil)
            } else {
                print("Is local player authenticated? \(GKLocalPlayer.localPlayer().authenticated)")
            }
        }
    }
    
    func postScoreToLeaderboard() {
        if GKLocalPlayer.localPlayer().authenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: "drinkpoint_leaderboard")
            scoreReporter.value = drinkPointScore
            let scoreArray: [GKScore] = [scoreReporter]
            GKScore.reportScores(scoreArray, withCompletionHandler: nil)
        }
        print("DrinkPoint score reported to Game Center")
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