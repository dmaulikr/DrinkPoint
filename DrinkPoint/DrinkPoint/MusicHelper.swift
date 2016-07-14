//
//  MusicHelper.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/29/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import AVFoundation

class MusicHelper {
    static let sharedHelper = MusicHelper()

    var audioPlayer: AVAudioPlayer?
    
    func playBackgroundMusic() {
        let backgroundMusic = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("JazzyFrenchy", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL:backgroundMusic)
            audioPlayer?.volume = 0.5
            audioPlayer!.numberOfLoops = 0
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch {
            print("Cannot play the file")
        }
    }
}