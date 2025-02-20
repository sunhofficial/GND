//
//  ExerciseUseCase.swift
//  GND
//
//  Created by 235 on 5/14/24.
//

import Foundation
import Combine
import CoreLocation

protocol ExerciseUseCaseProtocol {
    var locationPublisher: AnyPublisher<[CLLocationCoordinate2D], Never> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
    var feedbackPublisher: AnyPublisher<WarningCase, Error> {get}
    var stepsPublisher: AnyPublisher<Int,Never> {get}
    var exerciseDataPublisher: AnyPublisher<ExerciseData, Never> {
       get
    }
    func startUpdateLocation()
    func stopUpdateLocation()
    func startUpdateMotion()
    func stopUpdateMotion()
    func postExerciseData(_ exerciseSession: ExerciseSession, _ exerciseData: ExerciseData) -> AnyPublisher<Bool, Error>

}


final class ExerciseUsecase: ExerciseUseCaseProtocol {
    private let coreLocationService: CoreLocationServicesProtocol
    var exerciseRepository: ExerciseRepositoryProtocol
    private let coreMotionService: CoreMotionServiceProtocol
    var locationPublisher: AnyPublisher<[CLLocationCoordinate2D], Never> {
        coreLocationService.locationPublisher
            .map { locations in
                locations.map { $0.coordinate }
            }
            .eraseToAnyPublisher()
    }
    var feedbackPublisher: AnyPublisher<WarningCase, Error> {
        coreMotionService.warningPublisher.eraseToAnyPublisher()
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
    func startUpdateMotion() {
        coreMotionService.startPedometer()
    }
    func stopUpdateMotion() {
        coreMotionService.stopActivity()
    }
}

