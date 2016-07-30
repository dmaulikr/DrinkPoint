//
//  ImageCarouselView.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/28/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit

protocol ImageCarouselDataSource: class {
    func numberOfImagesInImageCarousel(imageCarousel: ImageCarouselView) -> Int
    func imageCarousel(imageCarousel: ImageCarouselView, imageAtIndex index: Int) -> UIImage
}

class ImageCarouselView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    weak var delegate: ImageCarouselDataSource?
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    private(set) var currentImageIndex: Int = 0
    private var collectionViewLayout: UICollectionViewFlowLayout!
    private var collectionView: UICollectionView!
    private let CellReuseID = "ImageCarouselCell"
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .Horizontal
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: collectionViewLayout)
        collectionView.pagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerClass(ImageCarouselCollectionViewCell.self, forCellWithReuseIdentifier: CellReuseID)
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
        collectionView.backgroundColor = UIColor.blackColor()
        collectionViewLayout.itemSize = bounds.size
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.numberOfImagesInImageCarousel(self) ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        precondition(delegate != nil, "Delegate should be set by now")
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellReuseID, forIndexPath: indexPath) as! ImageCarouselCollectionViewCell
        cell.image = delegate?.imageCarousel(self, imageAtIndex: indexPath.row)
        return cell
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect))
        let indexPath = collectionView.indexPathForItemAtPoint(visiblePoint)
        currentImageIndex = indexPath!.row
    }
}