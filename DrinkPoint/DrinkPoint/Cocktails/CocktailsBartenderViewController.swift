//
//  CocktailsBartenderViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/8/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit

class BartenderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var recipeDataSource: [Recipe] = []
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        populateDataSource()
    }
    
    
    func populateDataSource() {
        var newRecipes = RecipeController.sharedInstance.possibleRecipes
        newRecipes.sortInPlace({($0.totalIngredients! - $0.userIngredients!) < ($1.totalIngredients! - $1.userIngredients!)})
        recipeDataSource = newRecipes
    }
    
    //    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    //        return 1
    //    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Cocktails"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("recipeCell", forIndexPath: indexPath)
        let recipe = recipeDataSource[indexPath.row]
        cell.textLabel?.text = recipe.name
        cell.textLabel?.textColor = .blackColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let recipe = recipeDataSource[indexPath.row]
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