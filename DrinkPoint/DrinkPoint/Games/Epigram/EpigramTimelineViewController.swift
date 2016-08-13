//
//  EpigramTimelineViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/28/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit
import TwitterKit
import Crashlytics

class EpigramTimelineViewController: TWTRTimelineViewController {
    
    let epigramSearchQuery = "#drinkpoint AND pic.twitter.com AND (#daring OR #amour OR #outdoors OR #enigma)"
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Answers.logCustomEventWithName("Viewed Epigram Timeline", customAttributes: nil)
        let client = TWTRAPIClient()
        self.dataSource = TWTRSearchTimelineDataSource(searchQuery: self.epigramSearchQuery, APIClient: client)
        let headerHeight: CGFloat = 15
        tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, headerHeight))
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.blackColor()
        title = "Popular Epigrams"
        navigationController?.navigationBar.translucent = true
        let refreshControlOffset = refreshControl?.frame.size.height
        tableView.frame.origin.y += refreshControlOffset!
        refreshControl?.tintColor = UIColor.whiteColor()
        refreshControl?.beginRefreshing()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.translucent = false
        let noTweetsLabel = UILabel()
        noTweetsLabel.text = "Sorry, there are no recent Tweets to display."
        noTweetsLabel.textAlignment = .Center
        noTweetsLabel.textColor = UIColor.whiteColor()
        noTweetsLabel.font = UIFont(name: "SanFranciscoDisplay-Light", size: CGFloat(14))
        tableView.backgroundView = noTweetsLabel
        tableView.backgroundView?.hidden = true
        tableView.backgroundView?.alpha = 0
        toggleNoTweetsLabel()
    }
    
    private func toggleNoTweetsLabel() {
        if tableView.numberOfRowsInSection(0) == 0 {
            UIView.animateWithDuration(0.15) {
                self.tableView.backgroundView!.hidden = false
                self.tableView.backgroundView!.alpha = 1
            }
        } else {
            UIView.animateWithDuration(0.15, animations: {
                self.tableView.backgroundView!.alpha = 0
                }, completion: { finished in self.tableView.backgroundView!.hidden = true
                }
            )
        }
    }
}