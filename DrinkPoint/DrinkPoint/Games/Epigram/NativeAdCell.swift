//
//  NativeAdCell.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/28/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit
import mopub_ios_sdk

class NativeAdCell: UIView, MPNativeAdRendering {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var callToActionButton: UIButton!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var privacyInformationIconImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        callToActionButton.layer.masksToBounds = false
        callToActionButton.layer.borderColor = callToActionButton.titleLabel?.textColor.CGColor
        callToActionButton.layer.borderWidth = 2
        callToActionButton.layer.cornerRadius = 6
        containerView.layer.cornerRadius = 6
        backgroundColor = UIColor.blackColor()
    }
    
    func nativeMainTextLabel() -> UILabel! {
        return self.mainTextLabel
    }
    
    func nativeTitleTextLabel() -> UILabel! {
        return self.titleLabel
    }
    
    func nativeCallToActionTextLabel() -> UILabel! {
        return self.callToActionButton.titleLabel
    }
    
    func nativeIconImageView() -> UIImageView! {
        return self.iconImageView
    }
    
    func nativeMainImageView() -> UIImageView! {
        return self.mainImageView
    }
    
    func nativeVideoView() -> UIView! {
        return self.videoView
    }
    
    func nativePrivacyInformationIconImageView() -> UIImageView! {
        return self.privacyInformationIconImageView
    }
    
    class func nibForAd() -> UINib! {
        return UINib(nibName: "NativeAdCell", bundle: nil)
    }
}