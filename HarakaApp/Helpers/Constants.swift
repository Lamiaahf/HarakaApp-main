//
//  Constants.swift
//  HarakaApp
//
//  Created by lamia on 10/02/2021.
//

import Foundation
import UIKit

struct Constants {
    
    struct Storyboard {
        
        static let homeViewController = "HomeVC"
        
    }
    
    
}


struct Model {
    static let path = "model.scnassets/WorkoutModel/"
    static let `extension` = ".dae"
    var name: String?
    
    init(name: String){
        self.name = name
    }
}

struct Animation {
    static let durationForHidingLabel = 2.0
    static let durationForBlurEffect = 0.5
}


enum Workout: String, CaseIterable {
    
    case airSquat = "Air Squat"
    case bicycleCrunch = "Bicycle Crunch"
    case burpee = "Burpee"
    case circleCrunch = "Circle Crunch"
    case jumpingJacks = "Jumping Jacks"
    case pushUp = "Push Up"
    case crossJumps = "Cross Jumps"
    case crossJumpsRotation = "Cross Jumps Rotation"
    case situps = "Situps"
    case pikeWalk = "Pike Walk"
    case pistol = "Pistol"
    case plank = "Plank"
    case quickSteps = "Quick Steps"
    
    var modelName: String {
        switch self {
        case .airSquat:
            return "AirSquat"
        case .bicycleCrunch:
            return "BicycleCrunch"
        case .burpee:
            return "Burpee"
        case .circleCrunch:
            return "CircleCrunch"
        case .jumpingJacks:
            return "JumpingJacks"
        case .pushUp:
            return "PushUp"
        case .crossJumps:
            return "CrossJumps"
        case .crossJumpsRotation:
            return "CrossJumpsRotation"
        case .situps:
            return "Situps"
        case .pikeWalk:
            return "PikeWalk"
        case .pistol:
            return "Pistol"
        case .plank:
            return "Plank"
        case .quickSteps:
            return "QuickSteps"
        }
    }
    
}
