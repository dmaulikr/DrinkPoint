//
//  BartenderOnHandViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/5/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit

class OnHandViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var alcoholDataSource = [Item]()
    var mixerDataSource = [Item]()
    
    @IBOutlet weak var alcoholTableView: UITableView!
    @IBOutlet weak var mixerTableView: UITableView!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.navigationController?.navigationBarHidden = false
        SettingsController.firstLaunch()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        splitDataSource()
        self.alcoholTableView.reloadData()
        self.mixerTableView.reloadData()
        if let alertVC = SettingsController.checkOnHand() {
            presentViewController(alertVC, animated: true, completion: nil)
        }
    }
    
    func splitDataSource() {
        alcoholDataSource = []
        mixerDataSource = []
        for item in ItemController.sharedController.onHand {
            if item.alcohol {
                alcoholDataSource.append(item)
            } else {
                mixerDataSource.append(item)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == alcoholTableView{
            return alcoholDataSource.count
        } else {
            return mixerDataSource.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == alcoholTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier("alcoholCell", forIndexPath: indexPath) as! ItemTableViewCell
            let item = alcoholDataSource[indexPath.row]
            cell.setCell(item)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("mixersCell", forIndexPath: indexPath) as! ItemTableViewCell
            let item = mixerDataSource[indexPath.row]
            cell.setCell(item)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == alcoholTableView {
            return "Alcohol"
        } else {
            return "Mixers"
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == alcoholTableView && editingStyle == .Delete {
            let item = self.alcoholDataSource[indexPath.row]
            ItemController.sharedController.removeItem(item)
            self.splitDataSource()
            self.alcoholTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else  if tableView == mixerTableView && editingStyle == .Delete {
            let item = self.mixerDataSource[indexPath.row]
            ItemController.sharedController.removeItem(item)
            self.splitDataSource()
            self.mixerTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}