//
//  Userlevel.swift
//  GND
//
//  Created by 235 on 5/27/24.
//

import Foundation
enum UserLevel: Int {
    case low = 1
    case middle = 2
    case high = 3
    case master = 4
    var title: String {
        switch self {
        case .low:
            "초보자"
        case .middle:
            "중급자"
        case .high:
            "상급자"
        case .master:
            "숙련자"
        }
    }
    var colorString: String {
        switch self {
        case .low:
            "lowLevelColor"
        case .middle:
            "midLevelColor"
        case .high:
            "highLevelColor"
        default:
            ""
        }
    }
    var imageString: String {
        switch self {
        case .low:
            "lowLevel"
        case .middle:
            "midLevel"
        case .high:
            "highLevel"
        case .master:
            "masterLevel"
        }
    }
}
