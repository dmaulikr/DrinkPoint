//
//  PlinkGameScene.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/13/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import SpriteKit
import CoreMotion
import AudioToolbox

class PlinkScene: SKScene, SKPhysicsContactDelegate {

    let kMinGlassBottomHeight: Float = 115.0
    let gravity: CGFloat = -75.0
    var gameEnding: Bool = false
    var score: Int = 0
    var fingerHealth: Float = 1.0
    var contactQueue = [SKPhysicsContact]()
    let kGlassCategory: UInt32 = 0x1 << 0
    let kFingerFiredBulletCategory: UInt32 = 0x1 << 1
    let kFingerCategory: UInt32 = 0x1 << 2
    let kSceneEdgeCategory: UInt32 = 0x1 << 3
    let kGlassFiredBulletCategory: UInt32 = 0x1 << 4

    enum BulletType {
        case FingerFired
        case GlassFired
    }

    let kFingerFiredBulletName = "fingerFiredBullet"
    let kGlassFiredBulletName = "glassFiredBullet"
    let kBulletSize = CGSize(width: 4, height: 12)
    var tapQueue = [Int]()
    let motionManager: CMMotionManager = CMMotionManager()
    var contentCreated = false
    var glassMovementDirection: GlassMovementDirection = .Right
    var timeOfLastMove: CFTimeInterval = 0.0
    var timePerMove: CFTimeInterval = 1.0

    enum GlassMovementDirection {
        case Right
        case Left
        case DownThenRight
        case DownThenLeft
        case None
    }

    enum GlassType {
        case A
        case B
        case C
        static var size: CGSize {
            return CGSize(width: 24, height: 16)
        }
        static var name: String {
            return "glass"
        }
    }

