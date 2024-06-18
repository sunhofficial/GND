//
//  UserGoal.swift
//  GND
//
//  Created by 235 on 5/21/24.
//

import Foundation
struct TodayGoalResponse: Decodable {
    let tier: Int
    let exp: Int
    let stride: TodayStaticData<Int>
    let speed: TodayStaticData<Double>
    let step: TodayStaticData<Int>
    let todayTierUp: Bool
    enum CodingKeys: String, CodingKey {
        case tier, exp, stride, speed, step
        case todayTierUp = "today_tier_up"
    }
    func toDomain() -> UserGoal {
        return .init(level: tier, exp: exp, todayStride: stride.todaycurrent, goalStride: stride.todayGoal, todaySpeed: speed.todaycurrent, goalSpeed: speed.todayGoal, todayStep: step.todaycurrent, goalStep: step.todayGoal,levelup: todayTierUp)
    }
}

struct TodayStaticData<T: Decodable>: Decodable {
    let todaycurrent: T
    let todayGoal: T
    enum CodingKeys: String, CodingKey {
        case todaycurrent = "today_current"
        case todayGoal = "today_goal"
    }
}
