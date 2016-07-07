//
//  AppDelegate.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/9/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import GameAnalytics
import Mapbox
import LaunchKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func prefersStatusBarHidden() -> Bool {
        return true
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UIBarButtonItem.appearance().tintColor = UIColor.blackColor()
        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UITabBar.appearance().translucent = false
        UITabBar.appearance().barTintColor = UIColor.blackColor()
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        
        Fabric.sharedSDK().debug = true

        Fabric.with([Crashlytics.self, GameAnalytics.self, MGLAccountManager.self])
        // TODO: Move this to where you establish a user session
        self.logUser()

        // Enable log to output simple details (disable in production)
        GameAnalytics.setEnabledInfoLog(true)
        // Enable log to output full event JSON (disable in production)
        GameAnalytics.setEnabledVerboseLog(true)

        // Example: configure available virtual currencies and item types for later use in resource events
        // GameAnalytics.configureAv$ailableResourceCurrencies(["gems", "gold"])
        // GameAnalytics.configureAvailableResourceItemTypes(["boost", "lives"])

        // Example: configure available custom dimensions for later use when specifying these
        // GameAnalytics.configureAvailableCustomDimensions01(["ninja", "samurai"])
        // GameAnalytics.configureAvailableCustomDimensions02(["whale", "dolphin"])
        // GameAnalytics.configureAvailableCustomDimensions03(["horde", "alliance"])

        GameAnalytics.configureBuild("1.0.0")
        GameAnalytics.initializeWithConfiguredGameKeyAndGameSecret()

        // Initialize LaunchKit
        LaunchKit.launchWithToken("5BVpp5-2e7tKRD1ldaPRZK6gpJcWYaW_oWEEwvcJOqRL")
        LaunchKit.sharedInstance().debugMode = true
        LaunchKit.sharedInstance().verboseLogging = true

        // LaunchKit Onboarding always presents (disable for production)
        let lk = LaunchKit.sharedInstance()
        lk.presentOnboardingUIOnWindow(self.window!) { _ in
            print("Showed onboarding!")
        }

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

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }

    func logUser() {
        // TODO: Use the current user's information
        // You can call any combination of these three methods
        Crashlytics.sharedInstance().setUserEmail("user@fabric.io")
        Crashlytics.sharedInstance().setUserIdentifier("12345")
        Crashlytics.sharedInstance().setUserName("Test User")
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {

        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
//        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
//        loginManager.logOut()        
    }
}