    let kGlassGridSpacing = CGSize(width: 12, height: 12)
    let kGlassRowCount = 6
    let kGlassColCount = 6
    let kFingerSize = CGSize(width: 30, height: 16)
    let kFingerName = "finger"
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
        setupGlasses()
        setupFinger()
        setupHud()
    }

    func loadGlassTexturesOfType(glassType: GlassType) -> [SKTexture] {
        var prefix: String
        switch(glassType) {
        case .A:
            prefix = "GlassA"
        case .B:
            prefix = "GlassB"
        case .C:
            prefix = "GlassC"
        }
        return [SKTexture(imageNamed: String(format: "%@_00.png", prefix)),
                SKTexture(imageNamed: String(format: "%@_01.png", prefix))]
    }

    func makeGlassOfType(glassType: GlassType) -> SKNode {
        let glassTextures = loadGlassTexturesOfType(glassType)
        let glass = SKSpriteNode(texture: glassTextures[0])
        glass.name = GlassType.name
        glass.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(glassTextures, timePerFrame: timePerMove)))
        glass.physicsBody = SKPhysicsBody(rectangleOfSize: glass.frame.size)
        glass.physicsBody!.dynamic = false
        glass.physicsBody!.categoryBitMask = kGlassCategory
        glass.physicsBody!.contactTestBitMask = 0x0
        glass.physicsBody!.collisionBitMask = 0x0
        return glass
    }

    func setupGlasses() {
        let baseOrigin = CGPoint(x: size.width / 3, y: size.height / 2)
        for row in 0..<kGlassRowCount {
            var glassType: GlassType
            if row % 3 == 0 {
                glassType = .A
            } else if row % 3 == 1 {
                glassType = .B
            } else {
                glassType = .C
            }
            let glassPositionY = CGFloat(row) * (GlassType.size.height * 2) + baseOrigin.y
            var glassPosition = CGPoint(x: baseOrigin.x, y: glassPositionY)
            for _ in 1 ..< kGlassRowCount {
                let glass = makeGlassOfType(glassType)
                glass.position = glassPosition
                addChild(glass)
                glassPosition = CGPoint(
                    x: glassPosition.x + GlassType.size.width + kGlassGridSpacing.width,
                    y: glassPositionY
                )
            }
        }
    }

    func setupFinger() {
        let finger = makeFinger()
        finger.position = CGPoint(x: size.width / 2, y: 75 + (kFingerSize.height / 2))
        addChild(finger)
    }

    func makeFinger() -> SKNode {
        let finger = SKSpriteNode(imageNamed: "Finger.png")
        finger.name = kFingerName
        finger.physicsBody = SKPhysicsBody(rectangleOfSize: finger.frame.size)
        finger.physicsBody!.dynamic = true
        finger.physicsBody!.affectedByGravity = false
        finger.physicsBody!.mass = 0.05
        finger.physicsBody!.categoryBitMask = kFingerCategory
        finger.physicsBody!.contactTestBitMask = 0x0
        finger.physicsBody!.collisionBitMask = kSceneEdgeCategory
        return finger
    }

    func setupHud() {
        let scoreLabel = SKLabelNode (fontNamed: "SanFranciscoDisplay-Light")
        scoreLabel.name = kScoreHudName
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = SKColor.whiteColor()
        scoreLabel.text = String(format: "Score: %0u", 0)
        scoreLabel.position = CGPoint(
            x: frame.size.width / 2,
            y: size.height - (100 + scoreLabel.frame.size.height / 2)
        )
        addChild(scoreLabel)
        let healthLabel = SKLabelNode (fontNamed: "SanFranciscoDisplay-Light")
        healthLabel.name = kHealthHudName
        healthLabel.fontSize = 20
        healthLabel.fontColor = SKColor.whiteColor()
        healthLabel.text = String(format: "Health: %.0f%%", fingerHealth * 100)
        healthLabel.position = CGPoint(
            x: frame.size.width / 2,
            y: size.height - (130 + healthLabel.frame.size.height / 2)
        )
        addChild(healthLabel)
    }

    func adjustScoreBy(points: Int) {
        score += points
        if let score = childNodeWithName(kScoreHudName) as? SKLabelNode {
            score.text = String(format: "Score: %0u", self.score)
        }
    }

    func adjustFingerHealthBy(healthAdjustment: Float) {
        fingerHealth = max(fingerHealth + healthAdjustment, 0.0)
        if let health = childNodeWithName(kHealthHudName) as? SKLabelNode {
            health.text = String(format: "Health: %.0f%%", self.fingerHealth * 100)
        }
    }

    func makeBulletOfType(bulletType: BulletType) -> SKNode {
        var bullet: SKNode
        switch bulletType {
        case .FingerFired:
            bullet = SKSpriteNode(color: SKColor.cyanColor(), size: kBulletSize)
            bullet.name = kFingerFiredBulletName
            bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.frame.size)
            bullet.physicsBody!.dynamic = true
            bullet.physicsBody!.affectedByGravity = false
            bullet.physicsBody!.categoryBitMask = kFingerFiredBulletCategory
            bullet.physicsBody!.contactTestBitMask = kGlassCategory
            bullet.physicsBody!.collisionBitMask = 0x0
        case .GlassFired:
            bullet = SKSpriteNode(color: SKColor.magentaColor(), size: kBulletSize)
            bullet.name = kGlassFiredBulletName
            bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.frame.size)
            bullet.physicsBody!.dynamic = true
            bullet.physicsBody!.affectedByGravity = false
            bullet.physicsBody!.categoryBitMask = kGlassFiredBulletCategory
            bullet.physicsBody!.contactTestBitMask = kFingerCategory
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
        moveGlassesForUpdate(currentTime)
        processUserTapsForUpdate(currentTime)
        fireGlassBulletsForUpdate(currentTime)
    }

    func moveGlassesForUpdate(currentTime: CFTimeInterval) {
        if (currentTime - timeOfLastMove < timePerMove) {
            return
        }
        determineGlassMovementDirection()
        enumerateChildNodesWithName(GlassType.name) {
            node, stop in
            switch self.glassMovementDirection {
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

    func adjustGlassMovementToTimePerMove(newTimerPerMove: CFTimeInterval) {
        if newTimerPerMove <= 0 {
            return
        }
        let ratio: CGFloat = CGFloat(timePerMove / newTimerPerMove)
        timePerMove = newTimerPerMove
        enumerateChildNodesWithName(GlassType.name) {
            node, stop in
            node.speed = node.speed * ratio
        }
    }

    func processUserMotionForUpdate(currentTime: CFTimeInterval) {
        if let finger = childNodeWithName(kFingerName) as? SKSpriteNode {
            if let data = motionManager.accelerometerData {
                if fabs(data.acceleration.x) > 0.2 {
                    finger.physicsBody!.applyForce(CGVectorMake(40 * CGFloat(data.acceleration.x), 0))
                }
            }
        }
    }

    func processUserTapsForUpdate(currentTime: CFTimeInterval) {
        for tapCount in tapQueue {
            if tapCount == 1 {
                fireFingerBullets()
            }
            tapQueue.removeAtIndex(0)
        }
    }

    func determineGlassMovementDirection() {
        var proposedMovementDirection: GlassMovementDirection = glassMovementDirection
        enumerateChildNodesWithName(GlassType.name) {
            node, stop in
            switch self.glassMovementDirection {
            case .Right:
                if (CGRectGetMaxX(node.frame) >= node.scene!.size.width - 1.0) {
                    proposedMovementDirection = .DownThenLeft
                    self.adjustGlassMovementToTimePerMove(self.timePerMove * 0.8)
                    stop.memory = true
                }
            case .Left:
                if (CGRectGetMinX(node.frame) <= 1.0) {
                    proposedMovementDirection = .DownThenRight
                    self.adjustGlassMovementToTimePerMove(self.timePerMove * 0.8)
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
        if (proposedMovementDirection != glassMovementDirection) {
            glassMovementDirection = proposedMovementDirection
        }
    }

    func fireGlassBulletsForUpdate(currentTime: CFTimeInterval) {
        let existingBullet = childNodeWithName(kGlassFiredBulletName)
        if existingBullet == nil {
            var allGlasses = Array<SKNode>()
            enumerateChildNodesWithName(GlassType.name) {
                node, stop in
                allGlasses.append(node)
            }
            if allGlasses.count > 0 {
                let allGlassesIndex = Int(arc4random_uniform(UInt32(allGlasses.count)))
                let glass = allGlasses[allGlassesIndex]
                let bullet = makeBulletOfType(.GlassFired)
                bullet.position = CGPoint(
                    x: glass.position.x,
                    y: glass.position.y - glass.frame.size.height / 2 + bullet.frame.size.height / 2
                )
                let bulletDestination = CGPoint(x: glass.position.x, y: -(bullet.frame.size.height / 2))
                fireBullet(bullet, toDestination: bulletDestination, withDuration: 2, andSoundFileName: "GlassBullet.wav")
            }
        }
    }

    func fireBullet(bullet: SKNode, toDestination destination: CGPoint, withDuration duration: CFTimeInterval, andSoundFileName soundName: String) {
        let bulletAction = SKAction.sequence([
            SKAction.moveTo(destination, duration: duration),
            SKAction.waitForDuration(3/60), SKAction.removeFromParent()
            ])
        let soundAction = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        bullet.runAction(SKAction.group([bulletAction, soundAction]))
        addChild(bullet)
    }

    func fireFingerBullets() {
        let existingBullet = childNodeWithName(kFingerFiredBulletName)
        if existingBullet == nil {
            if let finger = childNodeWithName(kFingerName) {
                let bullet = makeBulletOfType(.FingerFired)
                bullet.position = CGPoint(
                    x: finger.position.x,
                    y: finger.position.y + finger.frame.size.height - bullet.frame.size.height / 2
                )
                let bulletDestination = CGPoint(
                    x: finger.position.x,
                    y: frame.size.height + bullet.frame.size.height / 2
                )
                fireBullet(bullet, toDestination: bulletDestination, withDuration: 1, andSoundFileName: "FingerBullet.wav")
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
        if nodeNames.contains(kFingerName) && nodeNames.contains(kGlassFiredBulletName) {
            runAction(SKAction.playSoundFileNamed("FingerHit.wav", waitForCompletion: false))
            adjustFingerHealthBy(-(1/4))
            vibrate()
            if fingerHealth <= 0 {
                contact.bodyA.node!.removeFromParent()
                contact.bodyB.node!.removeFromParent()
            } else {
                if let finger = self.childNodeWithName(kFingerName) {
                    finger.alpha = CGFloat(fingerHealth)
                    if contact.bodyA.node == finger {
                        contact.bodyB.node!.removeFromParent()
                    } else {
                        contact.bodyA.node!.removeFromParent()
                    }
                }
            }
        } else if nodeNames.contains(GlassType.name) && nodeNames.contains(kFingerFiredBulletName) {
            runAction(SKAction.playSoundFileNamed("GlassHit.wav", waitForCompletion: false))
            contact.bodyA.node!.removeFromParent()
            contact.bodyB.node!.removeFromParent()
            adjustScoreBy(100)
        }
    }
    
    func vibrate() {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }

    func isGameOver() -> Bool {
        let glass = childNodeWithName(GlassType.name)
        var glassTooLow = false
        enumerateChildNodesWithName(GlassType.name) {
            node, stop in
            if (Float(CGRectGetMinY(node.frame)) <= self.kMinGlassBottomHeight)   {
                glassTooLow = true
                stop.memory = true
            }
        }
        let finger = childNodeWithName(kFingerName)
        return glass == nil || glassTooLow || finger == nil
    }
    
    func endGame() {
        if !gameEnding {
            gameEnding = true
            motionManager.stopAccelerometerUpdates()
            let gameOverScene: PlinkGameOverScene = PlinkGameOverScene(size: size)
            view?.presentScene(gameOverScene, transition: SKTransition.flipHorizontalWithDuration(0.5))
        }
    }
}