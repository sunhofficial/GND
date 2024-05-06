//
//  PartyDetailCell.swift
//  GND
//
//  Created by 235 on 5/6/24.
//

import UIKit
class PartyDetailCell: UICollectionViewCell {
    static let id = "PartyDetailCell"
    let meetTimeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .semibold)
    }
    let participantLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
    }
    let joinIconButton = UIButton().then {
        $0.setImage(UIImage(systemName: "calendar.badge.checkmark"), for: .normal)
        $0.backgroundColor = .white
    }
    let shareIconButton = UIButton().then {
        $0.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        $0.backgroundColor = .white

    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        backgroundColor = UIColor(red: 0.55, green: 0, blue: 0, alpha: 1.0) // Adjust color as needed
            layer.cornerRadius = 10
            contentView.layer.cornerRadius = 10
            contentView.layer.masksToBounds = true

            contentView.addSubview(meetTimeLabel)
            contentView.addSubview(participantLabel)
            contentView.addSubview(joinIconButton)
            contentView.addSubview(shareIconButton)
//        meetTimeLabel.snp.makeConstraints {
//
//        }
    }
}
