//
//  CocktailsRecipeDirectionsViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/5/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit

class RecipeDirectionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var myRecipe: Recipe?
    
    @IBOutlet weak var textView: UITextView!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        textView.text = myRecipe!.instructions
        self.navigationItem.title = myRecipe!.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRecipe!.ingredients.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ingredients", forIndexPath: indexPath)
        let ingredient = myRecipe!.ingredients[indexPath.row]
        let ingredientAmt = ingredient["volume"]
        let ingredientName = ingredient["name"]
        let ingredientObj = Ingredient(name: ingredientName!)
        if IngredientController.sharedController.myPantry.contains(ingredientObj){
            cell.textLabel?.text = "✔︎ \(ingredientAmt!)\(ingredientName!)"
            cell.textLabel?.textColor = .lightColor()
        } else {
            cell.textLabel?.text = "✘ \(ingredientAmt!)\(ingredientName!)"
            cell.textLabel?.textColor = .lightGrayColor()
        }
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ingredients"
    }
}
