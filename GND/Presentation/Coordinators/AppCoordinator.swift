//
//  AppCoordinator.swift
//  GND
//
//  Created by 235 on 5/12/24.
//

import Foundation
import UIKit
protocol AppCoordinatorProtocol: Coordinator {
    func showLoginFlow()
    func showMainFlow()
}
final class AppCoordinator: AppCoordinatorProtocol {    
    weak var finishDelegate: CoordinatorFinishDelegate? = nil
    var navigationController: UINavigationController
    var type: CoordinatorType {.app}
    var childCoordinators =  [Coordinator]()
    var userusecase = UserUsecase(userReposiotry: UserRepository())
    var courseUsecase = CourseUseCase(courseRepository: CourseRepository())
    required init(_ navigationController: UINavigationController) {
         self.navigationController = navigationController
         navigationController.setNavigationBarHidden(true, animated: true)
     }
    func start() {
//        if let _ = KeychainManager.shared.readToken(key: "accessToken") {
//            showMainFlow()
//        } else {
//            showLoginFlow()
//        }
        showLoginFlow()
    }
    func showLoginFlow() {
//로그인에 관련한 코디네이터 생성하고 child에 추가
        let loginCoordinator = LoginCoordinator(navigationController)
        loginCoordinator.userusecase  = userusecase
        loginCoordinator.finishDelegate = self
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator)
    }
    func showMainFlow() {
//메인에 관련한 코디네이터 생성후 child추가
        let tabCoordinator = TabCoordinator(navigationController)
        tabCoordinator.userUsecase = userusecase
        tabCoordinator.courseUseCase = courseUsecase
        tabCoordinator.finishDelegate = self
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    // 해당 coordinator에서 finish할때 동일한 child coordinator제거, navigationController초기화 하고 새로운 coordinator 설정.
    func coordinatorDidFinish(childCoordinator:  Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != childCoordinator.type })
        self.navigationController.view.backgroundColor = .systemBackground
        self.navigationController.viewControllers.removeAll()
        switch childCoordinator.type {
        case .login:
            self.showMainFlow()
        case .tab:
            self.showLoginFlow()
        default:
            break
        }
    }
}
