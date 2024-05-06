//
//  TabbarViewController.swift
//  GND
//
//  Created by 235 on 5/6/24.
//

import UIKit

final class TabbarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabbarAttributes()
        setTabbar()
    }
    func setTabbarAttributes() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = CustomColors.brown
        tabBar.unselectedItemTintColor = .systemGray
    }
    func setTabbar() {
        let mainView = UINavigationController(rootViewController: MainViewController())
        let partyView = UINavigationController(rootViewController: PartyView())
        mainView.tabBarItem = UITabBarItem(title: "산책하기", image: UIImage(systemName: "shoeprints.fill"), selectedImage: UIImage(systemName: "shoeprints.fill"))
        partyView.tabBarItem = UITabBarItem(title: "함께하기", image: UIImage(systemName: "person.3"), selectedImage: UIImage(systemName: "person.3.fill"))
        viewControllers = [mainView, partyView]
    }
}
