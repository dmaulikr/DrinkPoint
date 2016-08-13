//
//  PlinkGameOverScene.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/13/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit
import SpriteKit

class PlinkGameOverScene: SKScene {

    var contentCreated = false

    override func didMoveToView(view: SKView) {
        if (!self.contentCreated) {
            self.createContent()
            self.contentCreated = true
        }
    }

    func createContent() {

        let gameOverLabel = SKLabelNode (fontNamed: "SanFranciscoDisplay-Light")
        gameOverLabel.fontSize = 50
        gameOverLabel.fontColor = SKColor.whiteColor()
        gameOverLabel.text = "Game Over!"
        gameOverLabel.position = CGPointMake(self.size.width / 2, 2 / 3 * self.size.height);
        self.addChild(gameOverLabel)

        let tapLabel = SKLabelNode (fontNamed: "SanFranciscoDisplay-Light")
        tapLabel.fontSize = 25
        tapLabel.fontColor = SKColor.whiteColor()
        tapLabel.text = "(tap to play again)"
        tapLabel.position = CGPointMake(self.size.width / 2, gameOverLabel.frame.origin.y - gameOverLabel.frame.size.height);
        self.addChild(tapLabel)

        self.backgroundColor = UIColor(red: 0.651, green: 0.000, blue: 0.102, alpha: 1.00)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)  {
    }

    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)  {
        let gameScene = PlinkScene(size: self.size)
        gameScene.scaleMode = .AspectFill
        self.view?.presentScene(gameScene, transition: SKTransition.doorsCloseHorizontalWithDuration(1))
    }
}