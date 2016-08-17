//
//  CocktailsRecipeViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/5/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var myRecipe: Recipe?
    
    @IBOutlet weak var textView: UITextView!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.navigationController?.navigationBarHidden = false
        textView.text = myRecipe!.instructions
        self.navigationItem.title = myRecipe!.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRecipe!.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("items", forIndexPath: indexPath)
        let item = myRecipe!.items[indexPath.row]
        let itemAmt = item["volume"]
        let itemName = item["name"]
        let itemObject = Item(name: itemName!)
        if ItemController.sharedController.onHand.contains(itemObject) {
            cell.textLabel?.text = "✔︎ \(itemAmt!)\(itemName!)"
            cell.textLabel?.textColor = .whiteColor()
        } else {
            cell.textLabel?.text = "✘ \(itemAmt!)\(itemName!)"
            cell.textLabel?.textColor = .lightGrayColor()
        }
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Items"
    }
}
