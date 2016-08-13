//
//  EpigramHistoryViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/28/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit
import TwitterKit
import Crashlytics
import mopub_ios_sdk

let MoPubAdUnitID = "1115a6eee8e4476ab1ceaebf6d55e5bb"

class EpigramHistoryViewController: UITableViewController, EpigramCellDelegate {

    private let epigramTableCellReuseIdentifier = "EpigramCell"
    var placer: MPTableViewAdPlacer!
    var epigrams: [Epigram] = []

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Answers.logCustomEventWithName("Viewed Epigram History", customAttributes: nil)
        let staticSettings = MPStaticNativeAdRendererSettings()
        staticSettings.renderingViewClass = NativeAdCell.self
        staticSettings.viewSizeHandler = { (maxWidth: CGFloat) -> CGSize in
            return CGSizeMake(maxWidth, maxWidth)
        }
        let staticConfiguration = MPStaticNativeAdRenderer.rendererConfigurationWithRendererSettings(staticSettings)
        let videoSettings = MOPUBNativeVideoAdRendererSettings()
        videoSettings.renderingViewClass = staticSettings.renderingViewClass
        videoSettings.viewSizeHandler = staticSettings.viewSizeHandler
        let videoConfiguration = MOPUBNativeVideoAdRenderer.rendererConfigurationWithRendererSettings(videoSettings)
        placer = MPTableViewAdPlacer(tableView: tableView, viewController: self, rendererConfigurations: [staticConfiguration, videoConfiguration])
        let targeting = MPNativeAdRequestTargeting()
        targeting.desiredAssets = Set([kAdIconImageKey, kAdMainImageKey, kAdCTATextKey, kAdTextKey, kAdTitleKey])
        placer.loadAdsForAdUnitID(MoPubAdUnitID)
        epigrams = EpigramPersistence.sharedInstance.retrieveEpigrams()
        navigationController?.navigationBar.topItem?.title = ""
        if let previousController: AnyObject = navigationController?.viewControllers[1] {
            if previousController.isKindOfClass(EpigramComposerViewController.self) {
                navigationController?.viewControllers.removeAtIndex(1)
            }
        }
        let headerHeight: CGFloat = 15
        tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, headerHeight))
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.translucent = false
        let noEpigramsLabel = UILabel()
        noEpigramsLabel.text = "You haven’t crafted any epigrams yet."
        noEpigramsLabel.textAlignment = .Center
        noEpigramsLabel.textColor = UIColor.whiteColor()
        noEpigramsLabel.font = UIFont(name: "SanFranciscoDisplay-Light", size: CGFloat(14))
        tableView.backgroundView = noEpigramsLabel
        tableView.backgroundView?.hidden = true
        tableView.backgroundView?.alpha = 0
        toggleNoEpigramsLabel()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return epigrams.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.mp_dequeueReusableCellWithIdentifier(epigramTableCellReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
        if let epigramCell = cell as? EpigramCell {
            epigramCell.delegate = self
            let epigram = epigrams[indexPath.row]
            epigramCell.configureWithEpigram(epigram)
        }
        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let epigram = epigrams[indexPath.row]
            epigrams = epigrams.filter( { $0 != epigram })
            tableView.mp_deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            toggleNoEpigramsLabel()
            EpigramPersistence.sharedInstance.overwriteEpigrams(epigrams)
            Answers.logCustomEventWithName("Removed Epigram", customAttributes: nil)
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.frame.size.width * 0.75
    }

    func epigramCellWantsToShareEpigram(epigramCell: EpigramCell) {
        let indexPath = tableView.mp_indexPathForCell(epigramCell)
        let epigram = epigrams[indexPath.row]
        let epigramImage = epigramCell.captureEpigramImage()
        let composer = TWTRComposer()
        composer.setText("Just crafted an epigram! #drinkpoint #\(epigram.theme.lowercaseString)")
        composer.setImage(epigramImage)
        composer.showFromViewController(self) { result in
            if result == .Done {
                Answers.logShareWithMethod("Twitter", contentName: epigram.theme, contentType: "Epigram", contentId: epigram.UUID.description,
                    customAttributes: [
                        "Epigram": epigram.getSentence(),
                        "Theme": epigram.theme,
                        "Length": epigram.words.count,
                        "Picture": epigram.picture
                    ]
                )
            } else if result == .Cancelled {
                Answers.logCustomEventWithName("Canceled Twitter Sharing",
                    customAttributes: [
                        "Epigram": epigram.getSentence(),
                        "Theme": epigram.theme,
                        "Length": epigram.words.count,
                        "Picture": epigram.picture
                    ]
                )
            }
        }
    }

    private func toggleNoEpigramsLabel() {
        if tableView.numberOfRowsInSection(0) == 0 {
            UIView.animateWithDuration(0.15) {
                self.tableView.backgroundView!.hidden = false
                self.tableView.backgroundView!.alpha = 1
            }
        } else {
            UIView.animateWithDuration(0.15,
                animations: {
                    self.tableView.backgroundView!.alpha = 0
                },
                completion: { finished in
                    self.tableView.backgroundView!.hidden = true
                }
            )
        }
    }
}