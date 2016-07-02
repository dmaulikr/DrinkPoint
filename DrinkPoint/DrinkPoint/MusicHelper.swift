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
        let aSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("JazzyFrenchy", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: aSound)
            audioPlayer?.volume = 0.5
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch {
            print("Cannot play file")
        }
    }
}