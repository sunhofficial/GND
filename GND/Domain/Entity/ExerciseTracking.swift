//
//  ExerciseTracking.swift
//  GND
//
//  Created by 235 on 5/16/24.
//

import Foundation
struct ExerciseTracking {
    var walkingSpeed: Double
    var walkingDistance: Int
    var walkingCount: Int
}
struct ExerciseData {
    let speedDatas: [Double]
    let strideDatas: [Int]
    let distanceDatas: [Int]
    let walkCountDatas: [Int]
    var averageSpeed: Double {

        return speedDatas.count == 0 ? 0 : speedDatas.reduce(0) {$0 + $1}  / Double(speedDatas.count)
    }
    var averageStride: Int {

        return strideDatas.count == 0 ? 0 : strideDatas.reduce(0) {$0 + $1} / strideDatas.count
    }
    var totalDistance: Int {
        return distanceDatas.reduce(0) {$0 + $1}
    }
    var totalWalkCount: Int {
        return walkCountDatas.reduce(0) { $0 + $1}
    }
}
