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
    var motionPublisher: AnyPublisher<ExerciseTracking, Error> {get}
    func startUpdateLocation()
    func stopUpdateLocation()
    func startUpdateMotion()
    func stopUpdateMotion()
    func postExerciseData(_ exercise: Exercise) -> AnyPublisher<Exercise, Error>

}


final class ExerciseUsecase: ExerciseUseCaseProtocol {
    private let coreLocationService: CoreLocationServicesProtocol
    var exerciseRepository: ExerciseRepository
    private let coreMotionService: CoreMotionServiceProtocol
    var locationPublisher: AnyPublisher<[CLLocationCoordinate2D], Never> {
        coreLocationService.locationPublisher
            .map { locations in
                locations.map { $0.coordinate }
            }
            .eraseToAnyPublisher()
    }
    var motionPublisher: AnyPublisher<ExerciseTracking, Error> {
        coreMotionService.trackingPublisher
            .eraseToAnyPublisher()
    }
    var errorPublisher: AnyPublisher<Error, Never> {
        coreLocationService.errorPublisher.eraseToAnyPublisher()
    }
    var exerciseDataPublisher: AnyPublisher<ExerciseData, Never> {
        coreMotionService.exerciseDataPublisher.eraseToAnyPublisher()
    }

    init(coreLocationService: CoreLocationServicesProtocol, exerciseRepository: ExerciseRepository, coreMotionService: CoreMotionServiceProtocol) {
        self.coreLocationService = coreLocationService
        self.exerciseRepository = exerciseRepository
        self.coreMotionService = coreMotionService
    }

    func startUpdateLocation() {
        coreLocationService.startupdatingLocation()
    }

    func stopUpdateLocation() {
        coreLocationService.stopupdatingLocation()
    }
    func postExerciseData(_ exercise: Exercise) -> AnyPublisher<Exercise, Error> {
        return exerciseRepository.postSaveExercise(exercise)
    }
    func startUpdateMotion() {
        coreMotionService.startPedometer()
    }
    func stopUpdateMotion() {
        coreMotionService.stopActivity()
    }
}

