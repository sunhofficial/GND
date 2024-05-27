//
//  MainViewModel.swift
//  GND
//
//  Created by 235 on 5/14/24.
//

import UIKit
import Combine

protocol MainviewModelInput {
    func moveToExercise(mode: ExerciseMode)
    func getUserGoal()
}

final class MainViewModel: ObservableObject, MainviewModelInput {
    private weak var coordinator: StrideCoordinator?
    private var userUsecase: UserUseCaseProtocol?
    private var cancellables = Set<AnyCancellable>()
    @Published var userLevel: UserLevel = .low
    @Published var userGoal: UserGoal?
    var postPublisher = PassthroughSubject<Bool,  Never>()
    func moveToExercise(mode: ExerciseMode) {
        coordinator?.doExerciseView(mode: mode, userGoal: (userGoal?.goalStep ?? 0) - (userGoal?.todayStep ?? 0))
    }
    init(coordinator: StrideCoordinator, useCase: UserUseCaseProtocol) {
        self.coordinator = coordinator
        self.userUsecase = useCase
    }
    func getUserGoal()  {
        userUsecase?.getUserGoal()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { compleiton in
                self.postPublisher.send(true)
            }, receiveValue: { data in
                if let level = UserLevel(rawValue: data.level) {
                    self.userLevel = level
                }
                self.userGoal = data
            }).store(in: &cancellables)
    }
}
