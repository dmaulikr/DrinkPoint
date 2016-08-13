//
//  CocktailsAddIngredientViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/5/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit

class AddIngredientViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var allIngredients = [Ingredient]()
    var ingredientDataSource = [Ingredient]()
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        let unsortedIngredients: [Ingredient] = JSONController.queryIngredients()
        let sorted: [Ingredient] = unsortedIngredients.sort({ $0.category > $1.category })
        self.allIngredients = sorted
        self.ingredientDataSource = self.allIngredients
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ingredientCell", forIndexPath: indexPath) as! AddIngredientTableViewCell
        cell.nameLabel?.text = ingredientDataSource[indexPath.row].name
        if IngredientController.sharedController.myPantry.contains(ingredientDataSource[indexPath.row]) {
            cell.checkLabel?.text = "✔︎"
        } else {
            cell.checkLabel?.text = "☐"
        }
        cell.nameLabel?.textColor = .whiteColor()
        cell.checkLabel?.textColor = .whiteColor()
        cell.setCell(ingredientDataSource[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("ingredientCell", forIndexPath: indexPath) as! AddIngredientTableViewCell
        if IngredientController.sharedController.myPantry.contains(ingredientDataSource[indexPath.row]) {
            cell.checkLabel?.text = "☐"
            let ingredient = ingredientDataSource[indexPath.row]
            IngredientController.sharedController.removeIngredient(ingredient)
            tableViewOutlet.reloadData()
        } else {
            cell.checkLabel?.text = "✔︎"
            let ingredient = ingredientDataSource[indexPath.row]
            IngredientController.sharedController.addIngredient(ingredient)
            tableViewOutlet.reloadData()
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        ingredientDataSource = allIngredients.filter({$0.name.uppercaseString.containsString(searchText.uppercaseString)})
        self.tableViewOutlet.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        searchBarOutlet.resignFirstResponder()
    }
}