//
//  GamesViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/10/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit
import GameKit
import mopub_ios_sdk
import SpeechKit

var drinkPointScore: Int64 = 0

class GamesViewController: UIViewController, GKGameCenterControllerDelegate, MPAdViewDelegate, SKTransactionDelegate, SKAudioPlayerDelegate {
    
    var skSession: SKSession?
    var skTransaction: SKTransaction?
    var adView: MPAdView = MPAdView(adUnitId: "1115a6eee8e4476ab1ceaebf6d55e5bb", size: MOPUB_BANNER_SIZE)
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        authenticateLocalPlayer()
        createMoPubAdBanner()
        createTtsButton()
    }
    
    func createMoPubAdBanner() {
        self.adView.delegate = self
        self.adView.frame = CGRectMake(30, (self.view.bounds.size.height - MOPUB_BANNER_SIZE.height) - 75, MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height)
        self.view.addSubview(self.adView)
        self.adView.loadAd()
    }
    
    func viewControllerForPresentingModalView() -> UIViewController {
        return self
    }
    
    func createTtsButton() {
        let ttsButton = UIButton(type: UIButtonType.RoundedRect)
        ttsButton.setTitle("Play DrinkPoint Games!", forState: .Normal)
        ttsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        ttsButton.titleLabel!.font = UIFont(name: "SanFranciscoDisplay-Light" , size: 14)
        ttsButton.addTarget(self, action: #selector(GamesViewController.toggleTts), forControlEvents: UIControlEvents.TouchUpInside)
        ttsButton.sizeToFit()
        ttsButton.center = CGPointMake(self.view.center.x, self.view.center.y - 225)
        view.addSubview(ttsButton)
        skTransaction = nil
        skSession = SKSession(fabric:())
        skSession!.audioPlayer.delegate = self
    }
    
    func toggleTts() {
        if (skTransaction == nil) {
            skTransaction = skSession!.speakString("Play DrinkPoint Games!", withLanguage: "eng-GBR", delegate: self)
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