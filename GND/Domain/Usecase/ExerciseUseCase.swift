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
    func startUpdating()
    func stopUpdating()
    
}


final class ExerciseUsecase: ExerciseUseCaseProtocol {
    private let coreLocationService: CoreLocationServicesProtocol

    var locationPublisher: AnyPublisher<[CLLocationCoordinate2D], Never> {
        coreLocationService.locationPublisher
            .map { locations in
                locations.map { $0.coordinate }
            }
            .eraseToAnyPublisher()
    }

    var errorPublisher: AnyPublisher<Error, Never> {
        coreLocationService.errorPublisher.eraseToAnyPublisher()
    }

    init(coreLocationService: CoreLocationServicesProtocol) {
        self.coreLocationService = coreLocationService
    }

    func startUpdating() {
        coreLocationService.startupdatingLocation()
    }

    func stopUpdating() {
        coreLocationService.stopupdatingLocation()
    }
}
