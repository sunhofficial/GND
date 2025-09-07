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
    func selectChartMode(_ mode: ChartMode) // 차트 모드 선택 추가
}
protocol ExerciseViewModelOutput{
    var locationUpdatesPublisher: Published<[CLLocationCoordinate2D]>.Publisher {get}
    var feedbackPublisher: PassthroughSubject<WarningCase, Error> {get}
}
protocol ExerciseViewModelType: ExerciseViewModelInput, ExerciseViewModelOutput {
    var inputs: ExerciseViewModelInput { get }
    var outputs: ExerciseViewModelOutput {  get }
    // 차트 관련 Output 추가
      var animatedChartDataPublisher: Published<[DataPoint]>.Publisher { get }
      var chartGoalValuePublisher: Published<Double?>.Publisher { get }
}
final class ExerciseViewModel: ObservableObject, ExerciseViewModelType {
    var inputs:  ExerciseViewModelInput {return self}
    var outputs: ExerciseViewModelOutput {return self}
    @Published var progress: Float = 0.0
    @Published var exerciseData: ExerciseData? = nil
    @Published private(set) var exerciseTime: String?
    @Published private(set) var locationUpdates: [CLLocationCoordinate2D] = []
    var locationUpdatesPublisher: Published<[CLLocationCoordinate2D]>.Publisher { $locationUpdates }
       var feedbackPublisher = PassthroughSubject<WarningCase, Error>()
       var animatedChartDataPublisher: Published<[DataPoint]>.Publisher { $animatedChartData }
       var chartGoalValuePublisher: Published<Double?>.Publisher { $chartGoalValue }
    
    
    private var exerciseUsecase: ExerciseUsecase
    private weak var coordinator: StrideCoordinatorProtocol?

    private var cancellables = Set<AnyCancellable>()
    private let chartModeSubject = CurrentValueSubject<ChartMode, Never>(.speed)

    // 차트 관련 새로운 프로퍼티들
    @Published private(set) var animatedChartData: [DataPoint] = []
    @Published private(set) var chartGoalValue: Double? = nil
    @Published var selectedChartMode: ChartMode = .speed
    
    // 운동 설정 관리
    private let exerciseMode: ExerciseMode
    private let userGoal: UserGoal
    var stepGoal: Int = 0 // 걸음 수 목표
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
    
    init(coordinator: StrideCoordinator, exerciseUsecase: ExerciseUsecase, exerciseMode: ExerciseMode, userGoal: UserGoal, stepGoal: Int) {
        self.coordinator = coordinator
        self.exerciseUsecase = exerciseUsecase
        self.exerciseMode = exerciseMode
        self.userGoal = userGoal
        self.stepGoal = stepGoal
        setup()
        setupChartAnimationStream()
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
        exerciseUsecase.startUpdateMotion(mode: exerciseMode, userGoal: userGoal)
        exerciseUsecase.startUpdateLocation()
        startTime = Date()
    }
    
    func updateExerciseSettings(mode: ExerciseMode, userGoal: UserGoal) {
        exerciseUsecase.updateExerciseSettings(mode: mode, userGoal: userGoal)
    }
    func stopTracking() {
        exerciseUsecase.stopUpdateLocation()
        exerciseUsecase.stopUpdateMotion()
        coordinator?.finishExerciseView(vm: self)
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
        progress = Float(stepGoal/steps)
    }
    private func setupChartAnimationStream() {
           chartModeSubject
               .map { [weak self] mode -> AnyPublisher<DataPoint, Never> in
                   guard let self = self else {
                       return Empty<DataPoint, Never>().eraseToAnyPublisher()
                   }
                   return self.createAnimationStream(for: mode)
               }
               .switchToLatest() // 🚀 핵심: 새로운 모드 선택 시 이전 스트림 자동 취소
               .receive(on: DispatchQueue.main)
               .sink { [weak self] dataPoint in
                   
                       self?.animatedChartData.append(dataPoint) // 효율적인 append!
                   
               }
               .store(in: &cancellables)
           
           // 모드 변경 시 배열 초기화 및 목표값 업데이트
           chartModeSubject
               .sink { [weak self] mode in
                   self?.animatedChartData = [] // 새 모드 시작 시 배열 초기화
                   self?.chartGoalValue = self?.getGoalValue(for: mode)
               }
               .store(in: &cancellables)
       }
       
       private func createAnimationStream(for mode: ChartMode) -> AnyPublisher<DataPoint, Never> {
           let dataPoints = getDataPoints(for: mode)
           
           guard !dataPoints.isEmpty else {
               return Empty<DataPoint, Never>().eraseToAnyPublisher()
           }
           
           // 각 데이터 포인트를 시간차를 두고 하나씩 방출
           return Publishers.Sequence(sequence: dataPoints.enumerated())
               .flatMap { (index, dataPoint) in
                   Just(dataPoint)
                       .delay(for: .milliseconds(index * 10), scheduler: DispatchQueue.main)
               }
               .eraseToAnyPublisher()
       }
    private func getDataPoints(for mode: ChartMode) -> [DataPoint] {
            guard let exerciseData = exerciseData else { return [] }
            
            switch mode {
            case .speed:
                return exerciseData.speedDatas.enumerated().map {
                    DataPoint(time: $0, value: $1)
                }
            case .stride:
                return exerciseData.strideDatas.enumerated().map {
                    DataPoint(time: $0, value: Double($1))
                }
            case .distance:
                return exerciseData.distanceDatas.enumerated().map {
                    DataPoint(time: $0, value: Double($1))
                }
            case .walkCount:
                return exerciseData.walkCountDatas.enumerated().map {
                    DataPoint(time: $0, value: Double($1))
                }
            }
        }
    private func getGoalValue(for mode: ChartMode) -> Double? {
          // userGoal이 Int라서 임시로 UserGoal 객체가 있다고 가정
          // 실제로는 UserGoal 객체를 받아야 함
          switch mode {
          case .speed:
              return 5.0 // 예시값 - 실제로는 userGoal.goalSpeed
          case .stride:
              return 70.0 // 예시값 - 실제로는 Double(userGoal.goalStride)
          case .distance:
              return nil
          case .walkCount:
              return Double(stepGoal) // 목표 걸음 수
          }
      }
    func selectChartMode(_ mode: ChartMode) {
          selectedChartMode = mode
          chartModeSubject.send(mode)
      }
}
