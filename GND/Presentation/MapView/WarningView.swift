//
//  WarningView.swift
//  GND
//
//  Created by 235 on 5/20/24.
//

import UIKit
import SnapKit
import Then

final class WarningView: UIView {
    var warningTitle = UILabel().then {
        $0.font = .systemFont(ofSize: 64 ,weight: .bold)
        $0.textColor = .white
    }
    var warningDescription = UILabel().then {
        $0.font = .systemFont(ofSize: 32, weight: .bold)
        $0.textColor = .white
    }
    private var touchImage = UIImageView(image: UIImage(named: "touchFinger"))
    private var noticeText = UILabel().then {
        $0.font = .systemFont(ofSize: 40, weight: .semibold)
        $0.textColor = .white
        $0.text = "확인했다면\n클릭해주세요"
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func handleTap() {
        removeFromSuperview()
    }
    private func setupUI() {
        backgroundColor = .red
        [warningTitle, warningDescription, touchImage, noticeText].forEach {
            addSubview($0)
        }
        warningTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(188)
        }
        warningDescription.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(warningTitle.snp.bottom).offset(100)
        }
        touchImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(warningDescription.snp.bottom).offset(32)
        }
        noticeText.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(touchImage.snp.bottom).offset(32)
        }
    }
}
