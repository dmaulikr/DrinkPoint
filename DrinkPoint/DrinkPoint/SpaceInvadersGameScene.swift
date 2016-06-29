//
//  SpaceInvadersGameScene.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/13/16.
//  Copyright © 2016 DrinkPoint. All rights reserved.
//

import SpriteKit
import CoreMotion
import AudioToolbox

class SpaceInvadersScene: SKScene, SKPhysicsContactDelegate {

    let kMinInvaderBottomHeight: Float = 32.0
    let gravity: CGFloat = -100.0
    var gameEnding: Bool = false
    var score: Int = 0
    var shipHealth: Float = 1.0
    var contactQueue = [SKPhysicsContact]()
    let kInvaderCategory: UInt32 = 0x1 << 0
    let kShipFiredBulletCategory: UInt32 = 0x1 << 1
    let kShipCategory: UInt32 = 0x1 << 2
    let kSceneEdgeCategory: UInt32 = 0x1 << 3
    let kInvaderFiredBulletCategory: UInt32 = 0x1 << 4

    enum BulletType {
        case ShipFired
        case InvaderFired
    }

    let kShipFiredBulletName = "shipFiredBullet"
    let kInvaderFiredBulletName = "invaderFiredBullet"
    let kBulletSize = CGSize(width:4, height: 8)
    var tapQueue = [Int]()
    let motionManager: CMMotionManager = CMMotionManager()
    var contentCreated = false
    var invaderMovementDirection: InvaderMovementDirection = .Right
    var timeOfLastMove: CFTimeInterval = 0.0
    var timePerMove: CFTimeInterval = 1.0

    enum InvaderMovementDirection {
        case Right
        case Left
        case DownThenRight
        case DownThenLeft
        case None
    }

    enum InvaderType {
        case A
        case B
        case C
        static var size: CGSize {
            return CGSize(width: 24, height: 16)
        }
        static var name: String {
            return "invader"
        }
    }

    let kInvaderGridSpacing = CGSize(width: 12, height: 12)
    let kInvaderRowCount = 6
    let kInvaderColCount = 6
    let kShipSize = CGSize(width: 30, height: 16)
    let kShipName = "ship"
    let kScoreHudName = "scoreHud"
    let kHealthHudName = "healthHud"

    override func didMoveToView(view: SKView) {
        loadBackground()
        if (!self.contentCreated) {
            self.createContent()
            self.contentCreated = true
            motionManager.startAccelerometerUpdates()
        }
        physicsWorld.contactDelegate = self
    }

    func loadBackground() {
        guard let _ = childNodeWithName("background") as! SKSpriteNode? else {
            let backgroundTexture = SKTexture(image: UIImage(named: "background.jpg")!)
            let backgroundNode = SKSpriteNode(texture: backgroundTexture)
            backgroundNode.size = backgroundTexture.size()
            backgroundNode.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
            backgroundNode.zPosition = GameSceneZposition.BackgroundZposition.rawValue
            self.physicsWorld.gravity = CGVectorMake(0, gravity)
            addChild(backgroundNode)
            return
        }
    }

    func createContent() {
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        physicsBody!.categoryBitMask = kSceneEdgeCategory
        setupInvaders()
        setupShip()
        setupHud()
        self.backgroundColor = SKColor.blackColor()
    }

    func loadInvaderTexturesOfType(invaderType: InvaderType) -> [SKTexture] {

        var prefix: String

        switch(invaderType) {

        case .A:
            prefix = "InvaderA"

        case .B:
            prefix = "InvaderB"

        case .C:
            prefix = "InvaderC"
        }
        return [SKTexture(imageNamed: String(format: "%@_00.png", prefix)),
                SKTexture(imageNamed: String(format: "%@_01.png", prefix))]
    }

