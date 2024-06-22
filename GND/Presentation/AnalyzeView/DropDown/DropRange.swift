//
//  DropRange.swift
//  GND
//
//  Created by 235 on 6/20/24.
//

import Foundation
enum DropRange: String, CaseIterable, Codable {
    case hour
    case day
    case week
    case month
    var koreanString: String {
        switch self {
        case .hour:
            "시간"
        case .day:
            "일"
        case .week:
            "주"
        case .month:
            "월"
        }
    }
}
