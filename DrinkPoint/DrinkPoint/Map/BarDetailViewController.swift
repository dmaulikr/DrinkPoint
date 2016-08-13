//
//  BarDetailViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 8/2/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit

class BarDetailViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    var venue: Venue? {
        didSet{
            self.configureView()
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func configureView() {
        if let venue = self.venue {
            if let label = self.detailDescriptionLabel {
                label.text = venue.name
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}