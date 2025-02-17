import Foundation
import CoreMotion
import Combine


class CoreMotionService: CoreMotionServiceProtocol {
    var mode: ExerciseMode
    var userGoal: UserGoal
    private let pedometer = CMPedometer()
    private let activityManager = CMMotionActivityManager()
    private var pastTime: Date?
    private var timer: AnyCancellable?
    private let warningSubject = PassthroughSubject<WarningCase, Error>()
    private let exerciseDatas = PassthroughSubject<ExerciseData, Never>()
    private let stepsSubject = PassthroughSubject<Int, Never>()
    private var cancellables = Set<AnyCancellable>()

    private var speedDatas = [Double]()
    private var strideDatas = [Int]()
    private var distanceDatas = [Int]()
    private var walkCountDatas = [Int]()

    private var currentDistance: Int = 0
    private var currentStep: Int = 0

    var exerciseDataPublisher: AnyPublisher<ExerciseData, Never> {
        exerciseDatas.eraseToAnyPublisher()
    }

    var stepsPublisher: AnyPublisher<Int, Never> {
        stepsSubject.eraseToAnyPublisher()
    }

    var warningPublisher: AnyPublisher<WarningCase, Error> {
        warningSubject.eraseToAnyPublisher()
    }

    init(mode: ExerciseMode, goal: UserGoal) {
        self.mode = mode
        self.userGoal = goal
    }

    func startPedometer() {
        activityManager.startActivityUpdates(to: .main) { [weak self] activity in
            guard let self = self, activity != nil else { return }
            if self.timer == nil {
                self.startStepping()
            }
        }
    }

    func stopActivity() {
        activityManager.stopActivityUpdates()
        timer?.cancel()
        timer = nil

        Task {
            await self.fetchStepData(isFinalFetch: true)
        }
        pedometer.stopUpdates()
    }

    private func startStepping() {
        pedometer.startUpdates(from: Date()) { [weak self] data, _ in
            guard let self = self else { return }
            self.currentDistance = data?.distance?.intValue ?? self.currentDistance
            self.currentStep = data?.numberOfSteps.intValue ?? self.currentStep
        }

        timer = Timer.publish(every: 20.0, tolerance: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task {
                    await self.fetchStepData()
                }
            }
    }

    private func fetchStepData(isFinalFetch: Bool = false) async {
        let nowDate = Date()
        let fromDate = isFinalFetch ? (pastTime ?? nowDate.addingTimeInterval(-20)) : nowDate.addingTimeInterval(-20)

        do {
            let data = try await pedometer.queryPedometerDataAsync(from: fromDate, to: nowDate)
            self.processPedometerData(data)

            if isFinalFetch {
                let exerciseData = ExerciseData(speedDatas: speedDatas, strideDatas: strideDatas, distanceDatas: distanceDatas, walkCountDatas: walkCountDatas)
                exerciseDatas.send(exerciseData)
                speedDatas.removeAll()
                strideDatas.removeAll()
                distanceDatas.removeAll()
                walkCountDatas.removeAll()
            }
        } catch {
            DispatchQueue.main.async {
                self.warningSubject.send(completion: .failure(error))
            }
        }
        pastTime = nowDate
    }

    private func processPedometerData(_ data: CMPedometerData) {
        guard let distance = data.distance?.intValue, distance != 0, data.numberOfSteps.intValue != 0, let averagePace = data.averageActivePace else { return }
        let steps = data.numberOfSteps.intValue
        let speedKmh = round(averagePace.doubleValue * 36) / 10
        let stride = distance * 100 / steps
        stepsSubject.send(steps)

        distanceDatas.append(currentDistance)
        walkCountDatas.append(currentStep)
        speedDatas.append(speedKmh)
        strideDatas.append(stride)

        processStepData(stride: stride, speed: speedKmh)
    }
    private func roundTo(_ value: Double, places: Int) -> Double {
        let multiplier = pow(10.0, Double(places))
        return (value * multiplier).rounded() / multiplier
    }

    private func processStepData(stride: Int, speed: Double) {
        switch mode {
        case .speedMode:
            if speed < userGoal.goalSpeed{

                print(userGoal.goalSpeed)
                let diff = roundTo(userGoal.goalSpeed - speed, places: 1)
                DispatchQueue.main.async {
                    self.warningSubject.send(WarningCase.lowSpeed(diff: diff))
                }
            }
        case .strideMode:
            if stride < userGoal.goalStride {
                let diff = userGoal.goalStride - stride
                DispatchQueue.main.async {
                    self.warningSubject.send(WarningCase.lowStride(diff: diff))
                }
            }
        default:
            break
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
