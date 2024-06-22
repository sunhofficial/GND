//
//  StrideInfoView.swift
//  GND
//
//  Created by 235 on 6/22/24.
//

import UIKit
import Then
import SnapKit

final class StrideInfoView: UIViewController {
    let feedbackLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textColor = .black
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    let effectTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 32, weight: .bold)
        $0.text = "보폭이 커지면 생기는 효능"
    }
    let effectLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .medium)
        $0.text = """
    1. 치매를 예방할 수 있다.
    2. 낙상 예방할 수 있다.
    3. 근력 유지 및 관절 건강에 도움을 준다.
    4. 심혈관 건강에 좋다.
"""
        $0.numberOfLines = 0
    }
    let effetDetailLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.text = """
    넓은 보폭은 근육과 관절의 움직임을 더 촉진시켜 더 안정적인 걸음을 유지하게 하고 혈액 순환을 개선시켜 심혈관 질환을 예방하고 뇌로 가는 혈류 증가를 통해 치매도 예방합니다.
"""
        $0.numberOfLines = 0
    }
    let alertLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 32, weight: .heavy)
        $0.text = """
    사소한 수 cm의 보폭이
    인생을 바꾸는 첫걸음입니다
    """
        $0.textColor =  .red
    }
    private func setUI() {
        feedbackLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        effectTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(56)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        effectLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
