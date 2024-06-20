//
//  AnalzyeDateResponse.swift
//  GND
//
//  Created by 235 on 6/20/24.
//

import Foundation
protocol AnalyzeData: Decodable {
    var date: String { get }
}
struct AnalzyeDateResponse<T: AnalyzeData>: Decodable {
    let mine : [T]
    let ageGroup: [T]
    enum CodingKeys: String, CodingKey {
        case mine = "mine"
        case ageGroup = "age_group"
    }
}

struct AnalyzeStrideData: AnalyzeData {
    let minStride: Int
      let maxStride: Int
      let averageStride: Int
      let date: String

      enum CodingKeys: String, CodingKey {
          case minStride = "min_stride"
          case maxStride = "max_stride"
          case averageStride = "average_stride"
          case date
      }
}
struct AnalyzeStepData: AnalyzeData {
    let steps: Int
    let date: String

    enum CodingKeys: String, CodingKey {
        case steps
        case date
    }
}
struct analyzeSpeedData: AnalyzeData{
    let minSpeed: Double
      let maxSpeed: Double
      let averageSpeed: Double
      let date: String

      enum CodingKeys: String, CodingKey {
          case minSpeed = "min_speed"
          case maxSpeed = "max_speed"
          case averageSpeed = "average_speed"
          case date
      }
}
