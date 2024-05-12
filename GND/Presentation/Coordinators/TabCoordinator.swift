//
//  TabCoordinator.swift
//  GND
//
//  Created by 235 on 5/12/24.
//

import UIKit

protocol TabCoordinatorProtocol: Coordinator {
    var tabbarController: UITabBarController {get set}

}
class TabCoordinator: TabCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [ Coordinator] = []
    var tabbarController: UITabBarController
    var type: CoordinatorType {.tab}

    func start() {
        
    }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabbarController = UITabBarController()
//        super.init()

    }
    

}
