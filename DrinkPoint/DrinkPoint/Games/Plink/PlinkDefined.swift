//
//  PlinkDefined.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/25/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import Foundation
import CoreGraphics

let DefinedScreenWidth:  CGFloat = 1536
let DefinedScreenHeight: CGFloat = 2048

enum GameSceneChildName: String {
    case FingerName =           "Finger"
    case GlassAName =           "GlassA"
    case GlassBName =           "GlassB"
    case GlassCName =           "GlassC"
    case ScoreName =            "Score"
    case HealthName =           "Health"
    case GameOverLayerName =    "GameOver"
}

enum GameSceneActionKey: String {
    case WalkAction =           "walk"
    case GrowAudioAction =      "grow_audio"
    case GrowAction =           "grow"
    case ScaleAction =          "scale"
}

enum GameSceneEffectAudioName: String {
    case GlassBulletAudioName =     "GlassBullet.wav"
    case GlassHitAudioName =        "GlassHit.wav"
    case FingerBulletAudioName =    "FingerBullet.wav"
    case FingerHitAudioName =       "FingerHit.wav"
}

enum GameSceneZposition: CGFloat {
    case BackgroundZposition =  0
    case FingerZposition =      10
    case GlassAZposition =    20
    case GlassBZposition =    30
    case GlassCZposition =    40
}