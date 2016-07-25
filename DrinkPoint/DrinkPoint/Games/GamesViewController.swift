//
//  GamesViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/10/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit
import mopub_ios_sdk

class GamesViewController: UIViewController, MPAdViewDelegate {

    var adView: MPAdView = MPAdView(adUnitId: "1115a6eee8e4476ab1ceaebf6d55e5bb", size: MOPUB_BANNER_SIZE)
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        
        self.adView.delegate = self
        self.adView.frame = CGRectMake(30, (self.view.bounds.size.height - MOPUB_BANNER_SIZE.height) - 75, MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height)
        self.view.addSubview(self.adView)
        self.adView.loadAd()
    }
    
    func viewControllerForPresentingModalView() -> UIViewController {
        return self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}