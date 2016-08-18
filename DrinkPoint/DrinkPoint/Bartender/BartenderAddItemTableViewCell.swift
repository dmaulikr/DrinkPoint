//
//  BartenderAddItemTableViewCell.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/5/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit

class AddItemTableViewCell: UITableViewCell {
    
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
    
    func setCell(item: Item) {
        self.nameLabel.text = item.name
        self.nameLabel.textColor = .whiteColor()
        
        switch item.category {
            
        case "mixer":
            self.iconImage.image = UIImage(named: "BartenderMixer")
            self.iconImage.image = iconImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.iconImage.tintColor = .whiteColor()
            
        case "hardDrink":
            self.iconImage.image = UIImage(named: "BartenderHardDrink")
            self.iconImage.image = iconImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.iconImage.tintColor = .whiteColor()
            
        case "softDrink":
            self.iconImage.image = UIImage(named: "BartenderSoftDrink")
            self.iconImage.image = iconImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.iconImage.tintColor = .whiteColor()
            
        case "produce":
            self.iconImage.image = UIImage(named: "BartenderProduce")
            self.iconImage.image = iconImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.iconImage.tintColor = .whiteColor()
            
        case "beer":
            self.iconImage.image = UIImage(named: "BartenderBeer")
            self.iconImage.image = iconImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.iconImage.tintColor = .whiteColor()
            
        case "spice":
            self.iconImage.image = UIImage(named: "BartenderSpice")
            self.iconImage.image = iconImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.iconImage.tintColor = .whiteColor()
            
        case "ice":
            self.iconImage.image = UIImage(named: "BartenderIce")
            self.iconImage.image = iconImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.iconImage.tintColor = .whiteColor()
            
        case "wine":
            self.iconImage.image = UIImage(named: "BartenderWine")
            self.iconImage.image = iconImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.iconImage.tintColor = .whiteColor()
            
        default:
            self.iconImage.image = UIImage(named: "BartenderMixer")
            self.iconImage.image = iconImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.iconImage.tintColor = .whiteColor()
        }
    }
}