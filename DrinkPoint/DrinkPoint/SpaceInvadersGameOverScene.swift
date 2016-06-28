//
//  SpaceInvadersGameOverScene.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/13/16.
//  Copyright © 2016 DrinkPoint. All rights reserved.
//

import UIKit
import SpriteKit

class SpaceInvadersGameOverScene: SKScene {

    var contentCreated = false

    override func didMoveToView(view: SKView) {
        if (!self.contentCreated) {
            self.createContent()
            self.contentCreated = true
        }
    }

    func createContent() {

        let gameOverLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        gameOverLabel.fontSize = 50
        gameOverLabel.fontColor = SKColor.blackColor()
        gameOverLabel.text = "Game Over!"
        gameOverLabel.position = CGPointMake(self.size.width / 2, 2/3 * self.size.height);
        self.addChild(gameOverLabel)

        let tapLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        tapLabel.fontSize = 25
        tapLabel.fontColor = SKColor.blackColor()
        tapLabel.text = "(tap to play again)"
        tapLabel.position = CGPointMake(self.size.width / 2, gameOverLabel.frame.origin.y - gameOverLabel.frame.size.height - 40);
        self.addChild(tapLabel)

        self.backgroundColor = SKColor.redColor()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)  {
    }

    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)  {
        let gameScene = SpaceInvadersScene(size: self.size)
        gameScene.scaleMode = .AspectFill
        self.view?.presentScene(gameScene, transition: SKTransition.doorsCloseHorizontalWithDuration(1.0))
    }
}