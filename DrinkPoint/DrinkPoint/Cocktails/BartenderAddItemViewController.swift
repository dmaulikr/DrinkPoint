//
//  CocktailsAddItemViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/5/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var allItems = [Item]()
    var itemDataSource = [Item]()
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        let unsortedItems: [Item] = JSONController.queryItems()
        let sorted: [Item] = unsortedItems.sort({ $0.category > $1.category })
        self.allItems = sorted
        self.itemDataSource = self.allItems
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! AddItemTableViewCell
        cell.nameLabel?.text = itemDataSource[indexPath.row].name
        if ItemController.sharedController.onHand.contains(itemDataSource[indexPath.row]) {
            cell.checkLabel?.text = "✔︎"
        } else {
            cell.checkLabel?.text = "☐"
        }
        cell.nameLabel?.textColor = .whiteColor()
        cell.checkLabel?.textColor = .whiteColor()
        cell.setCell(itemDataSource[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! AddItemTableViewCell
        if ItemController.sharedController.onHand.contains(itemDataSource[indexPath.row]) {
            cell.checkLabel?.text = "☐"
            let item = itemDataSource[indexPath.row]
            ItemController.sharedController.removeItem(item)
            tableViewOutlet.reloadData()
        } else {
            cell.checkLabel?.text = "✔︎"
            let item = itemDataSource[indexPath.row]
            ItemController.sharedController.addItem(item)
            tableViewOutlet.reloadData()
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        itemDataSource = allItems.filter({$0.name.uppercaseString.containsString(searchText.uppercaseString)})
        self.tableViewOutlet.reloadData()
    }
    
    func searchBarSearchButtonTapped(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        searchBarOutlet.resignFirstResponder()
    }
}