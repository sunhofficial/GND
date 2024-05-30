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
    private var courseUsercase: CourseUseCaseProtocol?
    private var cancellables = Set<AnyCancellable>()
    @Published var userLevel: UserLevel = .low
    @Published var userGoal: UserGoal?
    private var showCount = 1
    @Published var nextCourseId: Int?
    @Published var recentCourses: RecentCourse?
    var postPublisher = PassthroughSubject<Bool,  Never>()
    func moveToExercise(mode: ExerciseMode) {
        guard let userGoal = userGoal else {return}
        coordinator?.doExerciseView(mode: mode, userGoal: (userGoal.goalStep) - (userGoal.todayStep), goal: userGoal)
    }
    init(coordinator: StrideCoordinator, useCase: UserUseCaseProtocol, courseUsercase : CourseUseCaseProtocol) {
        self.coordinator = coordinator
        self.userUsecase = useCase
        self.courseUsercase = courseUsercase
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
    func getRecentCourses() {
        courseUsercase?.getRecentCourses(showCount: showCount, nextID: nextCourseId)
            .sink(receiveCompletion: { completion in
                self.postPublisher.send(true)
            }, receiveValue: { [weak self]pagenatied in
                if let data = pagenatied.courses.first {
                    self?.recentCourses = data
                }
//                recentCourses = pagenatied.courses.first
            }).store(in: &cancellables)
    }
}
