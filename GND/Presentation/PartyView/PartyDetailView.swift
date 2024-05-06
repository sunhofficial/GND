//
//  PartyDetailView.swift
//  GND
//
//  Created by 235 on 5/6/24.
//

import UIKit

class PartyDetailView: UIViewController {
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 28, weight: .bold)
    }
    let mapImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavItems()
    }
    func setNavItems() {
        navigationItem.title = "함께 걷기"
        let plusbutton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addParty))
        navigationItem.rightBarButtonItem = plusbutton
    }
    @objc
    func addParty() {

    }
}
#Preview {
    let vc = UINavigationController( rootViewController: PartyDetailView())
    return vc
}
