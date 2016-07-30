//
//  CountdownViewDelegate.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 7/28/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import UIKit
import QuartzCore

protocol CountdownViewDelegate: class {

    func countdownView(countdown: CountdownView, didCountdownTo second: Int)
}

class CountdownView : UIView {

    let secondsLabel: UILabel
    let backgroundCircle: CAShapeLayer
    let foregroundCircle: CAShapeLayer
    weak var delegate: CountdownViewDelegate?
    var countdownTime: Int

    private var secondsRemaining: Double {
        didSet {
            progress = secondsRemaining / Double(countdownTime)
            let wholeSeconds = Int(ceil(secondsRemaining))
            secondsLabel.text = String(wholeSeconds)
            if wholeSeconds <= 10 {
                backgroundCircle.strokeColor = UIColor.redColor().CGColor
                foregroundCircle.strokeColor = UIColor.whiteColor().CGColor
                secondsLabel.textColor = UIColor.redColor()
            }
            if wholeSeconds % 5 == 0 {
                delegate?.countdownView(self, didCountdownTo: Int(wholeSeconds))
            }
        }
    }

    private var displayLink: CADisplayLink?

    func start() {
        secondsRemaining = Double(countdownTime)
        displayLink?.invalidate()
        displayLink = UIScreen.mainScreen().displayLinkWithTarget(self, selector: #selector(CountdownView.tick))
        displayLink!.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
    }

    func stop() {
        displayLink?.invalidate()
    }

    private var progress: Double = 1 {
        didSet {
            foregroundCircle.strokeEnd = (CGFloat) (progress)
        }
    }

    func tick() {
        secondsRemaining -= displayLink!.duration
    }

    let textPadding: CGFloat = 5

    required init(frame aRect: CGRect, countdownTime time: Int) {
        countdownTime = time
        secondsRemaining = Double(countdownTime)
        secondsLabel = UILabel(frame: CGRect(x: textPadding, y: textPadding, width: aRect.size.width - 2 * textPadding, height: aRect.size.height - 2 * textPadding))
        backgroundCircle = CAShapeLayer()
        foregroundCircle = CAShapeLayer()
        super.init(frame: aRect)
        secondsLabel.text = String(countdownTime)
        secondsLabel.font = UIFont(name: "SanFranciscoDisplay-Light", size: 16)
        secondsLabel.textColor = UIColor.whiteColor()
        secondsLabel.textAlignment = NSTextAlignment.Center
        let arcCenter = CGPoint(x: bounds.width / 2, y: bounds.width / 2)
        let radius: CGFloat = bounds.width / 2
        let startAngle = CGFloat(-0.5 * M_PI)
        let endAngle = CGFloat(1.5 * M_PI)
        let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        backgroundCircle.path = path.CGPath
        backgroundCircle.fillColor = UIColor.clearColor().CGColor
        backgroundCircle.strokeColor = UIColor.grayColor().CGColor
        backgroundCircle.strokeStart = 0
        backgroundCircle.strokeEnd = 1
        backgroundCircle.lineWidth = 2
        foregroundCircle.path = path.CGPath
        foregroundCircle.fillColor = UIColor.clearColor().CGColor
        foregroundCircle.strokeColor = UIColor.whiteColor().CGColor
        foregroundCircle.strokeStart = 0
        foregroundCircle.strokeEnd = 1
        foregroundCircle.lineWidth = 2
        layer.addSublayer(backgroundCircle)
        layer.addSublayer(foregroundCircle)
        addSubview(secondsLabel)
    }

    override convenience init(frame aRect: CGRect) {
        self.init(frame: aRect, countdownTime: 0)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("Nibs not supported in this UIView subclass")
    }
}