//
//  ExerciseUseCase.swift
//  GND
//
//  Created by 235 on 5/14/24.
//

import Foundation
import Combine
import CoreLocation

final class ExerciseUsecase {
    private let coreLocationService: CoreLocationServicesProtocol
    var exerciseRepository: ExerciseRepositoryProtocol
    private let coreMotionService: CoreMotionServiceProtocol
    
    private var exerciseMode: ExerciseMode?
    private var userGoal: UserGoal?
    private let feedbackSubject = PassthroughSubject<WarningCase, Error>()
    private var cancellables = Set<AnyCancellable>()
    var locationPublisher: AnyPublisher<[CLLocationCoordinate2D], Never> {
        coreLocationService.locationPublisher
            .map { locations in
                locations.map { $0.coordinate }
            }
            .eraseToAnyPublisher()
    }
    var feedbackPublisher: AnyPublisher<WarningCase, Error> {
        feedbackSubject.eraseToAnyPublisher()
    }
    var errorPublisher: AnyPublisher<Error, Never> {
        coreLocationService.errorPublisher.eraseToAnyPublisher()
    }
    var exerciseDataPublisher: AnyPublisher<ExerciseData, Never> {
        coreMotionService.exerciseDataPublisher.eraseToAnyPublisher()
    }

    var stepsPublisher: AnyPublisher<Int, Never> {
        coreMotionService.stepsPublisher.eraseToAnyPublisher()
    }
    init(
        exerciseRepository: ExerciseRepositoryProtocol,
        coreMotionService: CoreMotionServiceProtocol,
        coreLocationService: CoreLocationServicesProtocol
    ) {
        self.exerciseRepository = exerciseRepository
        self.coreMotionService = coreMotionService
        self.coreLocationService = coreLocationService
        setupMotionDataProcessing()
    }

    func startUpdateLocation() {
        coreLocationService.startupdatingLocation()
    }

    func stopUpdateLocation() {
        coreLocationService.stopupdatingLocation()
    }
    func postExerciseData(_ exerciseSession: ExerciseSession, _ exerciseData: ExerciseData) -> AnyPublisher<Bool, Error> {
        return exerciseRepository.postSaveExercise(exerciseSession, exerciseMetrics: ExerciseMetrics(minStride: exerciseData.strideDatas.min() ?? 0, maxStride: exerciseData.strideDatas.max() ?? 0, averageStride: exerciseData.averageStride, minSpeed: exerciseData.speedDatas.min() ?? 0, maxSpeed: exerciseData.speedDatas.max() ?? 0, averageSpeed: exerciseData.averageSpeed, step: exerciseData.walkCountDatas.last ?? 0, distance: exerciseData.distanceDatas.last ?? 0, datacount: exerciseData.speedDatas.count))
    }
    func startUpdateMotion(mode: ExerciseMode, userGoal: UserGoal) {
        self.exerciseMode = mode
        self.userGoal = userGoal
        coreMotionService.startPedometer()
    }
    
    func updateExerciseSettings(mode: ExerciseMode, userGoal: UserGoal) {
        self.exerciseMode = mode
        self.userGoal = userGoal
    }
    
    func stopUpdateMotion() {
        coreMotionService.stopActivity()
        exerciseMode = nil
        userGoal = nil
    }
    
    private func setupMotionDataProcessing() {
        coreMotionService.motionDataPublisher
            .sink { [weak self] rawMotionData in
                self?.processMotionData(rawMotionData)
            }
            .store(in: &cancellables)
    }
    
    private func processMotionData(_ rawData: RawMotionData) {
        guard let mode = exerciseMode, let goal = userGoal else { return }
        
        // Data Layer → Domain Layer 데이터 변환
        let performance = MotionPerformance(
            speed: rawData.speed,
            stride: rawData.stride, 
            timestamp: rawData.timestamp
        )
        
        // 도메인 로직 처리
        evaluatePerformance(performance, mode: mode, goal: goal)
    }
    
    private func evaluatePerformance(_ performance: MotionPerformance, mode: ExerciseMode, goal: UserGoal) {
        switch mode {
        case .speedMode:
            if performance.isSpeedBelowTarget(goal.goalSpeed) {
                let diff = roundTo(goal.goalSpeed - performance.speed, places: 1)
                feedbackSubject.send(.lowSpeed(diff: diff))
            }
        case .strideMode:
            if performance.isStrideBelowTarget(goal.goalStride) {
                let diff = goal.goalStride - performance.stride
                feedbackSubject.send(.lowStride(diff: diff))
            }
        default:
            break
        }
    }
    
    private func roundTo(_ value: Double, places: Int) -> Double {
        let multiplier = pow(10.0, Double(places))
        return (value * multiplier).rounded() / multiplier
    }
}

