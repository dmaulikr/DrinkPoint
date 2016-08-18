//
//  AppDelegate.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/9/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit
//import Fabric
//import SpeechKit
//import mopub_ios_sdk
//import Crashlytics
//import DigitsKit
//import TwitterKit
//import LaunchKit
//import FBSDKCoreKit
//import FacebookCore

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
//    var audioPlayer: AVAudioPlayer? = nil
    
    func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UITabBar.appearance().translucent = true
        UITabBar.appearance().barTintColor = UIColor.blackColor()
        UITabBar.appearance().tintColor = UIColor.redColor()
        
//        Fabric.sharedSDK().debug = true
//        let welcome = "Welcome to DrinkPoint! “Have fun having fun!”"
//        assert(NSBundle.mainBundle().objectForInfoDictionaryKey("Fabric") != nil, welcome)
//        Fabric.with([Crashlytics.self, Twitter.self, Digits.self, MoPub.self, SKSession.self])
//        if Twitter.sharedInstance().sessionStore.session() == nil && Digits.sharedInstance().session() == nil {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let signInViewController: AnyObject! = storyboard.instantiateViewControllerWithIdentifier("SignInViewController")
//            window?.rootViewController = signInViewController as? UIViewController
//        }
//        self.logUser()
        
//        LaunchKit.launchWithToken("5BVpp5-2e7tKRD1ldaPRZK6gpJcWYaW_oWEEwvcJOqRL")
//        LaunchKit.sharedInstance().debugMode = true
//        LaunchKit.sharedInstance().verboseLogging = true
        
        // LaunchKit Onboarding always presents (disable for production)
//        let lk = LaunchKit.sharedInstance()
//        lk.presentOnboardingUIOnWindow(self.window!) { _ in
//            print("Showed onboarding!")
//        }
        
        // LaunchKit Onboarding presents once (disable for debugging)
        //        let defaults = NSUserDefaults.standardUserDefaults()
        //        let hasShownOnboarding = defaults.boolForKey("shownOnboardingBefore")
        //        if !hasShownOnboarding {
        //            let lk = LaunchKit.sharedInstance()
        //            lk.presentOnboardingUIOnWindow(self.window!) { _ in
        //                print("Showed onboarding!")
        //                defaults.setBool(true, forKey: "shownOnboardingBefore")
        //            }
        //        }
        
//        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
//    func logUser() {
//        Crashlytics.sharedInstance().setUserEmail("user@fabric.io")
//        Crashlytics.sharedInstance().setUserIdentifier("12345")
//        Crashlytics.sharedInstance().setUserName("Test User")
//    }
    
//    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
//        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
//    }
    
    func applicationWillResignActive(application: UIApplication) {
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
//        FBSDKAppEvents.activateApp()
//        AppEventsLogger.activate(application)
//        SDKSettings.enableLoggingBehavior(.AppEvents)
    }
    
    func applicationWillTerminate(application: UIApplication) {
    }
}