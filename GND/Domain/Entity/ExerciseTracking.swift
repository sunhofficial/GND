//
//  ExerciseTracking.swift
//  GND
//
//  Created by 235 on 5/16/24.
//

import Foundation
struct ExerciseTracking {
    var walkingSpeed: Double
    var walkingDistance: Double
    var walkingCount: Int
}
struct ExerciseData {
    let speedDatas: [Double]
    let strideDatas: [Double]
    let distanceDatas: [Double]
    let walkCountDatas: [Int]
    var averageSpeed: Double {
        return speedDatas.reduce(0) {$0 + $1}  / Double(speedDatas.count)
    }
    var averageStride: Double {
        return strideDatas.reduce(0) {$0 + $1} / Double(strideDatas.count)
    }
    var totalDistance: Double {
        return distanceDatas.reduce(0) {$0 + $1}
    }
    var totalWalkCount: Int {
        return walkCountDatas.reduce(0) { $0 + $1}
    }
}
