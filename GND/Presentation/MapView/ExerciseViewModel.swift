//
//  ExerciseViewModel.swift
//  GND
//
//  Created by 235 on 5/14/24.
//

import Foundation
import Combine
import CoreLocation

enum WarningCase {
    case lowStride(diff: Int)
    case lowSpeed(diff: Double)

    var warningTitle: String {
        switch self {
        case .lowStride:
            "보폭이 짧아요"
        case .lowSpeed:
            "속도가 느려요"
        }
    }
    var warningDescription: String {
        switch self {
        case .lowStride(let diff):
            "\(diff)cm 더 길게 걸어주세요"
        case .lowSpeed(let diff):
            "\(diff)m/s 더 빠르게 걸어주세요"
        }
    }
}
protocol ExerciseViewModelInput {
    func sendToSever(title: String)
    func sendNotsharing()
    func startTracking()
    func stopTracking()
}
protocol ExerciseViewModelOutput{
    var locationUpdatesPublisher: Published<[CLLocationCoordinate2D]>.Publisher {get}
    //    var motionUpdatesPublihser: Published<ExerciseTracking>.Publisher { get  }
    var feedbackPublisher: PassthroughSubject<WarningCase, Error> {get}
}
protocol ExerciseViewModelType: ExerciseViewModelInput, ExerciseViewModelOutput {
    var inputs: ExerciseViewModelInput { get }
    var outputs: ExerciseViewModelOutput {  get }
}
final class ExerciseViewModel: ObservableObject, ExerciseViewModelType {
    var inputs:  ExerciseViewModelInput {return self}

    var outputs: ExerciseViewModelOutput {return self}


    //    var motionUpdatesPublihser: Published<ExerciseTracking>.Publisher
    var feedbackPublisher = PassthroughSubject<WarningCase, Error>()
//    var motionPublisher =  PassthroughSubject<ExerciseTracking,  Error>()
    var locationUpdatesPublisher: Published<[CLLocationCoordinate2D]>.Publisher {$locationUpdates} //locationupdates가 달라질때마다 구독자에게 이벤트 방출함.
    private var exerciseUsecase: ExerciseUseCaseProtocol?
    private var cancellables = Set<AnyCancellable>()
    private weak var coordinator: StrideCoordinator?
    @Published var locationUpdates: [CLLocationCoordinate2D] = [] 
    var userGoal: Int = 0
    @Published var progress: Float = 0.0
    @Published var exerciseData: ExerciseData? = nil
    var startTime: Date?
    var endTime: Date? {
        didSet {
            calculateExerciseTime()
        }
    }
    @Published var exerciseTime: String?
    private var steps = 0 {
        didSet {
            updateProgress()
        }
    }
    init(coordinator: StrideCoordinator, exerciseUsecase: ExerciseUseCaseProtocol, userGoal:Int ) {
        self.coordinator = coordinator
        self.exerciseUsecase = exerciseUsecase
        self.userGoal = userGoal
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
        exerciseUsecase.feedbackPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    debugPrint("success")
                case .failure(let err):
                    print(err)
                }
            } receiveValue: { warningcase in
                self.feedbackPublisher.send(warningcase)
                
            }.store(in: &cancellables)


        exerciseUsecase.exerciseDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { exercisedatas in
                self.exerciseData = exercisedatas
            }.store(in: &cancellables)

        exerciseUsecase.stepsPublisher
            .receive(on: DispatchQueue.main)
            .sink { steps in
                self.steps += steps
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
        let course = locationUpdates.map { location in
            Coordinate(latitude: location.latitude, longitude: location.longitude)
        }
        exerciseUsecase?.postExerciseData(ExerciseSession(startTime: startTime.formattedDateString(), endTime: endTime.formattedDateString(), course: course, doShareCourse: true, courseName: title), exerciseData )
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { result in
                print("올라간다")
            }).store(in: &cancellables)
    }
    func sendNotsharing() {
        guard let startTime = startTime, let endTime = endTime, let exerciseData = exerciseData else {return}
        let course = locationUpdates.map { location in
            Coordinate(latitude: location.latitude, longitude: location.longitude)
        }
        exerciseUsecase?.postExerciseData(ExerciseSession(startTime: startTime.formattedDateString(), endTime: endTime.formattedDateString(), course: course, doShareCourse: false), exerciseData)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: {[weak self] result in
                self?.coordinator?.resetToMainView()
            }).store(in: &cancellables)
    }

    private func updateProgress() {
        progress = Float(userGoal/steps)
    }
}
