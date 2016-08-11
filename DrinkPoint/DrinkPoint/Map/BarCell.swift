//
//  BarCell.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 8/2/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit

class BarCell: UITableViewCell {
    
    @IBOutlet weak var barTitleLabel: UILabel!
    @IBOutlet weak var barCheckinLabel: UILabel!
    @IBOutlet weak var barCategoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}