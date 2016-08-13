//
//  EpigramComposerViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/28/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit
import QuartzCore
import Crashlytics

class EpigramComposerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ImageCarouselDataSource, CountdownViewDelegate {
    
    var theme: Theme! {
        didSet {
            themePictures = theme.pictures.sort { (_, _) in arc4random() < arc4random() }
        }
    }
    
    private var epigram: Epigram
    private var themePictures: [String] = []
    private var bankWords: [String] = []
    private let countdownView: CountdownView
    private let wordCount = 20
    private let timeoutSeconds = 60
    
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    @IBOutlet private weak var shuffleButton: UIButton!
    @IBOutlet private weak var bankCollectionView: UICollectionView!
    @IBOutlet private weak var epigramCollectionView: UICollectionView!
    @IBOutlet private weak var epigramHeightContraint: NSLayoutConstraint!
    @IBOutlet private weak var imageCarousel: ImageCarouselView!
    
    @IBAction func shuffleWordBank() {
        refreshWordBank()
        bankCollectionView.reloadData()
        Answers.logCustomEventWithName("Shuffled Words", customAttributes: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        countdownView = CountdownView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), countdownTime: timeoutSeconds)
        epigram = Epigram()
        super.init(coder: aDecoder)
        countdownView.delegate = self
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bankCollectionView.clipsToBounds = false
        refreshWordBank()
        navigationItem.rightBarButtonItem?.enabled = false
        navigationController?.navigationBar.translucent = true
        countdownView.frame.origin.x = (view.frame.size.width - countdownView.frame.size.width) / 2
        countdownView.frame.origin.y = -countdownView.frame.size.height - 10
        navigationController?.view.addSubview(countdownView)
        navigationController?.view.bringSubviewToFront(countdownView)
        countdownView.countdownTime = timeoutSeconds
        imageCarousel.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.translucent = true
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .CurveEaseInOut,
                                   animations: {
                                    self.countdownView.frame.origin.y = 10
            },
                                   completion: { finished in
                                    self.countdownView.start()
            }
        )
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !(navigationController?.viewControllers)!.contains(self) {
            Answers.logCustomEventWithName("Stopped Composing Epigram",
                                           customAttributes: [
                                            "Epigram": epigram.getSentence(),
                                            "Theme": theme.name,
                                            "Length": epigram.words.count,
                                            "Picture": themePictures[imageCarousel.currentImageIndex]
                ]
            )
        }
        countdownView.stop()
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .CurveEaseInOut,
                                   animations: {
                                    self.countdownView.frame.origin.y = -self.countdownView.frame.size.height - 10
            },
                                   completion: nil
        )
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "ShowHistory" {
            return epigram.words.count > 0
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        saveEpigram()
        CLSLogv("Finished Epigram: %d words in theme %@ with picture %@.", getVaList([epigram.words.count, epigram.theme, epigram.picture]))
        Answers.logCustomEventWithName("Finished Composing Epigram",
                                       customAttributes: [
                                        "Epigram": epigram.getSentence(),
                                        "Theme": epigram.theme,
                                        "Length": epigram.words.count,
                                        "Picture": epigram.picture
            ]
        )
    }
    
    func countdownView(countdownView: CountdownView, didCountdownTo second: Int) {
        switch(second) {
        case 0:
            if epigram.words.count > 0 {
                performSegueWithIdentifier("ShowHistory", sender: countdownView)
            } else {
                navigationController?.popViewControllerAnimated(true)
            }
        case 10:
            shuffleButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        default:
            break
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bankCollectionView {
            return bankWords.count
        } else if collectionView == epigramCollectionView {
            return epigram.words.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("EpigramComposerWordCell", forIndexPath: indexPath) as! EpigramComposerWordCell
        cell.contentView.frame = cell.bounds
        cell.contentView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        var word = ""
        if collectionView == bankCollectionView {
            word = bankWords[indexPath.row]
        } else if collectionView == epigramCollectionView {
            word = epigram.words[indexPath.row]
        }
        cell.word.text = word
        cell.word.frame = cell.bounds
        cell.layer.masksToBounds = false
        cell.layer.borderColor = cell.word.textColor.CGColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 3
        if collectionView == epigramCollectionView {
            cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        }
        cell.hidden = false
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == bankCollectionView {
            if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
                UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .CurveEaseInOut,
                                           animations: {
                                            cell.alpha = 0
                    },
                                           completion: { finished in
                                            cell.hidden = true
                    }
                )
            }
            let word = bankWords[indexPath.row]
            epigram.words.append(word)
            displayWord(word, inCollectionView: epigramCollectionView)
        } else if collectionView == epigramCollectionView {
            if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
                UIView.animateWithDuration(0.15,
                                           animations: {
                                            cell.alpha = 0
                    },
                                           completion: { finished in
                                            collectionView.performBatchUpdates({
                                                collectionView.deleteItemsAtIndexPaths([indexPath])
                                                },
                                                completion: { _ in
                                                    self.resizeEpigramToFitContentSize()
                                                    cell.alpha = 1
                                                }
                                            )
                    }
                )
            }
            let word = epigram.words[indexPath.row]
            displayWord(word, inCollectionView: bankCollectionView)
            epigram.words.removeAtIndex(indexPath.row)
        }
        navigationItem.rightBarButtonItem?.enabled = epigram.words.count > 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var word = ""
        if collectionView == bankCollectionView {
            word = bankWords[indexPath.row]
        } else if collectionView == epigramCollectionView {
            word = epigram.words[indexPath.row]
        }
        return sizeForWord(word)
    }
    
    func sizeForWord(word: String) -> CGSize {
        return CGSize(width: 18 + word.characters.count * 10, height: 32)
    }
    
    func resizeEpigramToFitContentSize() {
        UIView.animateWithDuration(0.15) {
            self.epigramHeightContraint.constant = self.epigramCollectionView.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    func saveEpigram() {
        epigram.date = NSDate()
        epigram.theme = theme.name
        epigram.picture = themePictures[imageCarousel.currentImageIndex]
        EpigramPersistence.sharedInstance.persistEpigram(epigram)
    }
    
    func refreshWordBank() {
        bankWords = theme.getRandomWords(wordCount - epigram.words.count) as [String]
    }
    
    func displayWord(word: String, inCollectionView collectionView: UICollectionView!) {
        if collectionView == bankCollectionView {
            for (index, bankWord) in bankWords.enumerate() {
                if word == bankWord {
                    if let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) {
                        if cell.hidden {
                            cell.hidden = false
                            UIView.animateWithDuration(0.15) {
                                cell.alpha = 1
                            }
                            return
                        }
                    }
                }
            }
            bankWords.append(word)
            let bankIndexPath = NSIndexPath(forItem: bankWords.count - 1, inSection: 0)
            collectionView.insertItemsAtIndexPaths([bankIndexPath])
        } else if collectionView == epigramCollectionView {
            let epigramIndexPath = NSIndexPath(forItem: epigram.words.count - 1, inSection: 0)
            collectionView.performBatchUpdates({
                collectionView.insertItemsAtIndexPaths([epigramIndexPath])
                },
                                               completion: { _ in self.resizeEpigramToFitContentSize()
                }
            )
            if let cell = collectionView.cellForItemAtIndexPath(epigramIndexPath) {
                cell.alpha = 0
                UIView.animateWithDuration(0.15) {
                    cell.alpha = 1
                }
            }
        }
    }
    
    func numberOfImagesInImageCarousel(imageCarousel: ImageCarouselView) -> Int {
        return themePictures.count
    }
    
    func imageCarousel(imageCarousel: ImageCarouselView, imageAtIndex index: Int) -> UIImage {
        return UIImage(named: themePictures[index])!
    }
}