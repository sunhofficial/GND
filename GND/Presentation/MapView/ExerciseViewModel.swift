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
            "\(diff)km/h 더 빠르게 걸어주세요"
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
    var feedbackPublisher: PassthroughSubject<WarningCase, Error> {get}
}
protocol ExerciseViewModelType: ExerciseViewModelInput, ExerciseViewModelOutput {
    var inputs: ExerciseViewModelInput { get }
    var outputs: ExerciseViewModelOutput {  get }
}
final class ExerciseViewModel: ObservableObject, ExerciseViewModelType {
    var inputs:  ExerciseViewModelInput {return self}
    var outputs: ExerciseViewModelOutput {return self}
    @Published var progress: Float = 0.0
    @Published var exerciseData: ExerciseData? = nil
    @Published private(set) var exerciseTime: String?
    @Published private(set) var locationUpdates: [CLLocationCoordinate2D] = []
    private var exerciseUsecase: ExerciseUseCaseProtocol
    private weak var coordinator: StrideCoordinatorProtocol?
    var feedbackPublisher = PassthroughSubject<WarningCase, Error>()
    var locationUpdatesPublisher: Published<[CLLocationCoordinate2D]>.Publisher {$locationUpdates} //locationupdates가 달라질때마다 구독자에게 이벤트 방출함.
    private var cancellables = Set<AnyCancellable>()
    var userGoal: Int = 0
    var startTime: Date?
    var endTime: Date? {
        didSet {
            calculateExerciseTime()
        }
    }
    private var steps = 0 {
        didSet {
            updateProgress()
        }
    }
    
    init(coordinator: StrideCoordinator, exerciseUsecase: ExerciseUseCaseProtocol, userGoal:Int ) {
        self.coordinator = coordinator
        self.exerciseUsecase = exerciseUsecase
        self.userGoal = userGoal
        setup()
    }
    private func setup() {
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
            if case .failure(let error) = completion {
                  print("Feedback error: \(error)")
              }
            } receiveValue: { warningcase in
                self.feedbackPublisher.send(warningcase)
            }.store(in: &cancellables)
        exerciseUsecase.exerciseDataPublisher
            .receive(on: DispatchQueue.main)
            .sink {  [weak self] exercisedatas in
                self?.exerciseData = exercisedatas
            }.store(in: &cancellables)
        exerciseUsecase.stepsPublisher
            .receive(on: DispatchQueue.main)
            .sink { steps in
                self.steps += steps
            }.store(in: &cancellables)
    }
    func startTracking() {
        exerciseUsecase.startUpdateMotion()
        exerciseUsecase.startUpdateLocation()
        startTime = Date()
    }
    func stopTracking() {
        exerciseUsecase.stopUpdateLocation()
        exerciseUsecase.stopUpdateMotion()
        coordinator?.finishExerciseView()
        endTime = Date()
    }

    func sendToSever(title: String) {
        sendExerciseData(doShare: true, courseName: title)
    }
    func sendNotsharing() {
        sendExerciseData(doShare: false)
    }
    private func sendExerciseData(doShare: Bool, courseName: String? = nil) {
        guard let startTime = startTime, let endTime = endTime, let exerciseData = exerciseData else {return}
        let course = locationUpdates.map { location in
            Coordinate(latitude: location.latitude, longitude: location.longitude)
        }
        let exerciseSession = ExerciseSession(startTime: startTime.formattedDateString(), endTime: endTime.formattedDateString(), course: course, doShareCourse: doShare, courseName: courseName)
        exerciseUsecase.postExerciseData(exerciseSession, exerciseData)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.coordinator?.resetToMainView()
            }, receiveValue: {[weak self] result in
                self?.coordinator?.resetToMainView()
            }).store(in: &cancellables)
        
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
    private func updateProgress() {
        progress = Float(userGoal/steps)
    }
}
