//
//  GoalModal.swift
//  GND
//
//  Created by 235 on 6/9/24.
//

import UIKit
import Then
import SnapKit

enum GoalType {
    case first
    case levelup(nextLevel: UserLevel)
    
}
final class GoalModalView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = CustomColors.bk
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setDialogView()
    }
    var goal: ModalGoal?
    var goalType: GoalType = .first
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setDialogView() {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        let titleText = UILabel().then {
            $0.text = {
                switch self.goalType {
                case .first:
                    return "가입을 축하합니다!"
                case .levelup(let nextLevel):
                    return "축하합니다!"
                }
            }()
            $0.font = .systemFont(ofSize: 32)
        }
        let subTitleText = UILabel().then{
            $0.text = {
                switch self.goalType {
                case .first:
                    return "오늘의 목표를 달성해보세요!"
                case .levelup(let nextLevel):
                    if let previousLevel = UserLevel(rawValue: nextLevel.rawValue - 1) {
                        return "\(previousLevel.title) -> \(nextLevel.title)"
                    } else {
                        return "-> \(nextLevel.title)"
                    }
                }
            }()
            $0.font = .systemFont(ofSize: 24)
        }
        let goalText = UILabel().then {
            $0.text = {
                switch self.goalType {
                case .first:
                    return "현재 목표"
                case .levelup:
                    return "다음 목표"}
            }()
            $0.font = .systemFont(ofSize: 30)
        }
        let distanceGoalLabel = createGoalLabel(text: "보폭")
        let distanceGoalValue = createGoalValueLabel(text: "\(goal?.stride ?? 0) cm")

        let averageLabel = createGoalLabel(text: "평균속도")
        let averageGoalValue = createGoalValueLabel(text: "\(goal?.averageSpeed ?? 0) km/h")
        
        let strideGoalLabel = createGoalLabel(text: "걸음수")
        let strideGoalValue = createGoalValueLabel(text: "\(goal?.walkCount ?? 0) 걸음")
        let stackView = UIStackView(arrangedSubviews: [
            createStackView(arrangedSubviews: [distanceGoalLabel, distanceGoalValue]),
            createStackView(arrangedSubviews: [averageLabel, averageGoalValue]),
            createStackView(arrangedSubviews: [strideGoalLabel, strideGoalValue])
        ])
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        [closeButton, titleText,subTitleText,goalText,stackView].forEach {
            addSubview($0)
        }
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(8)
        }
        titleText.snp.makeConstraints {
            $0.top.equalToSuperview().offset(80)
            $0.centerX.equalToSuperview()
        }
        subTitleText.snp.makeConstraints {
            $0.top.equalTo(titleText.snp.bottom).offset(56)
            $0.centerX.equalToSuperview()
        }
        goalText.snp.makeConstraints {
            $0.top.equalTo(subTitleText.snp.bottom).offset(64)
            $0.centerX.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(goalText.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
    }
    private func createGoalLabel(text: String) -> UILabel {
        return UILabel().then {
            $0.text = text
            $0.font = .systemFont(ofSize: 20)
        }
    }
    
    private func createGoalValueLabel(text: String) -> UILabel {
        return UILabel().then {
            $0.text = text
            $0.font = .systemFont(ofSize: 24)
            $0.textColor = CustomColors.brown
        }
    }
    private func createStackView(arrangedSubviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }
    
}
#Preview {
    GoalModalView()
}
