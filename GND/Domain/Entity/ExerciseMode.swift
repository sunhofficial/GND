//
//  ExerciseMode.swift
//  GND
//
//  Created by 235 on 5/14/24.
//

import UIKit

enum ExerciseMode: String, CaseIterable {
    case normal = "운동하기"
       case justMode = "산책하기"
       case speedMode = "속도훈련"
       case strideMode = "보폭훈련"
       case none = "X"
    var buttonColor: UIColor {
        switch self {
        case .none:
            UIColor.red
        case .normal:
            CustomColors.brown
        default:
            UIColor.systemGray
        }
    }
}
