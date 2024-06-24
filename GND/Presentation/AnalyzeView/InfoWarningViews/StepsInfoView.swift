//
//  StepsInfoView.swift
//  GND
//
//  Created by 235 on 6/22/24.
//

import UIKit
final class StepsInfoView: UIView {
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
        $0.text = "걸음수의 증가가 미치는 영향"
    }
    let effectLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 22, weight: .semibold)
        $0.text = """
1. 비만을 피할수 있다.
2. 정신적 건강을 증진.
3. 뇌졸증 위험을 낮출수 있다.
4. 심혈관 건강에 좋다.
"""
        $0.numberOfLines = 0
    }
    let effetDetailLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.text = """
    하루 7천보이상만 걸으면 신체활동이 활발해져 심혈관 질환들을 피할 수 있고 사망의 위험도 낮출 수 있습니다.
"""
        $0.numberOfLines = 0
    }
    let alertLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 32, weight: .heavy)
        $0.text = """
    500보를 추가로 걸을 수록
    더 건강해집니다
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
