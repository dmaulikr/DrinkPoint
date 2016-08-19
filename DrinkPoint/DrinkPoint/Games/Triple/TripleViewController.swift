//
//  TripleViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/24/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit
import SpriteKit
import AudioToolbox

class TripleViewController: UIViewController {

    var scene: TripleGameScene!
    var level: Level!
    var currentLevelNum = 1
    var movesLeft = 0
    var score = 0
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameOverPanel: UIImageView!
    @IBOutlet weak var shuffleButton: UIButton!

    @IBAction func shuffleButtonTapped(_: AnyObject) {
        shuffle()
        vibrate()
        decrementMoves()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.PortraitUpsideDown]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        setupLevel(currentLevelNum)
//        MusicHandling.sharedHelper.playBackgroundMusic()
    }

    func setupLevel(levelNum: Int) {
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        scene = TripleGameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        level = Level(filename: "Level_\(levelNum)")
        scene.level = level
        scene.addTiles()
        scene.swipeHandler = handleSwipe
        gameOverPanel.hidden = true
        shuffleButton.hidden = true
        skView.presentScene(scene)
        beginGame()
    }

    func beginGame() {
        movesLeft = level.maximumMoves
        score = 0
        updateLabels()
        level.resetComboMultiplier()
        scene.animateBeginGame() {
            self.shuffleButton.hidden = false
        }
        shuffle()
    }

    func shuffle() {
        scene.removeAllDrinkSprites()
        let newDrinks = level.shuffle()
        scene.addSpritesForDrinks(newDrinks)
    }

    func handleSwipe(swap: Swap) {
        view.userInteractionEnabled = false
        if level.isPossibleSwap(swap) {
            level.performSwap(swap)
            scene.animateSwap(swap, completion: handleMatches)
        } else {
            scene.animateInvalidSwap(swap) {
                self.view.userInteractionEnabled = true
            }
        }
    }

    func beginNextTurn() {
        level.resetComboMultiplier()
        level.detectPossibleSwaps()
        view.userInteractionEnabled = true
        decrementMoves()
    }

    func handleMatches() {
        let chains = level.removeMatches()
        if chains.count == 0 {
            beginNextTurn()
            return
        }
        scene.animateMatchedDrinks(chains) {
            for chain in chains {
                self.score += chain.score
            }
            self.updateLabels()
            let columns = self.level.fillHoles()
            self.scene.animateFallingDrinks(columns) {
                let columns = self.level.topUpDrinks()
                self.scene.animateNewDrinks(columns) {
                    self.handleMatches()
                }
            }
        }
    }

    func updateLabels() {
        targetLabel.text = String(format: "%ld", level.targetScore)
        movesLabel.text = String(format: "%ld", movesLeft)
        scoreLabel.text = String(format: "%ld", score)
    }

    func decrementMoves() {
        movesLeft -= 1
        updateLabels()
        if score >= level.targetScore {
            gameOverPanel.image = UIImage(named: "TripleLevelComplete")
            currentLevelNum = currentLevelNum < NumLevels ? currentLevelNum+1 : 1
            showGameOver()
        } else if movesLeft == 0 {
            gameOverPanel.image = UIImage(named: "TripleGameOver")
            showGameOver()
        }
    }
    
    func vibrate() {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }

    func showGameOver() {
        vibrate()
        gameOverPanel.hidden = false
        shuffleButton.hidden = true
        scene.userInteractionEnabled = false
        scene.animateGameOver() {
            self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideGameOver))
            self.view.addGestureRecognizer(self.tapGestureRecognizer)
        }
    }
    
    func hideGameOver() {
        view.removeGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = nil
        gameOverPanel.hidden = true
        scene.userInteractionEnabled = true
        setupLevel(currentLevelNum)
    }    
}