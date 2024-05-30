//
//  GetRecentRequest.swift
//  GND
//
//  Created by 235 on 5/30/24.
//

import Foundation
struct GetRecentRequest: Encodable {
     let showcount: Int
     let nextcourseid: Int?
    enum CodingKeys: String, CodingKey {
        case showcount = "show_count"
        case nextcourseid = "next_course_id"
    }
 }
