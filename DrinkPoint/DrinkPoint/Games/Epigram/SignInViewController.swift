//
//  SignInViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/28/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit
import TwitterKit
import DigitsKit
import Crashlytics

class SignInViewController: UIViewController, UIAlertViewDelegate {

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var signInTwitterButton: UIButton!
    @IBOutlet weak var signInDigitsButton: UIButton!

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        decorateButton(signInTwitterButton, color: UIColor.whiteColor())
        decorateButton(signInDigitsButton, color: UIColor.whiteColor())
        let image = UIImage(named: "Digits")?.imageWithRenderingMode(.AlwaysTemplate)
        signInDigitsButton.setImage(image, forState: .Normal)
    }

    private func navigateToMainAppScreen() {
        performSegueWithIdentifier("ShowThemeChooser", sender: self)
    }

    @IBAction func signInWithTwitter(sender: UIButton) {
        Twitter.sharedInstance().logInWithCompletion { session, error in
            if session != nil {
                self.navigateToMainAppScreen()
                Crashlytics.sharedInstance().setUserIdentifier(session!.userID)
                Crashlytics.sharedInstance().setUserName(session!.userName)
                Answers.logLoginWithMethod("Twitter", success: true, customAttributes: ["User ID": session!.userID])
            } else {
                Answers.logLoginWithMethod("Twitter", success: false, customAttributes: ["Error": error!.localizedDescription])
            }
        }
    }

    @IBAction func signInWithDigits(sender: UIButton) {
        let configuration = DGTAuthenticationConfiguration(accountFields: .DefaultOptionMask)
        configuration.appearance = DGTAppearance()
        configuration.appearance.backgroundColor = UIColor.blackColor()
        configuration.appearance.accentColor = UIColor.whiteColor()
        Digits.sharedInstance().authenticateWithViewController(nil, configuration:configuration) { (session, error) in
            if session != nil {
                self.navigateToMainAppScreen()
                Crashlytics.sharedInstance().setUserIdentifier(session.userID)
                Answers.logLoginWithMethod("Digits", success: true, customAttributes: ["User ID": session.userID])
            } else {
                Answers.logLoginWithMethod("Digits", success: false, customAttributes: ["Error": error.localizedDescription])
            }
        }
    }

    @IBAction func skipSignIn(sender: AnyObject) {
        Answers.logCustomEventWithName("Skipped Sign In", customAttributes: nil)
    }

    private func decorateButton(button: UIButton, color: UIColor) {
        button.layer.masksToBounds = false
        button.layer.borderColor = color.CGColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 6
    }
}