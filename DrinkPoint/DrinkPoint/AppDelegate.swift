//
//  AppDelegate.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/9/16.
//  Copyright © 2016 DrinkPoint. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import GameAnalytics
import LaunchKit
import FBSDKCoreKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func prefersStatusBarHidden() -> Bool {
        return true
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        Fabric.with([Crashlytics.self, GameAnalytics.self])
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

        // Configure build version
        GameAnalytics.configureBuild("1.0.0")

        // initialize GameAnalytics - this method will use app keys injected by Fabric
        GameAnalytics.initializeWithConfiguredGameKeyAndGameSecret()
        // to manually specify keys use this method:
        //GameAnalytics.initializeWithGameKey("[game_key]", gameSecret:"[game_secret]")

        // Initialize LaunchKit
        LaunchKit.launchWithToken("5BVpp5-2e7tKRD1ldaPRZK6gpJcWYaW_oWEEwvcJOqRL")

        // LaunchKit Onboarding Always Presents (comment out for release)
        let lk = LaunchKit.sharedInstance()
        lk.presentOnboardingUIOnWindow(self.window!) { _ in
            print("Showed onboarding!")
        }

        // LaunchKit Onboarding Presents Once (comment out for degugging)
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
        return FBSDKApplicationDelegate.sharedInstance().application (application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}