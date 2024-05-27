//
//  CoreMotionService.swift
//  GND
//
//  Created by 235 on 5/12/24.
//

import Foundation
import CoreMotion
import Combine

protocol CoreMotionServiceProtocol {
    var mode: ExerciseMode {get}
    func startPedometer()
    func stopActivity()
    var warningPublisher: AnyPublisher<WarningCase, Error> { get }
    var exerciseDataPublisher: AnyPublisher<ExerciseData, Never> {get}
    var stepsPublisher: AnyPublisher<Int, Never> {get}
}
class CoreMotionService:  CoreMotionServiceProtocol {
    var mode: ExerciseMode

    private let pedometer = CMPedometer()
    private let activityManager = CMMotionActivityManager()
    private var pastTime: Date?
    private var timer: AnyCancellable?
    private let warningSubject = PassthroughSubject<WarningCase, Error>()
    private let exerciseDatas = PassthroughSubject<ExerciseData, Never>()
    var exerciseDataPublisher: AnyPublisher<ExerciseData, Never> {
        exerciseDatas.eraseToAnyPublisher()
    }
    var stepsPublisher: AnyPublisher<Int, Never> {
        stepsSubject.eraseToAnyPublisher()
    }
    var stepsSubject = PassthroughSubject<Int, Never>()
    private var counter = 0
    private var stationaryCounter = 0
    //        private var warning = false
    var speedDatas = [Double]()
    var strideDatas = [Int]()
    var distanceDatas = [Int]()
    var walkCountDatas = [Int]()
    var warningPublisher: AnyPublisher<WarningCase, Error> {
        warningSubject.eraseToAnyPublisher()
    }
    init(mode: ExerciseMode) {
        self.mode = mode
    }
    func startPedometer()  {
        pastTime = Date()
        activityManager.startActivityUpdates(to: .main) { [weak self] activity in
            guard let self = self else {return}
            guard let activity = activity else {return}
            print(activity)
            if activity.walking || activity.running {
                stationaryCounter = 0
                if timer == nil {
                    self.startStepping()
                }
            } else {
                stationaryCounter += 1
                guard timer != nil else{ return}
                if stationaryCounter >= 4  {
                    timer?.cancel()
                    timer = nil
                }
            }
        }
    }
    func stopActivity() {
        activityManager.stopActivityUpdates()
        pedometer.stopUpdates()
        timer?.cancel()
        timer = nil
        let exerciseData = ExerciseData(speedDatas: speedDatas, strideDatas: strideDatas, distanceDatas: distanceDatas, walkCountDatas: walkCountDatas)
        exerciseDatas.send(exerciseData)
        // 모은 데이터 초기화
        speedDatas.removeAll()
        strideDatas.removeAll()
        distanceDatas.removeAll()
        walkCountDatas.removeAll()
    }
    private func startStepping() {
        self.timer = Timer.publish(every: 20.0, tolerance: 1, on: .main, in: .common)
            .autoconnect()
            .sink {
                [weak self] _ in
                guard let self = self else { return }
                self.counter += 1
                Task {
                    await self.fetchStepData()
                }
            }
    }
    private func fetchStepData() async {
        let nowDate = Date()
        guard let pastTime = pastTime else {
            warningSubject.send(completion: .failure((NSError(domain: "CoreMotionService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Past time is nil"]))))
            return
        }

        do {
            let data = try await pedometer.queryPedometerDataAsync(from: pastTime, to: nowDate)
            guard let distance = data.distance?.intValue, distance != 0, data.numberOfSteps.intValue != 0 else {return }
            let steps = data.numberOfSteps.intValue
            let speed = data.averageActivePace?.doubleValue ?? 0
            var warning = false
            self.pastTime = nowDate
            let stride = distance * 100 / steps
            self.stepsSubject.send(steps)
            if self.counter % 3 == 0 {
                speedDatas.append(speed)
                strideDatas.append(stride)
                distanceDatas.append(distance)
                walkCountDatas.append(steps)
                self.counter = 0
            }
            self.processStepData(stride: stride, speed: speed)
        } catch {
            DispatchQueue.main.async {
                self.warningSubject.send(completion: .failure(error))
            }
        }
    }
    private func processStepData(stride: Int, speed: Double) {
        switch mode {
        case .speedMode:
            let speedGoal = 1.6
            if speed < speedGoal {
                let diff = speedGoal - speed
                DispatchQueue.main.async {
                    self.warningSubject.send(WarningCase.lowSpeed(diff: diff))
                }
            }
        case .strideMode:
            let strideGoal = 100
            if stride < strideGoal {
                let diff = strideGoal - stride
                DispatchQueue.main.async {
                    self.warningSubject.send(WarningCase.lowStride(diff: diff))
                }
            }
        default:
            break

        }

    }
}
extension CMPedometer {
    func queryPedometerDataAsync(from start: Date, to end: Date) async throws -> CMPedometerData {
        return try await withCheckedThrowingContinuation { continuation in
            self.queryPedometerData(from: start, to: end) { data, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data {
                    continuation.resume(returning: data)
                }
            }
        }
    }
}
