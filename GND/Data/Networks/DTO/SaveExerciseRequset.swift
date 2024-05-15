//
//  SaveExerciseRequest.swift
//  GND
//
//  Created by 235 on 5/15/24.
//

import Foundation

struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double
}

struct SaveExerciseRequest: Codable {
    var minStride: Int
    var maxStride: Int
    var averageStride: Int
    var minSpeed: Double
    var maxSpeed: Double
    var averageSpeed: Double
    var step: Int
    var distance: Int
    var startTime: String
    var endTime: String
    var stability: Double
    var course: [Coordinate]
    var doShareCourse: Bool
    var courseName: String

    enum CodingKeys: String, CodingKey {
        case minStride = "min_stride"
        case maxStride = "max_stride"
        case averageStride = "average_stride"
        case minSpeed = "min_speed"
        case maxSpeed = "max_speed"
        case averageSpeed = "average_speed"
        case step
        case distance
        case startTime = "start_time"
        case endTime = "end_time"
        case stability
        case course
        case doShareCourse = "do_share_course"
        case courseName = "course_name"
    }
    func toDomain() -> Exercise {
         return Exercise(
             minStride: minStride,
             maxStride: maxStride,
             averageStride: averageStride,
             minSpeed: minSpeed,
             maxSpeed: maxSpeed,
             averageSpeed: averageSpeed,
             step: step,
             distance: distance,
             startTime: ISO8601DateFormatter().date(from: startTime) ?? Date(),
             endTime: ISO8601DateFormatter().date(from: endTime) ?? Date(),
             stability: stability,
             course: course.map { Coordinate(latitude: $0.latitude, longitude: $0.longitude) },
             doShareCourse: doShareCourse,
             courseName: courseName
         )
     }
}
