//
//  BartenderItemTableViewCell.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/5/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
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
    
    func setCell(item: Item){
        self.nameOutlet.text = item.name
        self.nameOutlet.textColor = .whiteColor()
        
        switch item.category {
            
        case "mixer":
            self.imageViewOutlet.image = UIImage(named: "BartenderMixer")
            self.imageViewOutlet.image = imageViewOutlet.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.imageViewOutlet.tintColor = .whiteColor()
            
        case "hardDrink":
            self.imageViewOutlet.image = UIImage(named: "BartenderHardDrink")
            self.imageViewOutlet.image = imageViewOutlet.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.imageViewOutlet.tintColor = .whiteColor()
            
        case "softDrink":
            self.imageViewOutlet.image = UIImage(named: "BartenderSoftDrink")
            self.imageViewOutlet.image = imageViewOutlet.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.imageViewOutlet.tintColor = .whiteColor()
            
        case "produce":
            self.imageViewOutlet.image = UIImage(named: "BartenderProduce")
            self.imageViewOutlet.image = imageViewOutlet.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.imageViewOutlet.tintColor = .whiteColor()
            
        case "beer":
            self.imageViewOutlet.image = UIImage(named: "BartenderBeer")
            self.imageViewOutlet.image = imageViewOutlet.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.imageViewOutlet.tintColor = .whiteColor()
            
        case "spice":
            self.imageViewOutlet.image = UIImage(named: "BartenderSpice")
            self.imageViewOutlet.image = imageViewOutlet.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.imageViewOutlet.tintColor = .whiteColor()
            
        case "ice":
            self.imageViewOutlet.image = UIImage(named: "BartenderIce")
            self.imageViewOutlet.image = imageViewOutlet.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.imageViewOutlet.tintColor = .whiteColor()
            
        case "wine":
            self.imageViewOutlet.image = UIImage(named: "BartenderWine")
            self.imageViewOutlet.image = imageViewOutlet.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.imageViewOutlet.tintColor = .whiteColor()
            
        default:
            self.imageViewOutlet.image = UIImage(named: "BartenderMixer")
            self.imageViewOutlet.image = imageViewOutlet.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.imageViewOutlet.tintColor = .whiteColor()
        }
    }
}