    func makeInvaderOfType(invaderType: InvaderType) -> SKNode {
        let invaderTextures = loadInvaderTexturesOfType(invaderType)
        let invader = SKSpriteNode(texture: invaderTextures[0])
        invader.name = InvaderType.name
        invader.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(invaderTextures, timePerFrame: timePerMove)))
        invader.physicsBody = SKPhysicsBody(rectangleOfSize: invader.frame.size)
        invader.physicsBody!.dynamic = false
        invader.physicsBody!.categoryBitMask = kInvaderCategory
        invader.physicsBody!.contactTestBitMask = 0x0
        invader.physicsBody!.collisionBitMask = 0x0
        return invader
    }

    func setupInvaders() {

        let baseOrigin = CGPoint(x: size.width / 3, y: size.height / 2)

        for row in 0..<kInvaderRowCount {

            var invaderType: InvaderType

            if row % 3 == 0 {
                invaderType = .A
            } else if row % 3 == 1 {
                invaderType = .B
            } else {
                invaderType = .C
            }

            let invaderPositionY = CGFloat(row) * (InvaderType.size.height * 2) + baseOrigin.y
            var invaderPosition = CGPoint(x: baseOrigin.x, y: invaderPositionY)

            for _ in 1..<kInvaderRowCount {
                // 5
                let invader = makeInvaderOfType(invaderType)
                invader.position = invaderPosition

                addChild(invader)

                invaderPosition = CGPoint(
                    x: invaderPosition.x + InvaderType.size.width + kInvaderGridSpacing.width,
                    y: invaderPositionY
                )
            }
        }
    }

    func setupShip() {
        let ship = makeShip()
        ship.position = CGPoint(x: size.width / 2.0, y: 100 + (kShipSize.height / 2.0))
        addChild(ship)
    }

    func makeShip() -> SKNode {
        let ship = SKSpriteNode(imageNamed: "Ship.png")
        ship.name = kShipName
        ship.physicsBody = SKPhysicsBody(rectangleOfSize: ship.frame.size)
        ship.physicsBody!.dynamic = true
        ship.physicsBody!.affectedByGravity = false
        ship.physicsBody!.mass = 0.02
        ship.physicsBody!.categoryBitMask = kShipCategory
        ship.physicsBody!.contactTestBitMask = 0x0
        ship.physicsBody!.collisionBitMask = kSceneEdgeCategory
        return ship
    }

    func setupHud() {
        let scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        scoreLabel.name = kScoreHudName
        scoreLabel.fontSize = 25
        scoreLabel.fontColor = SKColor.blueColor()
        scoreLabel.text = String(format: "Score: %04u", 0)
        scoreLabel.position = CGPoint(
            x: frame.size.width / 2,
            y: size.height - (60 + scoreLabel.frame.size.height/2)
        )
        addChild(scoreLabel)

        let healthLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        healthLabel.name = kHealthHudName
        healthLabel.fontSize = 25
        healthLabel.fontColor = SKColor.redColor()
        healthLabel.text = String(format: "Health: %.1f%%", shipHealth * 100.0)
        healthLabel.position = CGPoint(
            x: frame.size.width / 2,
            y: size.height - (100 + healthLabel.frame.size.height/2)
        )
        addChild(healthLabel)
    }

    func adjustScoreBy(points: Int) {
        score += points
        if let score = childNodeWithName(kScoreHudName) as? SKLabelNode {
            score.text = String(format: "Score: %04u", self.score)
        }
    }

    func adjustShipHealthBy(healthAdjustment: Float) {
        shipHealth = max(shipHealth + healthAdjustment, 0)
        if let health = childNodeWithName(kHealthHudName) as? SKLabelNode {
            health.text = String(format: "Health: %.1f%%", self.shipHealth * 100)
        }
    }

    func makeBulletOfType(bulletType: BulletType) -> SKNode {
        var bullet: SKNode

        switch bulletType {

        case .ShipFired:
            bullet = SKSpriteNode(color: SKColor.blueColor(), size: kBulletSize)
            bullet.name = kShipFiredBulletName
            bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.frame.size)
            bullet.physicsBody!.dynamic = true
            bullet.physicsBody!.affectedByGravity = false
            bullet.physicsBody!.categoryBitMask = kShipFiredBulletCategory
            bullet.physicsBody!.contactTestBitMask = kInvaderCategory
            bullet.physicsBody!.collisionBitMask = 0x0

        case .InvaderFired:
            bullet = SKSpriteNode(color: SKColor.redColor(), size: kBulletSize)
            bullet.name = kInvaderFiredBulletName
            bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.frame.size)
            bullet.physicsBody!.dynamic = true
            bullet.physicsBody!.affectedByGravity = false
            bullet.physicsBody!.categoryBitMask = kInvaderFiredBulletCategory
            bullet.physicsBody!.contactTestBitMask = kShipCategory
            bullet.physicsBody!.collisionBitMask = 0x0

            break
        }
        return bullet
    }

    override func update(currentTime: CFTimeInterval) {
        if isGameOver() {
            endGame()
        }
        processContactsForUpdate(currentTime)
        processUserMotionForUpdate(currentTime)
        moveInvadersForUpdate(currentTime)
        processUserTapsForUpdate(currentTime)
        fireInvaderBulletsForUpdate(currentTime)
    }

    func moveInvadersForUpdate(currentTime: CFTimeInterval) {
        if (currentTime - timeOfLastMove < timePerMove) {
            return
        }
        determineInvaderMovementDirection()
        enumerateChildNodesWithName(InvaderType.name) {
            node, stop in

            switch self.invaderMovementDirection {

            case .Right:
                node.position = CGPointMake(node.position.x + 10, node.position.y)

            case .Left:
                node.position = CGPointMake(node.position.x - 10, node.position.y)

            case .DownThenLeft, .DownThenRight:
                node.position = CGPointMake(node.position.x, node.position.y - 10)

            case .None:
                break
            }
            self.timeOfLastMove = currentTime
        }
    }

    func adjustInvaderMovementToTimePerMove(newTimerPerMove: CFTimeInterval) {
        if newTimerPerMove <= 0 {
            return
        }
        let ratio: CGFloat = CGFloat(timePerMove / newTimerPerMove)
        timePerMove = newTimerPerMove
        enumerateChildNodesWithName(InvaderType.name) {
            node, stop in
            node.speed = node.speed * ratio
        }
    }

    func processUserMotionForUpdate(currentTime: CFTimeInterval) {
        if let ship = childNodeWithName(kShipName) as? SKSpriteNode {
            if let data = motionManager.accelerometerData {
                if fabs(data.acceleration.x) > 0.2 {
                    ship.physicsBody!.applyForce(CGVectorMake(40.0 * CGFloat(data.acceleration.x), 0))
                }
            }
        }
    }

    func processUserTapsForUpdate(currentTime: CFTimeInterval) {
        for tapCount in tapQueue {
            if tapCount == 1 {
                fireShipBullets()
            }
            tapQueue.removeAtIndex(0)
        }
    }

    func determineInvaderMovementDirection() {
        var proposedMovementDirection: InvaderMovementDirection = invaderMovementDirection

        enumerateChildNodesWithName(InvaderType.name) {
            node, stop in

            switch self.invaderMovementDirection {

            case .Right:
                if (CGRectGetMaxX(node.frame) >= node.scene!.size.width - 1.0) {
                    proposedMovementDirection = .DownThenLeft
                    self.adjustInvaderMovementToTimePerMove(self.timePerMove * 0.8)
                    stop.memory = true
                }

            case .Left:
                if (CGRectGetMinX(node.frame) <= 1.0) {
                    proposedMovementDirection = .DownThenRight
                    self.adjustInvaderMovementToTimePerMove(self.timePerMove * 0.8)
                    stop.memory = true
                }

            case .DownThenLeft:
                proposedMovementDirection = .Left
                stop.memory = true

            case .DownThenRight:
                proposedMovementDirection = .Right
                stop.memory = true

            default:
                break
            }
        }

        if (proposedMovementDirection != invaderMovementDirection) {
            invaderMovementDirection = proposedMovementDirection
        }
    }

    func fireInvaderBulletsForUpdate(currentTime: CFTimeInterval) {
        let existingBullet = childNodeWithName(kInvaderFiredBulletName)

        if existingBullet == nil {
            var allInvaders = Array<SKNode>()
            enumerateChildNodesWithName(InvaderType.name) {
                node, stop in
                allInvaders.append(node)
            }

            if allInvaders.count > 0 {
                let allInvadersIndex = Int(arc4random_uniform(UInt32(allInvaders.count)))
                let invader = allInvaders[allInvadersIndex]
                let bullet = makeBulletOfType(.InvaderFired)
                bullet.position = CGPoint(
                    x: invader.position.x,
                    y: invader.position.y - invader.frame.size.height / 2 + bullet.frame.size.height / 2
                )
                let bulletDestination = CGPoint(x: invader.position.x, y: -(bullet.frame.size.height / 2))
                fireBullet(bullet, toDestination: bulletDestination, withDuration: 2.0, andSoundFileName: "InvaderBullet.wav")
            }
        }
    }

    func fireBullet(bullet: SKNode, toDestination destination: CGPoint, withDuration duration: CFTimeInterval, andSoundFileName soundName: String) {
        let bulletAction = SKAction.sequence([
            SKAction.moveTo(destination, duration: duration),
            SKAction.waitForDuration(3.0 / 60.0), SKAction.removeFromParent()
            ])
        let soundAction = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        bullet.runAction(SKAction.group([bulletAction, soundAction]))
        addChild(bullet)
    }

    func fireShipBullets() {
        let existingBullet = childNodeWithName(kShipFiredBulletName)
        if existingBullet == nil {
            if let ship = childNodeWithName(kShipName) {
                let bullet = makeBulletOfType(.ShipFired)
                bullet.position = CGPoint(
                    x: ship.position.x,
                    y: ship.position.y + ship.frame.size.height - bullet.frame.size.height / 2
                )
                let bulletDestination = CGPoint(
                    x: ship.position.x,
                    y: frame.size.height + bullet.frame.size.height / 2
                )
                fireBullet(bullet, toDestination: bulletDestination, withDuration: 1.0, andSoundFileName: "ShipBullet.wav")
            }
        }
    }

    func processContactsForUpdate(currentTime: CFTimeInterval) {
        for contact in contactQueue {
            handleContact(contact)
            if let index = contactQueue.indexOf(contact) {
                contactQueue.removeAtIndex(index)
            }
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            if (touch.tapCount == 1) {
                tapQueue.append(1)
            }
        }
    }

    func didBeginContact(contact: SKPhysicsContact) {
        contactQueue.append(contact)
    }

    func handleContact(contact: SKPhysicsContact) {
        if contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil {
            return
        }
        let nodeNames = [contact.bodyA.node!.name!, contact.bodyB.node!.name!]
        if nodeNames.contains(kShipName) && nodeNames.contains(kInvaderFiredBulletName) {
            runAction(SKAction.playSoundFileNamed("ShipHit.wav", waitForCompletion: false))
            adjustShipHealthBy(-0.334)
            if shipHealth <= 0.0 {
                contact.bodyA.node!.removeFromParent()
                contact.bodyB.node!.removeFromParent()
            } else {
                if let ship = self.childNodeWithName(kShipName) {
                    ship.alpha = CGFloat(shipHealth)
                    if contact.bodyA.node == ship {
                        contact.bodyB.node!.removeFromParent()
                    } else {
                        contact.bodyA.node!.removeFromParent()
                    }
                }
            }
        } else if nodeNames.contains(InvaderType.name) && nodeNames.contains(kShipFiredBulletName) {
            runAction(SKAction.playSoundFileNamed("InvaderHit.wav", waitForCompletion: false))
            contact.bodyA.node!.removeFromParent()
            contact.bodyB.node!.removeFromParent()
            adjustScoreBy(100)
        }
    }
    
    func vibrate() {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }

    func isGameOver() -> Bool {
        let invader = childNodeWithName(InvaderType.name)
        var invaderTooLow = false
        enumerateChildNodesWithName(InvaderType.name) {
            node, stop in
            if (Float(CGRectGetMinY(node.frame)) <= self.kMinInvaderBottomHeight)   {
                invaderTooLow = true
                stop.memory = true
            }
        }
        let ship = childNodeWithName(kShipName)
        return invader == nil || invaderTooLow || ship == nil
    }
    
    func endGame() {
        if !gameEnding {
            gameEnding = true
            vibrate()
            motionManager.stopAccelerometerUpdates()
            let gameOverScene: SpaceInvadersGameOverScene = SpaceInvadersGameOverScene(size: size)
            view?.presentScene(gameOverScene, transition: SKTransition.doorsOpenHorizontalWithDuration(1.0))
        }
    }
}