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
    func startPedometer() 
      func stopActivity()
    var trackingPublisher: AnyPublisher<ExerciseTracking, Error> {get}
    var exerciseDataPublisher: AnyPublisher<ExerciseData, Never> {get}
}
class CoreMotionService:  CoreMotionServiceProtocol {

    private let pedometer = CMPedometer()
    private let activityManager = CMMotionActivityManager()
    private var pastTime: Date?
    private var timer: AnyCancellable?
    private let trackingSubject = PassthroughSubject<ExerciseTracking, Error>()
    private let exerciseDatas = PassthroughSubject<ExerciseData, Never>()
    var exerciseDataPublisher: AnyPublisher<ExerciseData, Never> {
           exerciseDatas.eraseToAnyPublisher()
       }
    private var counter = 0
    var speedDatas = [Double]()
    var strideDatas = [Double]()
    var distanceDatas = [Double]()
    var walkCountDatas = [Int]()
    var trackingPublisher: AnyPublisher<ExerciseTracking, Error> {
        trackingSubject.eraseToAnyPublisher()
    }
    func startPedometer()  {
        pastTime = Date()
        activityManager.startActivityUpdates(to: .main) { [weak self] activity in
            guard let self = self else {return}
            guard let activity = activity else {return}
            if activity.stationary {
                
            } else {
                self.startStepping()
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
                trackingSubject.send(completion: .failure((NSError(domain: "CoreMotionService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Past time is nil"]))))
                return
            }

            do {
                let data = try await pedometer.queryPedometerDataAsync(from: pastTime, to: nowDate)
                let distance = data.distance?.doubleValue ?? 0.0
                let speed = data.averageActivePace?.doubleValue ?? 0.0
                let steps = data.numberOfSteps.intValue

                self.pastTime = nowDate
                if self.counter % 6 == 0 {
                    speedDatas.append(speed)
                    strideDatas.append(distance / Double(steps))
                    distanceDatas.append(distance)
                    walkCountDatas.append(steps)
                    self.counter = 0
                }
                DispatchQueue.main.async {
                    self.trackingSubject.send(ExerciseTracking(walkingSpeed: speed, walkingDistance: distance, walkingCount: steps))
                }
            } catch {
                DispatchQueue.main.async {
                              self.trackingSubject.send(completion: .failure(error))
                      }
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
