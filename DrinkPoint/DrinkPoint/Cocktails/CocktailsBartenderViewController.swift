//
//  CocktailsBartenderViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/8/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit

class BartenderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var recipeArray: [Recipe] = []
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Cocktails"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("recipeCell", forIndexPath: indexPath)
        let recipe = recipeArray[indexPath.row]
        cell.textLabel?.text = recipe.name
        cell.textLabel?.textColor = UIColor.blackColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let recipe = recipeArray[indexPath.row]
        self.performSegueWithIdentifier("toDetails", sender: recipe)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDetails" {
            let detailsViewController = segue.destinationViewController as! RecipeViewController
            let recipe = sender as! Recipe
            detailsViewController.myRecipe = recipe
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}