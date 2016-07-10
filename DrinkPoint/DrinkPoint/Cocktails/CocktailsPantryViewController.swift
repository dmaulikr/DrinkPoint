//
//  CocktailsPantryViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/5/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit

class PantryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var alcoholDataSource = [Ingredient]()
    var mixerDataSource = [Ingredient]()
    
    @IBOutlet weak var alcoholTableView: UITableView!
    @IBOutlet weak var mixerTableView: UITableView!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        SettingsController.firstLaunch()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        splitDataSource()
        self.alcoholTableView.reloadData()
        self.mixerTableView.reloadData()
        if let alertVC = SettingsController.checkEmptyPantry() {
            presentViewController(alertVC, animated: true, completion: nil)
        }
    }
    
    func splitDataSource() {
        alcoholDataSource = []
        mixerDataSource = []
        for item in IngredientController.sharedController.myPantry {
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
            let cell = tableView.dequeueReusableCellWithIdentifier("alcoholCell", forIndexPath: indexPath) as! IngredientTableViewCell
            let ingredient = alcoholDataSource[indexPath.row]
            cell.setCell(ingredient)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("mixersCell", forIndexPath: indexPath) as! IngredientTableViewCell
            let ingredient = mixerDataSource[indexPath.row]
            cell.setCell(ingredient)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == alcoholTableView {
            return "Alcohol on Hand"
        } else {
            return "Mixers on Hand"
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == alcoholTableView && editingStyle == .Delete {
            let ingredient = self.alcoholDataSource[indexPath.row]
            IngredientController.sharedController.removeIngredient(ingredient)
            self.splitDataSource()
            self.alcoholTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else  if tableView == mixerTableView && editingStyle == .Delete {
            let ingredient = self.mixerDataSource[indexPath.row]
            IngredientController.sharedController.removeIngredient(ingredient)
            self.splitDataSource()
            self.mixerTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}