//
//  StrideCoordinator.swift
//  GND
//
//  Created by 235 on 5/13/24.
//

import UIKit

protocol StrideCoordinatorProtocol: Coordinator {
    func doExerciseView()
    func showRecentView()
    func finishExerciseView()

}
class StrideCoordinator: StrideCoordinatorProtocol {
    func doExerciseView() {
        
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
        self.navigationController.pushViewController(mainviewController, animated: true)
    }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.mainviewController = MainViewController()
    }
    
    
}
