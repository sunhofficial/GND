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
    //    var motionUpdatesPublihser: Published<ExerciseTracking>.Publisher { get  }
    var motionPublisher: PassthroughSubject<Bool, Error> {get}
}
final class ExerciseViewModel: ObservableObject, ExerciseViewModelOutput {
    //    var motionUpdatesPublihser: Published<ExerciseTracking>.Publisher
    var motionPublisher =  PassthroughSubject<Bool,  Error>()
    var locationUpdatesPublisher: Published<[CLLocationCoordinate2D]>.Publisher {$locationUpdates} //locationupdates가 달라질때마다 구독자에게 이벤트 방출함.
    private var exerciseUsecase: ExerciseUseCaseProtocol?
    private var cancellables = Set<AnyCancellable>()
    private weak var coordinator: StrideCoordinator?
    @Published var locationUpdates: [CLLocationCoordinate2D] = [] {
        didSet {
            print(locationUpdates)
        }
    }

    @Published var exerciseData: ExerciseData? = nil
    var startTime: Date?
    var endTime: Date? {
        didSet {
            calculateExerciseTime()
        }
    }
    @Published var exerciseTime: String?
    init(dummyData: ExerciseData) {
        self.exerciseData = dummyData
    }
    init(coordinator: StrideCoordinator, exerciseUsecase: ExerciseUsecase) {
        self.coordinator = coordinator
        self.exerciseUsecase = exerciseUsecase
        exerciseUsecase.locationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coordinates in
                self?.locationUpdates.append(contentsOf: coordinates)
            }.store(in: &cancellables)
        exerciseUsecase.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { error in
                print("Location update failed with error: \(error)")
            })
            .store(in: &cancellables)
        exerciseUsecase.motionPublisher
        //            .receive(on: DispatchQueue.main)
            .receive(on: RunLoop.main)  //스크롤등 busy할때 안하다가인터렉션이 끝나면 작동한다. 현재 이것은 타이머를 통해 데이터를 받아와 피드백이기에
            .sink { completion in
                switch completion {
                case .finished:
                    debugPrint("success")
                case .failure(let err):
                    print(err)
                }
            } receiveValue: { [weak self] exerciseTracking in
                print(exerciseTracking)
            }.store(in: &cancellables)
        exerciseUsecase.exerciseDataPublisher
            .receive(on: DispatchQueue.main) // x
            .sink { exercisedatas in
                self.exerciseData = exercisedatas
            }.store(in: &cancellables)
    }
    func startTracking() {
        exerciseUsecase?.startUpdateMotion()
        exerciseUsecase?.startUpdateLocation()
        startTime = Date()
    }
    func stopTracking() {
        print("운동종료")
        let coordinates = locationUpdates.map { Coordinate(latitude: $0.latitude, longitude: $0.longitude) }
        print(coordinates)
        exerciseUsecase?.stopUpdateLocation()
        exerciseUsecase?.stopUpdateMotion()
        coordinator?.finishExerciseView()
        endTime = Date()
    }
    private func calculateExerciseTime() {
        guard let startTime = startTime, let endTime = endTime else {
            exerciseTime = nil
            return
        }

        let elapsedTime = endTime.timeIntervalSince(startTime)
        let hours = Int(elapsedTime) / 3600
        let minutes = (Int(elapsedTime) % 3600) / 60

        exerciseTime = String(format: "%02d시간 %02d분", hours, minutes)
    }
    func sendToSever(title: String) {
        guard let startTime = startTime, let endTime = endTime, let exerciseData = exerciseData else {return}
        var course = locationUpdates.map { location in
            Coordinate(latitude: location.latitude, longitude: location.longitude)
        }
        exerciseUsecase?.postExerciseData(ExerciseSession(startTime: startTime, endTime: endTime, course: course, doShareCourse: true, courseName: title), exerciseData )
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { result in
                print("올라간다")
            })
    }
}
