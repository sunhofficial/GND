//
//  StrideCoordinator.swift
//  GND
//
//  Created by 235 on 5/13/24.
//

import UIKit

protocol StrideCoordinatorProtocol: Coordinator {
    func doExerciseView(mode: ExerciseMode)
    func showRecentView()
    func finishExerciseView()

}
class StrideCoordinator: StrideCoordinatorProtocol {
    var exerciseUseCase = ExerciseUsecase(coreLocationService: CoreLocationServices(), exerciseRepository: ExerciseRepository(), coreMotionService: CoreMotionService()) // 이것도 어디서 주입할지 생각해봐야할듯 여기서부터 필요한가?
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.mainviewController = MainViewController()
    }
    func doExerciseView(mode: ExerciseMode) {
        let exerciseViewController = ExerciseViewController()
        exerciseViewController.viewModel = ExerciseViewModel(exerciseUsecase: exerciseUseCase)
        navigationController.pushViewController(exerciseViewController, animated: false)
    }
    
    func showRecentView() {

    }
    
    func finishExerciseView() {

    }
    
    weak var finishDelegate: CoordinatorFinishDelegate?

    var navigationController: UINavigationController
    var mainviewController: MainViewController
    var childCoordinators: [ Coordinator] = []
    
    var type: CoordinatorType {.home}

    func start() {
        mainviewController.viewModel = MainViewModel(coordinator: self)
        self.navigationController.pushViewController(mainviewController, animated: false)
    }
    

    
    
}
