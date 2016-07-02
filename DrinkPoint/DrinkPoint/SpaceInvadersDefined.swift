//
//  SpaceInvadersDefined.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/25/16.
//  Copyright © 2016 DrinkPoint. All rights reserved.
//

import Foundation
import CoreGraphics

let DefinedScreenWidth:  CGFloat = 1536
let DefinedScreenHeight: CGFloat = 2048

enum GameSceneChildName: String {
    case ShipName =             "Ship"
    case InvaderAName =         "InvaderA"
    case InvaderBName =         "InvaderB"
    case InvaderCName =         "InvaderC"
    case ScoreName =            "score"
    case HealthName =           "health"
    case GameOverLayerName =    "over"
}

enum GameSceneActionKey: String {
    case WalkAction =           "walk"
    case PlankGrowAudioAction = "plank_grow_audio"
    case PlankGrowAction =      "plank_grow"
    case PirateScaleAction =    "pirate_scale"
}

enum GameSceneEffectAudioName: String {
    case InvaderBulletAudioName =   "InvaderBullet.wav"
    case InvaderHitAudioName =      "InvaderHit.wav"
    case ShipBulletAudioName =      "ShipBullet.wav"
    case ShipHitAudioName =         "ShipHit.wav"
}

enum GameSceneZposition: CGFloat {
    case BackgroundZposition =  0
    case ShipZposition =        10
    case InvaderAZposition =    20
    case InvaderBZposition =    30
    case InvaderCZposition =    40
}