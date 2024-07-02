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
    private var isFirst: Bool
    @Published var modalGoal: ModalGoal?
    @Published var userLevel: UserLevel = .low
    @Published var userGoal: UserGoal?
    private var showCount = 1
    //    @Published var nextCourseId: Int?
    @Published var recentCourse: RecentCourse?
    @Published var recentCourses: [RecentCourse] = []
    private var hasMoreData = true
    private var nextCourseId: Int?
    var postPublisher = PassthroughSubject<Bool,  Never>()
    var firstPublisher = PassthroughSubject<Bool, Never>()
    var levelupPublisher = PassthroughSubject<Bool, Never>()

    func moveToExercise(mode: ExerciseMode) {
        guard let userGoal = userGoal else {return}
        coordinator?.doExerciseView(mode: mode, userGoal: (userGoal.goalStep) - (userGoal.todayStep), goal: userGoal)
    }

    init(coordinator: StrideCoordinator, useCase: UserUseCaseProtocol, courseUsercase : CourseUseCaseProtocol, isFirst: Bool) {
        self.coordinator = coordinator
        self.userUsecase = useCase
        self.courseUsercase = courseUsercase
        self.isFirst = isFirst
    }

    func moveToRecent() {
        coordinator?.showRecentView()
    }

    func getUserGoal()  {
        userUsecase?.getUserGoal()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self]compleiton in
                self?.postPublisher.send(true)
                if self?.isFirst == true {
                    self?.isFirst = false
                    self?.firstPublisher.send(true)
                }
            }, receiveValue: { data in
                if data.levelup {
                    self.levelupPublisher.send(true)
                    self.modalGoal = ModalGoal(stride: data.goalStride, averageSpeed: data.goalSpeed, walkCount: data.goalStep)
                }
                if let level = UserLevel(rawValue: data.level) {
                    self.userLevel = level
                }
                self.userGoal = data
            }).store(in: &cancellables)
    }

    func getRecentCourses() {
        guard hasMoreData else {return}
        courseUsercase?.getRecentCourses(showCount: showCount, nextID: nextCourseId)
            .sink(receiveCompletion: { completion in
                self.postPublisher.send(true)
            }, receiveValue: { [weak self] pagenatied in
                self?.recentCourses.append(contentsOf: pagenatied.courses)
                self?.nextCourseId = pagenatied.nextcourseId
                self?.hasMoreData = pagenatied.hasNext
            }).store(in: &cancellables)
    }

    func getRecent1Course() {
        courseUsercase?.getRecentCourses(showCount: 1, nextID: nil)
            .sink(receiveCompletion: { completion in
                self.postPublisher.send(true)
            }, receiveValue: { [weak self ] page in
                if let data = page.courses.first {
                    self?.recentCourse = data
                }
            }).store(in: &cancellables)
    }

    func eraseRecentCourses() {
        recentCourses = []
    }
}
