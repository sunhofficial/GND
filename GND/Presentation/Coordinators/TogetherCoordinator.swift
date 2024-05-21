//
//  TogetherCoordinator.swift
//  GND
//
//  Created by 235 on 5/13/24.
//

import UIKit

protocol TogetherCoordinatorProtocol: Coordinator {
    func walkAlone()
    func walktogether()
    func makeRoom()
    func joinRoom()
}
final class TogetherCoordinator: TogetherCoordinatorProtocol {
    func walkAlone() {

    }

    func walktogether() {

    }

    func makeRoom() {

    }

    func joinRoom() {

    }

    weak var finishDelegate: CoordinatorFinishDelegate?

    var navigationController: UINavigationController

    var childCoordinators: [Coordinator] = []

    var type: CoordinatorType {.party}

    func start() {
        let togetherViewController = PartyViewController()
        navigationController.pushViewController(togetherViewController, animated: true)
    }

    required init(_ navigationController: UINavigationController) {
        self.navigationController  = navigationController
    }
}
