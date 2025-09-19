//
//  PLPulseModel.swift
//  Pulse
//
//  Created by admin on 2025/9/16.
//

import UIKit

struct PLPulseModel: Codable, Equatable {
    var id = UUID().uuidString
    var systolic: Int = 103 // 收缩呀
    var diastolic: Int = 72  // 舒张压
    var pulse: Int = 67 // 心率
    var scene: BPScene = .standard
    var createDate: Date = Date()
    
    var status: BPStatus {
        if systolic < 90 || diastolic < 60 {
            return .hyp
        }
        if 90..<120 ~= systolic, 60..<80 ~= diastolic {
            return .normal
        }
        if 120..<130 ~= systolic,  60..<80 ~= diastolic {
            return .elevated
        }
        
        if 130..<140 ~= systolic || 80..<90 ~= diastolic {
            return .hy1
        }
        if 140...180 ~= systolic || 90...120 ~= diastolic {
            return .hy2
        }
        if systolic > 180 || diastolic > 120 {
            return .hyp3
        }
        return .normal
    }
}

enum BPScene: CaseIterable, Codable, Equatable {
    case night, meal, seated, workout, standard, rest
    var title: String {
        switch self {
        case .night:
            return "Nighttime"
        case .meal:
            return "Post-Meal"
        case .seated:
            return "Seated"
        case .workout:
            return "Post-Workout"
        case .standard:
            return "Standard"
        case .rest:
            return "Rest"
        }
    }
    init(_ item: String?) {
        switch item {
        case BPScene.night.title:
            self = .night
        case BPScene.meal.title:
            self = .meal
        case BPScene.seated.title:
            self = .seated
        case BPScene.workout.title:
            self = .workout
        case BPScene.standard.title:
            self = .standard
        case BPScene.rest.title:
            self = .rest
        default:
            self = .night
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .night:
            return UIImage(named: "scene_night")
        case .meal:
            return UIImage(named: "scene_meal")
        case .seated:
            return UIImage(named: "scene_seated")
        case .workout:
            return UIImage(named: "scene_workout")
        case .standard:
            return UIImage(named: "scene_standard")
        case .rest:
            return UIImage(named: "scene_rest")
        }
    }
}

enum BPStatus: String,  Codable, CaseIterable {
    case hyp, normal, elevated, hy1, hy2, hyp3
    var title: String {
        switch self {
        case .hyp:
            return "Hypotension"
        case .normal:
            return "Normal"
        case .elevated:
            return "Elevated"
        case .hy1:
            return "Hypertension·Stage 1"
        case .hy2:
            return "Hypertension·Stage 2"
        case .hyp3:
            return "Hypertension·Stage 3"
        }
    }
    
    var reason: String {
        switch self {
        case .hyp:
            return "SYS: 30～89, or DIA 30～59"
        case .normal:
            return "SYS: 90～119, and DIA 60～79"
        case .elevated:
            return "SYS: 120～129, and DIA 60～79"
        case .hy1:
            return "SYS: 130～139, or DIA 80～89"
        case .hy2:
            return "SYS: 140～180, or DIA 90～120"
        case .hyp3:
            return "SYS: 181～300, or DIA 121～300"
        }
    }
    
    var description: String {
        switch self {
        case .hyp:
            return "For those facing low blood pressure, consulting a healthcare professional is a prudent step."
        case .normal:
            return "Stay dedicated to your well-balanced and healthy living habits."
        case .elevated:
            return "Lower your risk by adopting healthier habits into your daily life."
        case .hy1:
            return "Anticipate and manage elevated BP by considering lifestyle adjustments for a healthier life."
        case .hy2:
            return "For additional advice, it is advisable to consult with a healthcare expert."
        case .hyp3:
            return "Seeking immediate medical care is strongly advised. Your health is our topmost concern."
        }
    }

    
    var bgColor: UIColor {
        switch self {
        case .hyp:
            return .warnning_1_bg
        case  .elevated:
            return .warnning_bg
        case .normal:
            return .normal_bg
        case .hy1, .hy2, .hyp3:
            return .danger_bg
        }
    }
    
    var color: UIColor {
        switch self {
        case .hyp:
            return .warnning_1
        case .elevated:
            return .warnning
        case .normal:
            return .normal
        case .hy1, .hy2, .hyp3:
            return .danger
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .hyp:
            return UIImage(named: "status_hyp")
        case .elevated:
            return UIImage(named: "status_ele")
        case .normal:
            return UIImage(named: "status_normal")
        case .hy1:
            return UIImage(named: "status_hyp1")
        case .hy2:
            return UIImage(named: "status_hyp2")
        case .hyp3:
            return UIImage(named: "status_hyp3")
        }
    }
}
