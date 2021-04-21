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
        
        static let homeViewController = "UHomeVC"

        static let CommentViewController = "CommentVC"
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
    
    case airSquat = "سكوات"
    case bicycleCrunch = "بايسكل كرنتش"
    case burpee = "برپي"
    case circleCrunch = "سيركل كرنتش"
    case jumpingJacks = "جمبنق جاكس"
    case pushUp = "بوش اب"
    case crossJumps = "كروس جمبس"
    case crossJumpsRotation = "كروس جمبس روتيشن"
    case situps = "سيت اب"
    case pikeWalk = "بايك ووك"
    case pistol = "بستل"
    case plank = "بلانك"
    case quickSteps = "كويك ستبس"
    
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
    
    var modelDescription: String{
        switch self {
        case .airSquat:
            return "كررها ١٠ مرات"
        case .bicycleCrunch:
            return "كررها ٥ مرات"
        case .burpee:
            return "كررها ٥ مرات"
        case .circleCrunch:
            return "كررها ١٠ مرات"
        case .jumpingJacks:
            return "كررها ١٥ مرة"
        case .pushUp:
            return "كررها ٥ مرات"
        case .crossJumps:
            return "كررها ١٠ مرات"
        case .crossJumpsRotation:
            return "كررها ١٠ مرات"
        case .situps:
            return "كررها ٥ مرات"
        case .pikeWalk:
            return "كررها ٥ مرات"
        case .pistol:
            return "اثبت ١٠ ثواني"
        case .plank:
            return "اثبت ٣٠ ثانية"
        case .quickSteps:
            return "كررها ٥ مرات"
        }
    }
    
}
