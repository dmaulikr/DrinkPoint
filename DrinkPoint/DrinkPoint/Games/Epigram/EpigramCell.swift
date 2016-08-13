//
//  EpigramCellDelegate.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/28/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit

protocol EpigramCellDelegate : class {
    
    func epigramCellWantsToShareEpigram(epigramCell: EpigramCell)
}

class EpigramCell: UITableViewCell {
    
    weak var delegate: EpigramCellDelegate?
    
    @IBOutlet private weak var pictureImageView: UIImageView!
    @IBOutlet private weak var themeLabel: UILabel!
    @IBOutlet private weak var epigramLabel: UILabel!
    @IBOutlet private weak var shareButton: UIButton!
    
    private var gradient: CAGradientLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gradient = CAGradientLayer()
        let colors: [AnyObject] = [UIColor.clearColor().CGColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).CGColor]
        gradient.colors = colors
        gradient.startPoint = CGPointMake(0.0, 0.4)
        gradient.endPoint = CGPointMake(0.0, 1.0)
        pictureImageView.layer.addSublayer(gradient)
        shareButton.addTarget(self, action: #selector(EpigramCell.shareButtonTapped), forControlEvents: .TouchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
    
    func configureWithEpigram(epigram: Epigram) {
        themeLabel.text = "#\(epigram.theme)"
        epigramLabel.text = epigram.getSentence()
        pictureImageView.image = UIImage(named: epigram.picture)
    }
    
    func captureEpigramImage() -> UIImage {
        shareButton.hidden = true
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let containerViewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        shareButton.hidden = false
        return containerViewImage
    }
    
    func shareButtonTapped() {
        delegate?.epigramCellWantsToShareEpigram(self)
    }
}