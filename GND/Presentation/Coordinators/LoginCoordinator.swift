//
//  LoginCoordinator.swift
//  GND
//
//  Created by 235 on 5/12/24.
//

import UIKit

protocol LoginCoordinatorProtocol: Coordinator {
    func showLoginViewController()
    func showProfileSettingViewController()
    func showNicknameViewController(gender: String, age: String)
}

class LoginCoordinator: LoginCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators = [ Coordinator]()
    var type: CoordinatorType {.login}
    var userusecase = UserUsecase(userReposiotry: UserRepository())
    func showLoginViewController() {
        let loginVC = LoginViewController()
        loginVC.viewModel = LoginViewModel(coordinator: self, userUseCase: userusecase)
        self.navigationController.viewControllers = [loginVC	]
    }
    
    func showProfileSettingViewController() {
        let profileSettingView = ProfileViewController()
        profileSettingView.viewmodel = ProfileViewModel(coordinator: self)
        self.navigationController.pushViewController(profileSettingView, animated: false)
    }
    
    func showNicknameViewController(gender: String, age: String) {
        let nicknameViewController = NicknameViewController()
        nicknameViewController.viewModel = NickNameViewModel(userUseCase: userusecase, gender: gender, age: age)
        self.navigationController.pushViewController(nicknameViewController, animated: true)
    }
    
    func start() {
        showLoginViewController()
    }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func finish() {
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
