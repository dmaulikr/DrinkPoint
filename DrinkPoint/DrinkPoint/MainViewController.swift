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
import DigitsKit
import FacebookCore
import FacebookLogin
import FBAudienceNetwork

class MainViewController: UIViewController, GKGameCenterControllerDelegate, FBAdViewDelegate {
    
    var drinkPointScore: Int64 = 0
    
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
        configureDigitsLogin()
        configureTwitterLogin()
        embeddedTweet()
        createTwitterTimelineButton()
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
    
    func configureDigitsLogin() {
        let digitsAuthButton = DGTAuthenticateButton(authenticationCompletion: { (session: DGTSession?, error: NSError?) in
            if (session != nil) {
                let message = "Phone Number: \(session!.phoneNumber)"
                let alertController = UIAlertController(title: "You’re logged in!", message: message, preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: .None))
                self.presentViewController(alertController, animated: true, completion: .None)
            } else {
                NSLog("Authentication error: %@", error!.localizedDescription)
            }
        })
        digitsAuthButton.center = CGPointMake(self.view.center.x, self.view.center.y - 200)
        digitsAuthButton.digitsAppearance = self.makeDigitsTheme()
        self.view.addSubview(digitsAuthButton)
    }
    
    func makeDigitsTheme() -> DGTAppearance {
        let digitsTheme = DGTAppearance();
        digitsTheme.bodyFont = UIFont(name: "SanFranciscoDisplay-Light", size: 16);
        digitsTheme.labelFont = UIFont(name: "SanFranciscoDisplay-Regular", size: 17);
        digitsTheme.accentColor = UIColor.orangeColor()
        digitsTheme.backgroundColor = UIColor.blackColor()
        digitsTheme.logoImage = UIImage(named: "DrinkPoint")
        return digitsTheme;
    }
    
    func configureTwitterLogin() {
        let twitterLoginButton = TWTRLogInButton { (session, error) in
            if let unwrappedSession = session {
                let alert = UIAlertController(title: "Logged In",
                    message: "User \(unwrappedSession.userName) has logged in",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                alert.addAction(UIAlertAction(title: "Got It!", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                NSLog("Login error: %@", error!.localizedDescription);
            }
        }
        twitterLoginButton.center = CGPointMake(self.view.center.x, self.view.center.y - 120)
        self.view.addSubview(twitterLoginButton)
    }
    
    func embeddedTweet() {
        // TODO: Base this Tweet ID on some data from elsewhere in your app
        TWTRAPIClient().loadTweetWithID("631879971628183552") { (tweet, error) in
            if let unwrappedTweet = tweet {
                let tweetView = TWTRTweetView(tweet: unwrappedTweet)
                tweetView.center = CGPointMake(self.view.center.x, self.view.center.y + 70);
                TWTRTweetViewStyle.Compact
                tweetView.theme = .Dark
                tweetView.showActionButtons = true
                self.view.addSubview(tweetView)
            } else {
                NSLog("Tweet load error: %@", error!.localizedDescription);
            }
        }
    }
    
    func createTwitterTimelineButton() {
        let twitterTimelineButton = UIButton(type: .Custom)
        twitterTimelineButton.setTitle("Show Twitter Timeline", forState: .Normal)
        twitterTimelineButton.sizeToFit()
        twitterTimelineButton.center = CGPointMake(self.view.center.x, self.view.center.y - 75)
        twitterTimelineButton.addTarget(self, action: #selector(showTwitterTimeline), forControlEvents: [.TouchUpInside])
        view.addSubview(twitterTimelineButton)
    }
    
    func showTwitterTimeline() {
        let client = TWTRAPIClient()
        let dataSource = TWTRCollectionTimelineDataSource(collectionID: "539487832448843776", APIClient: client)
        let timelineViewControlller = TWTRTimelineViewController(dataSource: dataSource)
        let button = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(dismissTwitterTimeline))
        timelineViewControlller.navigationItem.leftBarButtonItem = button
        let navigationController = UINavigationController(rootViewController: timelineViewControlller)
        showDetailViewController(navigationController, sender: self)
    }

    func dismissTwitterTimeline() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    func configureFacebookAd() {
        FBAdSettings.addTestDevice("b981ff62ed0cc52075e3061484e089601b66e1cc")
        let adView: FBAdView = FBAdView(placementID: "825492567551864_833251636775957", adSize: kFBAdSizeHeight50Banner, rootViewController: self)
        adView.delegate = self
        adView.hidden = true
        self.view!.addSubview(adView)
        adView.loadAd()
    }
    
    func adView(adView: FBAdView, didFailWithError error: NSError) {
        NSLog("Facebook Ad failed to load")
        adView.hidden = true
    }
    
    func adViewDidLoad(adView: FBAdView) {
        NSLog("Facebook Ad loaded and ready to be displayed")
        adView.hidden = false
    }

    func configureFacebookLogin() {
        if AccessToken.current != nil {
            let facebookLoginButton = LoginButton(readPermissions: [.PublicProfile, .Email, .UserFriends])
            facebookLoginButton.center = CGPointMake(self.view.center.x, self.view.center.y + 240)
            view.addSubview(facebookLoginButton)
        } else {
            let facebookLoginButton = LoginButton(readPermissions: [.PublicProfile, .Email, .UserFriends])
            facebookLoginButton.center = CGPointMake(self.view.center.x, self.view.center.y + 240)
            view.addSubview(facebookLoginButton)
            print("User not logged into Facebook")
        }
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