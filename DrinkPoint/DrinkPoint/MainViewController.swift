//
//  MainViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/9/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit
import Crashlytics
import LaunchKit
import TwitterKit
import DigitsKit
import FacebookCore
import FacebookLogin
import FBAudienceNetwork
import SpeechKit

class MainViewController: UIViewController, FBAdViewDelegate, SKTransactionDelegate,SKAudioPlayerDelegate {

    var skTransaction: SKTransaction?
    var skSession: SKSession?
    
    // Crashlytics "Crash Button" (disable for debugging)
    //    @IBAction func crashButtonTapped(sender: AnyObject) {
    //        Crashlytics.sharedInstance().crash()
    //    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        //        configureCrashButton() // disable for release
        createTtsButton()
        configureFacebookAd()
        configureFacebookLogin()
        configureDigitsLogin()
        configureTwitterLogin()
        createTwitterTimelineButton()
        embeddedTweet()
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

    func createTtsButton() {
        let ttsButton = UIButton(type: UIButtonType.RoundedRect)
        ttsButton.setTitle("Welcome to DrinkPoint!", forState: UIControlState.Normal)
        ttsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        ttsButton.titleLabel!.font = UIFont(name: "SanFranciscoDisplay-Light" , size: 14)
        ttsButton.addTarget(self, action: #selector(MainViewController.toggleTts), forControlEvents: UIControlEvents.TouchUpInside)
        ttsButton.sizeToFit()
        ttsButton.center = CGPointMake(self.view.center.x, self.view.center.y - 255)
        view.addSubview(ttsButton)
        skTransaction = nil
        skSession = SKSession(fabric:())
        skSession!.audioPlayer.delegate = self

    }
    
    func toggleTts() {
        if (skTransaction == nil) {
            skTransaction = skSession!.speakString("Welcome to DrinkPoint!", withLanguage: "eng-GBR", delegate: self)
        } else {
            skTransaction!.cancel()
            skTransaction = nil
        }
    }

    func transaction(transaction: SKTransaction!, didReceiveAudio audio: SKAudio!) {
        NSLog("didReceiveAudio")
        skTransaction = nil
    }
    
    func transaction(transaction: SKTransaction!, didFinishWithSuggestion suggestion: String) {
        NSLog("didFinishWithSuggestion")
    }
    
    func transaction(transaction: SKTransaction!, didFailWithError error: NSError!, suggestion: String) {
        NSLog("didFailWithError: %@. %@", error.description, suggestion)
        skTransaction = nil
    }

    func audioPlayer(player: SKAudioPlayer!, willBeginPlaying audio: SKAudio!) {
        NSLog("willBeginPlaying")
    }
    
    func audioPlayer(player: SKAudioPlayer!, didFinishPlaying audio: SKAudio!) {
        NSLog("didFinishPlaying")
    }

    func configureFacebookAd() {
        FBAdSettings.addTestDevice("b602d594afd2b0b327e07a06f36ca6a7e42546d0")
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
            facebookLoginButton.center = CGPointMake(self.view.center.x, self.view.center.y - 215)
            view.addSubview(facebookLoginButton)
        } else {
            let facebookLoginButton = LoginButton(readPermissions: [.PublicProfile, .Email, .UserFriends])
            facebookLoginButton.center = CGPointMake(self.view.center.x, self.view.center.y - 215)
            view.addSubview(facebookLoginButton)
            print("User not logged into Facebook")
        }
    }
    
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
        digitsAuthButton.center = CGPointMake(self.view.center.x, self.view.center.y - 170)
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
    
    func embeddedTweet() {
        // TODO: Base this Tweet ID on some data from elsewhere in your app
        TWTRAPIClient().loadTweetWithID("631879971628183552") { (tweet, error) in
            if let unwrappedTweet = tweet {
                let tweetView = TWTRTweetView(tweet: unwrappedTweet)
                tweetView.center = CGPointMake(self.view.center.x, self.view.center.y + 85);
                TWTRTweetViewStyle.Compact
                tweetView.theme = .Dark
                tweetView.showActionButtons = true
                self.view.addSubview(tweetView)
            } else {
                NSLog("Tweet load error: %@", error!.localizedDescription);
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}