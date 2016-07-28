////
////  UploadAddressBookViewController.swift
////  DrinkPoint
////
////  Created by Paul Kirk Adams on 7/27/16.
////  Copyright © 2016 BinaryBastards. All rights reserved.
////
//
//import UIKit
//import DigitsKit
//
//class UploadAddressBookViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let authenticateButton = DGTAuthenticateButton { session, error in
//            if session != nil {
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
//                    self.uploadDigitsContacts(session)
//                }
//            }
//        }
//        authenticateButton.center = self.view.center
//        authenticateButton.digitsAppearance = self.makeDigitsTheme()
//        self.view.addSubview(authenticateButton)
//    }
//    
//    func makeDigitsTheme() -> DGTAppearance {
//        let digitsTheme = DGTAppearance();
//        digitsTheme.bodyFont = UIFont(name: "SanFranciscoDisplay-Light", size: 16);
//        digitsTheme.labelFont = UIFont(name: "SanFranciscoDisplay-Regular", size: 17);
//        digitsTheme.accentColor = UIColor.orangeColor()
//        digitsTheme.backgroundColor = UIColor.blackColor()
//        digitsTheme.logoImage = UIImage(named: "DrinkPoint")
//        return digitsTheme;
//    }
//    
//    private func uploadDigitsContacts(session: DGTSession) {
//        let digitsContacts = DGTContacts(userSession: session)
//        digitsContacts.startContactsUploadWithCompletion { result, error in
//            if result != nil {
//                // The result object tells you how many of the contacts were uploaded.
//                print("DrinkPoint successfully uploaded \(result.numberOfUploadedContacts) of your  \(result.totalContacts) contacts!")
//            }
//            self.findDigitsFriends(session)
//        }
//    }
//    
//    private func findDigitsFriends(session: DGTSession) {
//        let digitsContacts = DGTContacts(userSession: session)
//        digitsContacts.lookupContactMatchesWithCursor(nil) { (matches, nextCursor, error) -> Void in
//            print("Friends:")
//            for digitsUser in matches {
//                print("Digits ID: \(digitsUser.userID)")
//            }
//            dispatch_async(dispatch_get_main_queue()) {
//                let message = "DrinkPoint found \(matches.count) of your friends!"
//                let alertController = UIAlertController(title: "Lookup complete", message: message, preferredStyle: .Alert)
//                let cancel = UIAlertAction(title: "Got It!", style: .Cancel, handler:nil)
//                alertController.addAction(cancel)
//                self.presentViewController(alertController, animated: true, completion: nil)
//            }
//        }
//    }
//}
