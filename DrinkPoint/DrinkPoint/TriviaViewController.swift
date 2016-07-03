//
//  TriviaViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/2/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit
import Social

class TriviaViewController: UIViewController {

    let colors = TriviaColors()
    let funFact = TriviaFact()
    let session = NSURLSession.sharedSession()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tweetButtonLabel: UIButton!
    @IBOutlet weak var factButtonText: UIButton!
    @IBOutlet weak var factText: UITextView!
    
    @IBAction func tweetButton() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let tweetSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetSheet.setInitialText(factText.text + " #DrinkPoint")
            self.presentViewController(tweetSheet, animated: true, completion: nil)
        } else {
            let alertViewController = UIAlertController(title: "Oops", message: "No Twitter Account connected on the device. Go to Settings > Twitter and add a twitter account", preferredStyle: .Alert)
            let okButton = UIAlertAction(title: "Got It!", style: .Default, handler: nil)
            let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertViewController.addAction(okButton)
            alertViewController.addAction(cancelButton)
            self.presentViewController(alertViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func factButton() {
        let color = colors.randomColor()
        view.backgroundColor = color
        factButtonText.tintColor = color
        randomFact()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        randomFact()
    }
    
    func randomFact() {
        let baseURL = NSURL(string: "http://numbersapi.com/random/trivia")
        let downloadTask = session.downloadTaskWithURL(baseURL!, completionHandler: { (location, response, error) -> Void in
            if(error == nil){
                let objectData = NSData(contentsOfURL: location!)
                let tmpData :NSString = NSString(data: objectData!, encoding: NSUTF8StringEncoding)!
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in self.factText.text = tmpData as String
                    if (tmpData.length > 130){
                        self.tweetButtonLabel.hidden = true
                    } else {
                        self.tweetButtonLabel.hidden = false
                    }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                })
            } else {
                let alertViewController = UIAlertController(title: "Error", message: "Couldn't connect to network", preferredStyle: .Alert)
                let okButton = UIAlertAction(title: "Got It!", style: .Default, handler: nil)
                let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alertViewController.addAction(okButton)
                alertViewController.addAction(cancelButton)
                self.presentViewController(alertViewController, animated: true, completion: nil)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                })
            }
        })
        downloadTask.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}