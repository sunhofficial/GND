//
//  MotionPerformance.swift
//  GND
//
//  Created by Claude on Clean Architecture Fix
//

import Foundation

// Domain Layer 전용 - 비즈니스 의미가 담긴 데이터
struct MotionPerformance {
    let speed: Double
    let stride: Int
    let timestamp: Date
    
    // 도메인 로직
    func isSpeedBelowTarget(_ target: Double) -> Bool {
        return speed < target
    }
    
    func isStrideBelowTarget(_ target: Int) -> Bool {
        return stride < target
    }
}