//
//  SpeedInfoVIew.swift
//  GND
//
//  Created by 235 on 6/22/24.
//

import UIKit
final class SpeedInfoVIew: UIView {
    let feedbackLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textColor = .black
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let effectTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 32, weight: .bold)
        $0.text = "걸음속도 증가 효과"
    }
    let effectLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 22, weight: .semibold)
        $0.text = """
1. BMI가 정상에 가까워진다.
2. 인지 기능이 좋아진다.
3. 근력 유지 및 관절 건강에 좋다.
4. 심부전 위험도가 줄어든다.
"""
        $0.numberOfLines = 0
    }
    let effetDetailLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.text = """
   한국사람이 외국사람들보다 BMI와 인지기능이 좋은 이유는 걸음에서부터 시작됩니다. 한국 노인의 평균 보행속도가 1.06m/s, 외국 노인은 0.8m/s로 차이가 발생하였습니다.
"""
        $0.numberOfLines = 0
    }
    let alertLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 32, weight: .heavy)
        $0.text = """
      24%, 걸음속도를 높이면
    줄어드는 사망률입니다.
    """
        $0.textColor =  .red
        $0.textAlignment = .center

        $0.numberOfLines = 0
    }
    private func setUI() {
        [feedbackLabel,effectTitleLabel,effectLabel,effetDetailLabel,alertLabel].forEach {
            addSubview($0)
        }
        feedbackLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        effectTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(56)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        effectLabel.snp.makeConstraints {
            $0.top.equalTo(effectTitleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        effetDetailLabel.snp.makeConstraints {
            $0.top.equalTo(effectLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        alertLabel.snp.makeConstraints {
            $0.top.equalTo(effetDetailLabel.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
    }
}
