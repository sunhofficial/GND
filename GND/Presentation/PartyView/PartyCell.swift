//
//  PartyCell.swift
//  GND
//
//  Created by 235 on 5/6/24.
//

import UIKit
import Then
import SnapKit

class PartyCell: UICollectionViewCell {
    static let id = "PartyCell"

    let mapImage =  UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    let participantCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
    }
    let distanceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }
    let aloneButton = UIButton().then {
        $0.setTitle("혼자 산책", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
//        $0.layer.borderColor = CGColor.black

    }
    let withButton = UIButton().then {
        $0.setTitle("함께 걷기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        $0.layer.cornerRadius = 8
        $0.setTitleColor(.black, for: .normal)
        $0.layer.borderWidth = 1
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.borderWidth = 1
        setUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUI() {
        [mapImage, titleLabel, participantCountLabel, distanceLabel, withButton, aloneButton].forEach{
            contentView.addSubview($0)
        }
        mapImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.height.equalTo(124)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(mapImage.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        participantCountLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            
        }
        distanceLabel.snp.makeConstraints {
            $0.top.equalTo(participantCountLabel.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(16)
        }
        aloneButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalTo(67)
            $0.height.equalTo(40)
            $0.top.equalTo(distanceLabel.snp.bottom).offset(8)
        }
        withButton.snp.makeConstraints {

            $0.width.equalTo(67)
            $0.height.equalTo(40)
            $0.top.equalTo(distanceLabel.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(10)
        }
    }
    func configure(_ partyModel : PartyModel) {
        mapImage.image = UIImage(named: partyModel.mapImageString)
        titleLabel.text = partyModel.partyTitle
        participantCountLabel.text = "\(partyModel.participantCount)명 참여중"
        distanceLabel.text = "􀎫 \(partyModel.distance)km"
    }
}
#Preview
{
    let vc = PartyCell()
    vc.configure(PartyModel(mapImageString: "logo", partyTitle: "경희대 산책길", participantCount: 10, distance: 34))
    return vc
}
