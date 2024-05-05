//
//  RecentView.swift
//  GND
//
//  Created by 235 on 5/6/24.
//

import UIKit
class CellView: UIView {
    let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20,weight: .semibold)
    }
    let subtitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    let lastLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    let mapImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    override init(frame: CGRect) {
           super.init(frame: frame)
           setupViews()
       }
    required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    private func setupViews() {
            layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = .yellow
        [mapImageView, titleLabel, subtitleLabel, lastLabel].forEach {
            addSubview($0)
        }
            mapImageView.snp.makeConstraints { make in
                make.top.left.bottom.equalToSuperview().inset(8)
                make.width.equalTo(88)
            }

            titleLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(12)
                make.leading.equalTo(mapImageView.snp.trailing).offset(16)
            }

            subtitleLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(16)
                make.leading.equalTo(mapImageView.snp.trailing).offset(16)
            }

            lastLabel.snp.makeConstraints { make in
                make.top.equalTo(subtitleLabel.snp.bottom).offset(16)
                make.leading.equalTo(mapImageView.snp.trailing).offset(16)
                make.bottom.equalToSuperview().inset(12)
            }
        }

        func configure(with model: CellType) {
            model.configure(view: self)
        }
}
