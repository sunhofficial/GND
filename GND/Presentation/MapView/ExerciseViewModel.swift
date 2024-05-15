//
//  ExerciseViewModel.swift
//  GND
//
//  Created by 235 on 5/14/24.
//

import Foundation
import Combine
import CoreLocation


protocol ExerciseViewModelOutput {
    var locationUpdatesPublisher: Published<[CLLocationCoordinate2D]>.Publisher {get}
}
final class ExerciseViewModel: ObservableObject, ExerciseViewModelOutput {
    var locationUpdatesPublisher: Published<[CLLocationCoordinate2D]>.Publisher {$locationUpdates} //locationupdates가 달라질때마다 구독자에게 이벤트 방출함.
    private var exerciseUsecase: ExerciseUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    @Published var locationUpdates: [CLLocationCoordinate2D] = [] {
        didSet {
            print(locationUpdates)
        }
    }
    init( exerciseUsecase: ExerciseUsecase) {
//        super.init()
//        self.startTracking()
        self.exerciseUsecase = exerciseUsecase
        exerciseUsecase.locationPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] coordinates in
                self?.locationUpdates.append(contentsOf: coordinates)
            }.store(in: &cancellables)
        exerciseUsecase.errorPublisher
             .sink(receiveValue: { error in
                 print("Location update failed with error: \(error)")
             })
             .store(in: &cancellables)
    }
    func startTracking() {
        exerciseUsecase.startUpdating()
    }
    func stopTracking() {
        print("운동종료")
        let coordinates = locationUpdates.map { Coordinate(latitude: $0.latitude, longitude: $0.longitude) }
        print(coordinates)
        exerciseUsecase.stopUpdating()
    }

}
