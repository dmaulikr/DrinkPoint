//
//  CocktailsAddIngredientTableViewCell.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/5/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit

class AddIngredientTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkLabel: UILabel!
    
    func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .None
    }
    
    func setCell(ingredient: Ingredient) {
        self.nameLabel.text = ingredient.name
        self.nameLabel.textColor = .whiteColor()
        
        switch ingredient.category {
            
        case "mixer":
            self.iconImage.image = UIImage(named: "CocktailsMixer")
            self.iconImage.image = iconImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.iconImage.tintColor = .whiteColor()
            
        case "hardDrink":
            self.iconImage.image = UIImage(named: "CocktailsHardDrink")
            self.iconImage.image = iconImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.iconImage.tintColor = .whiteColor()
            
        case "softDrink":
            self.iconImage.image = UIImage(named: "CocktailsSoftDrink")
            self.iconImage.image = iconImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.iconImage.tintColor = .whiteColor()
            
        case "produce":
            self.iconImage.image = UIImage(named: "CocktailsProduce")
            self.iconImage.image = iconImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.iconImage.tintColor = .whiteColor()
            
        case "beer":
            self.iconImage.image = UIImage(named: "CocktailsBeer")
            self.iconImage.image = iconImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.iconImage.tintColor = .whiteColor()
            
        case "spice":
            self.iconImage.image = UIImage(named: "CocktailsSpice")
            self.iconImage.image = iconImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.iconImage.tintColor = .whiteColor()
            
        case "ice":
            self.iconImage.image = UIImage(named: "CocktailsIce")
            self.iconImage.image = iconImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.iconImage.tintColor = .whiteColor()
            
        case "wine":
            self.iconImage.image = UIImage(named: "CocktailsWine")
            self.iconImage.image = iconImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.iconImage.tintColor = .whiteColor()
            
        default:
            self.iconImage.image = UIImage(named: "CocktailsMixer")
            self.iconImage.image = iconImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.iconImage.tintColor = .whiteColor()
        }
    }
}