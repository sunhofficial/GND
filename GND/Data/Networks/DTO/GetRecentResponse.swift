//
//  GetRecentResponse.swift
//  GND
//
//  Created by 235 on 5/30/24.
//

import Foundation
struct GetRecentResponse: Decodable {
    let results: [Course]
      let hasNext: Bool
      let nextCourseID: Int

      enum CodingKeys: String, CodingKey {
          case results
          case hasNext = "has_next"
          case nextCourseID = "next_course_id"
      }
}
struct Course: Decodable {
    let courseID: Int
    let doShare: Bool
    let courseName: String
    let distance: Int
    let time: Int
    let course: [Coordinate]

    enum CodingKeys: String, CodingKey {
        case courseID = "course_id"
        case doShare = "do_share"
        case courseName = "course_name"
        case distance
        case time
        case course
    }
}
