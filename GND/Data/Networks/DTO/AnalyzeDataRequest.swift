//
//  AnalyzeDataRequest.swift
//  GND
//
//  Created by 235 on 7/2/24.
//

import Foundation
struct AnalyzeDataRequest: Encodable {
    var type: DropRange
    var startDate : String
    var endDate : String
}
