//
//  AboutViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/28/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit
import Crashlytics
import TwitterKit
import DigitsKit

class AboutViewController: UIViewController {

    @IBOutlet weak var signOutButton: UIButton!

    var logoView: UIImageView!

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.titleTextAttributes = titleDict as? [String: AnyObject]
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        Answers.logCustomEventWithName("Viewed About", customAttributes: nil)
    }

    @IBAction func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func learnMore(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://drinkpoint.pkadams67.io")!)
    }

    @IBAction func signOut(sender: AnyObject) {
        let sessionStore = Twitter.sharedInstance().sessionStore
        if let userId = sessionStore.session()?.userID {
            sessionStore.logOutUserID(userId)
        }
        Digits.sharedInstance().logOut()
        Crashlytics.sharedInstance().setUserIdentifier(nil)
        Crashlytics.sharedInstance().setUserName(nil)
        Answers.logCustomEventWithName("Signed Out", customAttributes: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInViewController: UIViewController! = storyboard.instantiateViewControllerWithIdentifier("SignInViewController") 
        presentViewController(signInViewController, animated: true, completion: nil)
    }
}