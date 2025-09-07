//
//  StrideCoordinator.swift
//  GND
//
//  Created by 235 on 5/13/24.
//

import UIKit

protocol StrideCoordinatorProtocol: Coordinator {
    func doExerciseView(mode: ExerciseMode, userGoal: Int, goal: UserGoal)
    func showRecentView()
    func finishExerciseView(vm: ExerciseViewModel)
    func resetToMainView()
}
class StrideCoordinator: StrideCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    private var mainviewController: MainViewController!
    var childCoordinators: [ Coordinator] = []
    var type: CoordinatorType {.home}
    var courseUseCase: CourseUseCaseProtocol
    var isFirst: Bool
    var userUsecase: UserUsecase
    private var userGoal: UserGoal?
    private let conatiner = DIContainer.shared
    init(navigationController: UINavigationController, userUseCase: UserUsecase, courseUseCase: CourseUseCaseProtocol, isFirst: Bool) {
          self.navigationController = navigationController
          self.userUsecase = userUseCase
          self.courseUseCase = courseUseCase
          self.isFirst = isFirst
      }
    
    func start() {
        mainviewController = MainViewController()
        let mainViewModel = MainViewModel(
            coordinator: self,
            useCase: userUsecase,
            courseUsercase: courseUseCase,
            isFirst: isFirst
        )
        mainviewController.viewModel = mainViewModel

        self.navigationController.pushViewController(mainviewController, animated: false)
    }
    
    func doExerciseView(mode: ExerciseMode, userGoal: Int, goal: UserGoal) {
        self.navigationController.isNavigationBarHidden = true
        let exerciseViewController = ExerciseViewController()
        let exerciseUseCase = conatiner.provideExerciseUseCase()
        let viewModel = ExerciseViewModel(
            coordinator: self,
            exerciseUsecase: exerciseUseCase,
            exerciseMode: mode,
            userGoal: goal,
            stepGoal: userGoal
        )
        self.userGoal = goal
        exerciseViewController.viewModel = viewModel
        navigationController.pushViewController(exerciseViewController, animated: false)
    }

    func showRecentView() {
        let recentViewController = RecentViewController()
        let viewModel = MainViewModel(coordinator: self, useCase: userUsecase, courseUsercase: courseUseCase, isFirst: isFirst)
        recentViewController.viewModel = viewModel
        navigationController.pushViewController(recentViewController, animated: false)
    }

    func finishExerciseView(vm: ExerciseViewModel) {
        let finshExerciseViewController = FinishExerciseViewController()
        finshExerciseViewController.viewModel = vm
        finshExerciseViewController.userGoal = self.userGoal
        navigationController.pushViewController(finshExerciseViewController, animated: true)
    }



    func resetToMainView() {
        self.navigationController.isNavigationBarHidden = false
        navigationController.setViewControllers([mainviewController], animated: true)
    }
}
