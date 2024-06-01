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
        func finishExerciseView()

    }
    class StrideCoordinator: StrideCoordinatorProtocol {
        var exerciseUseCase: ExerciseUseCaseProtocol?
        var courseUseCase: CourseUseCaseProtocol?
        var exerciseViewModel: ExerciseViewModel?
        private var mainViewModel: MainViewModel?
        var userUsecase: UserUsecase?
        required init(_ navigationController: UINavigationController) {
            self.navigationController = navigationController
            self.mainviewController = MainViewController()
        }
        func doExerciseView(mode: ExerciseMode, userGoal: Int, goal: UserGoal) {
            self.navigationController.isNavigationBarHidden = true
            let exerciseViewController = ExerciseViewController()
            self.exerciseUseCase =  ExerciseUsecase(coreLocationService: CoreLocationServices(), exerciseRepository: ExerciseRepository(), coreMotionService: CoreMotionService(mode: mode, goal: goal)) // 이것도 어디서 주입할지 생각해봐야할듯 여기서부터 필요한가?
            self.exerciseViewModel = ExerciseViewModel(coordinator: self, exerciseUsecase: exerciseUseCase!, userGoal:  userGoal)
            exerciseViewController.viewModel = exerciseViewModel
            navigationController.pushViewController(exerciseViewController, animated: false)
        }

        func showRecentView() {
            let recentViewController = RecentViewController()
            recentViewController.viewModel = mainViewModel
//            recentViewController.navigationItem.hidesBackButton = false
//               self.navigationController.setNavigationBarHidden(true, animated: false)
            navigationController.pushViewController(recentViewController, animated: false)
        }

        func finishExerciseView() {
            let finshExerciseViewController = FinishExerciseViewController()
            finshExerciseViewController.viewModel = exerciseViewModel
            navigationController.pushViewController(finshExerciseViewController, animated: true)
        }

        weak var finishDelegate: CoordinatorFinishDelegate?

        var navigationController: UINavigationController
        var mainviewController: MainViewController
        var childCoordinators: [ Coordinator] = []

        var type: CoordinatorType {.home}

        func start() {
            mainViewModel = MainViewModel(coordinator: self, useCase: userUsecase!, courseUsercase: courseUseCase!)
            mainviewController.viewModel = mainViewModel

            self.navigationController.pushViewController(mainviewController, animated: false)
        }
        func resetToMainView() {
            navigationController.setViewControllers([mainviewController], animated: true)
        }
    }
