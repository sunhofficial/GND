//
//  ProfileSettingViewController.swift
//  GND
//
//  Created by 235 on 5/4/24.
//

import UIKit
import SnapKit
import Then
enum Gender: String {
    case male = "남자"
    case female = "여자"
    case none
}
enum AgeRange: Int, CaseIterable {
    case under50
    case from50to55
    case from55to60
    case from60to70
    case from70to80
    case above80
    var label: String {
        switch self {
        case .under50:
            "50세 이하"
        case .from50to55:
            "50-55세"
        case .from55to60:
            "55-60세"
        case .from60to70:
            "60-70세"
        case .from70to80:
            "70-80세"
        case .above80:
            "80세 이상"
        }
    }
}

class ProfileViewController: UIViewController {
    let profileTitleLabel = UILabel().then {
        $0.text = "성별 / 연령대를 알려주세요"
        $0.font = UIFont.systemFont(ofSize: 32,weight: .bold)
    }
    let profilesubscriptionLabel = UILabel().then {
        $0.text = "나이와 성별을 통해 정확한 피드백을 제공할 수 있습니다.\n 귀하의 개인 정보는 안전하게 보호됩니다."
        $0.font = UIFont.systemFont(ofSize: 15, weight: .thin)
    }
    let genderLabel = UILabel().then {
        $0.text = "성별을 선택해주세요"
        $0.font =   UIFont.systemFont(ofSize: 24, weight: .medium)
    }
    let ageLabel = UILabel().then {
        $0.text = "연령대를 골라주세요"
        $0.font =   UIFont.systemFont(ofSize: 24, weight: .medium)
    }
    let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = CustomColors.brown
        $0.layer.cornerRadius = 15
    }
    var manGenderView: UIView?
    var womanGenderView: UIView?
    var selectedGender: Gender = .none {
        didSet {
            updateUI()
        }
    }
    var ageButtons: [UIButton] = []
    var selectedAgeButton: UIButton?
    let ageRanges = ["50세 이하", "50-55세", "55-60세", "60-70세", "70-80세", "80세 이상"]

    override func viewDidLoad() {
        view.backgroundColor = CustomColors.bk
        navigationController?.isNavigationBarHidden = true
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        [profileTitleLabel, profilesubscriptionLabel, genderLabel, ageLabel,  nextButton].forEach{
            view.addSubview($0)
        }
        profileTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(64)
            $0.leading.equalToSuperview().offset(16)

        }
        profilesubscriptionLabel.snp.makeConstraints {
            $0.top.equalTo(profileTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)

        }
        genderLabel.snp.makeConstraints {
            $0.top.equalTo(profilesubscriptionLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)

        }
        setGenderStack()
        setupAgeButtons()
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview().inset(24 )
            $0.height.equalTo(56)
        }
    }
    func setGenderStack() {
        let genderChoiceView = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .equalSpacing
            $0.spacing = 64
        }
        manGenderView = createGenderView("manIcon", "남자", tag: 0)
        womanGenderView = createGenderView("girlicon", "여자", tag: 1)
        [manGenderView, womanGenderView].compactMap { $0 }.forEach {
            genderChoiceView.addArrangedSubview($0)
        }
        view.addSubview(genderChoiceView)
        genderChoiceView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.top.equalTo(genderLabel.snp.bottom).offset(16)
        }
        ageLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)

            $0.top.equalTo(genderChoiceView.snp.bottom).offset(40)
        }

    }
}

extension ProfileViewController {
    private func createGenderView(_ imageName: String, _ text: String, tag: Int) -> UIView {
        let genderView = UIView()
        genderView.tag = tag
        let logoView = UIImageView(image: UIImage(named: imageName))
        logoView.contentMode = .scaleAspectFit
        logoView.snp.makeConstraints { $0.size.equalTo(CGSize(width: 40, height: 80)) }
        let genderTextLabel = UILabel().then {
            $0.text = text
            $0.font = UIFont.systemFont(ofSize: 32, weight: .medium)
            $0.textColor = CustomColors.brown
        }
        let vStackView = UIStackView().then {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 8
            $0.addArrangedSubview(logoView)
            $0.addArrangedSubview(genderTextLabel)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(genderViewTapped))
        genderView.addGestureRecognizer(tapGesture)
        genderView.addSubview(vStackView)
        genderView.layer.cornerRadius = 66
        genderView.layer.borderColor = CustomColors.brown.cgColor
        genderView.layer.borderWidth = 2 // Add border width
        genderView.clipsToBounds = true
        vStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
        }
        genderView.snp.makeConstraints {
            $0.size.equalTo(132)
        }
        return genderView
    }
    @objc private func genderViewTapped(sender: UITapGestureRecognizer) {
        guard sender.view != nil else {return }
        guard let view = sender.view else { return }
        selectedGender = (view.tag == 1) ? .female : .male
    }
    private func updateUI() {
        // 모든 성별 뷰의 UI 업데이트
        let genderViews = [manGenderView, womanGenderView]
        for genderView in genderViews {
            if let stackView = genderView?.subviews.first as? UIStackView {
                stackView.arrangedSubviews.compactMap { $0 as? UILabel }.forEach { label in
                    label.textColor = (genderView == (selectedGender == .male ? manGenderView : womanGenderView)) ? .white : CustomColors.brown
                }
                genderView?.backgroundColor = (genderView == (selectedGender == .male ? manGenderView : womanGenderView)) ? CustomColors.brown : .clear
            }
        }
    }
    func setupAgeButtons() {
        let grid = UIStackView().then {
            $0.axis = .vertical
            //            $0.distribution = .fillEqually
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.spacing = 32
        }

        let column1 = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 16
        }

        let column2 = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 16
        }
        AgeRange.allCases.forEach { ageRange in
            let button = UIButton().then {
                $0.setTitle(ageRange.label, for: .normal)
                $0.setTitleColor(CustomColors.brown, for: .normal)
                $0.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
                $0.backgroundColor = .clear
                $0.layer.cornerRadius = 16
                $0.layer.borderWidth = 1
                $0.layer.borderColor = CustomColors.brown.cgColor
                $0.addTarget(self, action: #selector(ageButtonTapped(_:)), for: .touchUpInside)
                $0.snp.makeConstraints { make in
                    make.height.equalTo(104)
                }
            }
            if ageRange.rawValue <= 2 {
                column1.addArrangedSubview(button)
            } else {
                column2.addArrangedSubview(button)
            }
        }

        grid.addArrangedSubview(column1)
        grid.addArrangedSubview(column2)
        view.addSubview(grid)
        grid.snp.makeConstraints { make in
            make.top.equalTo(ageLabel.snp.bottom ).offset(24)  // Adjust as needed
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }

    @objc private func ageButtonTapped(_ sender: UIButton) {
        selectedAgeButton?.backgroundColor = .clear
        selectedAgeButton?.setTitleColor(CustomColors.brown, for: .normal)

        sender.backgroundColor = CustomColors.brown
        sender.setTitleColor(.white, for: .normal)

        selectedAgeButton = sender
    }

}
