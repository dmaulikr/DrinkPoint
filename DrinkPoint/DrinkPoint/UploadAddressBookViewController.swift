////
////  UploadAddressBookViewController.swift
////  DrinkPoint
////
////  Created by Paul Kirk Adams on 7/23/16.
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
//        authenticateButton.center = CGPointMake(self.view.center.x, self.view.center.y - 150)
//        self.view.addSubview(authenticateButton)
//    }
// 
//    private func uploadDigitsContacts(session: DGTSession) {
//        let digitsContacts = DGTContacts(userSession: session)
//        digitsContacts.startContactsUploadWithCompletion { result, error in
//            if result != nil {
//                print("Of your \(result.totalContacts) contacts, DrinkPoint uploaded \(result.numberOfUploadedContacts) successfully!")
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
//                let alertController = UIAlertController(title: "Lookup Complete", message: message, preferredStyle: .Alert)
//                let cancel = UIAlertAction(title: "Got It!", style: .Cancel, handler:nil)
//                alertController.addAction(cancel)
//                self.presentViewController(alertController, animated: true, completion: nil)
//            }
//        }
//    }
//}