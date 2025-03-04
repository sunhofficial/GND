//
//  TabCoordinator.swift
//  GND
//
//  Created by 235 on 5/12/24.
//

import UIKit

enum TabbarPages: CaseIterable {
    case main
    case together
    case analyze

    var defaultIcon: String {
        switch self {
        case .main:
            "shoeprints.fill"
        case .together:
            "person.3"
        case .analyze:
            "chart.bar"
        }
    }
    var onIcon: String {
        switch self {
        case .main:
            "shoeprints.fill"
        case .together:
            "person.3.fill"
        case .analyze:
            "chart.bar.fill"
        }
    }
    var title: String {
        switch self {
        case .main:
            "산책"
        case .together:
            "함께하기"
        case .analyze:
            "분석"
        }
    }

}
protocol TabCoordinatorProtocol:  Coordinator {
    var tabbarController: UITabBarController {get set}

}
class TabCoordinator: NSObject, TabCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [ Coordinator] = []
    var tabbarController: UITabBarController
    var type: CoordinatorType {.tab}
    var userUsecase: UserUsecase?
    var courseUseCase: CourseUseCaseProtocol?
    private var isFirst: Bool
    private let dependencyContainer = DIContainer.shared

    func start() {
        let pages: [TabbarPages] = TabbarPages.allCases
        let controllers: [UINavigationController] = pages.map ({
            self.createTabbarNavigation($0)
        })
        configureTabBar(with: controllers)
    }
    func createTabbarNavigation(_ page: TabbarPages) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        tabNavigationController.setNavigationBarHidden(false, animated: false)
        tabNavigationController.tabBarItem = UITabBarItem(title: page.title, image: UIImage(systemName: page.defaultIcon), selectedImage: UIImage(systemName: page.onIcon))
        self.startTabCoordinator(of: page, to: tabNavigationController)
        return tabNavigationController
    }
    private func configureTabBar(with tabViewControllers: [UIViewController]) {
        self.tabbarController.setViewControllers(tabViewControllers, animated: true)
        self.tabbarController.view.backgroundColor = .systemBackground
        self.tabbarController.tabBar.backgroundColor = .systemBackground
        self.tabbarController.tabBar.tintColor = UIColor.black
        self.navigationController.pushViewController(self.tabbarController, animated: true)

    }
    required init(_ navigationController: UINavigationController, isFirst: Bool) {
        self.navigationController = navigationController
        self.tabbarController = UITabBarController()
        self.isFirst = isFirst
        super.init()
        self.tabbarController.delegate = self
    }
    private func startTabCoordinator(of page: TabbarPages, to tabNavigationController: UINavigationController) {
        switch page {
        case .main:
            let strideCoordinator = StrideCoordinator(
                          navigationController: tabNavigationController,
                          userUseCase: dependencyContainer.provideUserUseCase(),
                          courseUseCase: dependencyContainer.provideCourseUseCase(),
                          isFirst: isFirst
                      )
            childCoordinators.append(strideCoordinator)
            strideCoordinator.start()
//            navigationController.pushViewController(strideCoordinator, animated: true)

        case .together:
            let togetherCoordinator = TogetherCoordinator(tabNavigationController)
            childCoordinators.append(togetherCoordinator)
            togetherCoordinator.start()
        case .analyze:
            let anlayzeVc = AnalyzeViewController()
            tabNavigationController.viewControllers = [anlayzeVc]
        }
    }

}
extension TabCoordinator:  UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let selectedVC = tabBarController.selectedViewController,
           selectedVC == viewController {
            return false
        }
        return true
    }
}
