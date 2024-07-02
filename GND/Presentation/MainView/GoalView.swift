//
//  GoalView.swift
//  GND
//
//  Created by 235 on 6/27/24.
//

import Foundation
import UIKit
import SnapKit

final class GoalView: UIView {
    private let levelLabel = UILabel().then {
        $0.text = "오늘의 목표"
        $0.font = .systemFont(ofSize: 32, weight: .bold)
    }
    let expProgressView = UIProgressView(progressViewStyle: .default).then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.progress = 0.0 // 초기값을 명시적으로 설정
    }
    var levelImage = UIImageView()
    let meterGoalView = UIStackView()
    let speedGoalView = UIStackView()
    let distanceGoalView = UIStackView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViews() {
        self.layer.cornerRadius = 16
        self.backgroundColor = CustomColors.cell

        addSubview(levelLabel)
        addSubview(levelImage)
        addSubview(expProgressView)
        addSubview(meterGoalView)
        addSubview(speedGoalView)
        addSubview(distanceGoalView)

        let infoStack = UIStackView(arrangedSubviews: [meterGoalView, speedGoalView, distanceGoalView]).then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
        }
        addSubview(infoStack)

        levelLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
        }
        levelImage.snp.makeConstraints {
            $0.centerY.equalTo(levelLabel.snp.centerY)
            $0.leading.equalTo(levelLabel.snp.trailing).offset(4)
            $0.width.height.equalTo(40)
        }
        expProgressView.snp.makeConstraints {
            $0.centerY.equalTo(levelImage.snp.centerY)
            $0.leading.equalTo(levelImage.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(24)
        }
        infoStack.snp.makeConstraints {
            $0.top.equalTo(levelLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
    func updateGoalView(viewmodel: MainViewModel) {
        levelLabel.text = viewmodel.userLevel.title
        levelImage.image =  UIImage(named: viewmodel.userLevel.imageString)
        expProgressView.progress = Float(viewmodel.userGoal?.exp ?? 1) / 10.0
        expProgressView.trackTintColor = UIColor(named: viewmodel.userLevel.colorString)
        meterGoalView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        speedGoalView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        distanceGoalView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        meterGoalView.addArrangedSubview(makeGoalInfoView(current: viewmodel.userGoal?.todayStride ?? 0, goal: viewmodel.userGoal?.goalStride ?? 0, measure: "cm"))
        speedGoalView.addArrangedSubview(makeGoalInfoView(current: viewmodel.userGoal?.todaySpeed ?? 0.0, goal: viewmodel.userGoal?.goalSpeed ?? 0.0, measure: "km/h"))
        distanceGoalView.addArrangedSubview(makeGoalInfoView(current: viewmodel.userGoal?.todayStep ?? 0, goal: viewmodel.userGoal?.goalStep ?? 0, measure: "걸음"))
    }
    func makeGoalInfoView<T: Comparable>(current: T, goal: T, measure: String) -> UIStackView {
        let topLabel = UILabel().then {
            $0.text = "\(current)"
            $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            $0.textAlignment = .center
            $0.textColor = current < goal ? .red : .green
        }
        let bottomLabel = UILabel().then {
            $0.text = "/\n\(goal) \(measure)"
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            $0.textColor = .black
            $0.numberOfLines = 0
        }
        let stack = UIStackView(arrangedSubviews: [topLabel, bottomLabel]).then {
            $0.axis = .vertical
            $0.spacing = 0
        }
        return stack
    }
}
