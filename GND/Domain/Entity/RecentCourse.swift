//
//  RecentCourse.swift
//  GND
//
//  Created by 235 on 5/30/24.
//

import Foundation
struct RecentCourse {
    let courseId: Int
    let distance: Int
    let time: Int
    let course: [Coordinate]
    let courseName: String?
}
struct PagenaitedRecentCourse {
    let courses: [RecentCourse]
    let hasNext: Bool
    let nextcourseId: Int
}
