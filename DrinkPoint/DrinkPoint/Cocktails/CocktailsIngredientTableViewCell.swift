//
//  CocktailsIngredientTableViewCell.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/5/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var imageViewOutlet: UIImageView!
    
    func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(ingredient: Ingredient){
        self.nameOutlet.text = ingredient.name
        self.nameOutlet.textColor = .whiteColor()
        
        switch ingredient.category {
            
        case "mixer":
            self.imageViewOutlet.image = UIImage(named: "CocktailsMixer")
            self.imageViewOutlet.image = imageViewOutlet.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.imageViewOutlet.tintColor = .whiteColor()
            
        case "hardDrink":
            self.imageViewOutlet.image = UIImage(named: "CocktailsHardDrink")
            self.imageViewOutlet.image = imageViewOutlet.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.imageViewOutlet.tintColor = .whiteColor()
            
        case "softDrink":
            self.imageViewOutlet.image = UIImage(named: "CocktailsSoftDrink")
            self.imageViewOutlet.image = imageViewOutlet.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.imageViewOutlet.tintColor = .whiteColor()
            
        case "produce":
            self.imageViewOutlet.image = UIImage(named: "CocktailsProduce")
            self.imageViewOutlet.image = imageViewOutlet.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.imageViewOutlet.tintColor = .whiteColor()
            
        case "beer":
            self.imageViewOutlet.image = UIImage(named: "CocktailsBeer")
            self.imageViewOutlet.image = imageViewOutlet.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.imageViewOutlet.tintColor = .whiteColor()
            
        case "spice":
            self.imageViewOutlet.image = UIImage(named: "CocktailsSpice")
            self.imageViewOutlet.image = imageViewOutlet.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.imageViewOutlet.tintColor = .whiteColor()
            
        case "ice":
            self.imageViewOutlet.image = UIImage(named: "CocktailsIce")
            self.imageViewOutlet.image = imageViewOutlet.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.imageViewOutlet.tintColor = .whiteColor()
            
        case "wine":
            self.imageViewOutlet.image = UIImage(named: "CocktailsWine")
            self.imageViewOutlet.image = imageViewOutlet.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.imageViewOutlet.tintColor = .whiteColor()
            
        default:
            self.imageViewOutlet.image = UIImage(named: "CocktailsMixer")
            self.imageViewOutlet.image = imageViewOutlet.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.imageViewOutlet.tintColor = .whiteColor()
        }
    }
}