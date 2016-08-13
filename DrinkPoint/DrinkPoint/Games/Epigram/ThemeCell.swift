//
//  ThemeCell.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/28/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit

class ThemeCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var pictureImageView: UIImageView!

    private var gradient: CAGradientLayer!

    override func awakeFromNib() {
        gradient = CAGradientLayer()
        let colors: [AnyObject] = [UIColor.clearColor().CGColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).CGColor]
        gradient.colors = colors
        gradient.startPoint = CGPointMake(0.0, 0.4)
        gradient.endPoint = CGPointMake(0.0, 1.0)
        pictureImageView.layer.addSublayer(gradient)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }

    func configureWithTheme(theme: Theme) {
        nameLabel.text = "#\(theme.name)"
        pictureImageView.image = UIImage(named: theme.getRandomPicture()!)
    }
}