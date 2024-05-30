//
//  Exercise.swift
//  GND
//
//  Created by 235 on 5/15/24.
//

import Foundation
struct ExerciseSession {
    var startTime: String
    var endTime: String
    var course: [Coordinate]
    var doShareCourse: Bool
    var courseName: String?
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
    var datacount: Int
}
