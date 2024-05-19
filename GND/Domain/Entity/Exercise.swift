//
//  Exercise.swift
//  GND
//
//  Created by 235 on 5/15/24.
//

import Foundation
struct ExerciseSession {

    var startTime: Date
    var endTime: Date
    var course: [Coordinate]
    var doShareCourse: Bool
    var courseName: String

//    func toDTO() -> SaveExerciseRequest {
//           let formatter = ISO8601DateFormatter()
//           return SaveExerciseRequest(
////               minStride: minStride,
////               maxStride: maxStride,
////               averageStride: averageStride,
////               minSpeed: minSpeed,
////               maxSpeed: maxSpeed,
////               averageSpeed: averageSpeed,
////               step: step,
////               distance: distance,
//               startTime: formatter.string(from: startTime),
//               endTime: formatter.string(from: endTime),
////               stability: stability,
//               course: course.map { Coordinate(latitude: $0.latitude, longitude: $0.longitude) },
//               doShareCourse: doShareCourse,
////               courseName: courseName
//           )
//       }
}
struct ExerciseMetrics {
        var minStride: Int
        var maxStride: Int
        var averageStride: Int
        var minSpeed: Double
        var maxSpeed: Double
        var averageSpeed: Double
        var step: Int
        var distance: Int
}
