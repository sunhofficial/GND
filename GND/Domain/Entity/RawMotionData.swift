import Foundation

struct RawMotionData {
    let speed: Double
    let stride: Int
    let distance: Int
    let steps: Int
    let timestamp: Date
}

enum ExerciseFeedback {
    case normal
    case lowSpeed(targetSpeed: Double, currentSpeed: Double, difference: Double)
    case lowStride(targetStride: Int, currentStride: Int, difference: Int)
    
    var shouldShowWarning: Bool {
        switch self {
        case .normal:
            return false
        case .lowSpeed, .lowStride:
            return true
        }
    }
    
    var warningCase: WarningCase? {
        switch self {
        case .normal:
            return nil
        case .lowSpeed(_, _, let diff):
            return .lowSpeed(diff: diff)
        case .lowStride(_, _, let diff):
            return .lowStride(diff: diff)
        }
    }
}
