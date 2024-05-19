//
//  SetCourseTitleModal.swift
//  GND
//
//  Created by 235 on 5/19/24.
//

import UIKit
import SnapKit
import Then

final class SetCourseTitleModal: UIView {
    let titleCourse = UILabel().then {
        $0.text = "코스이름을 입력해주세요"
        $0.font = .systemFont(ofSize: 24, weight: .bold)
    }

    lazy var courseTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.backgroundColor = .white
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.placeholder = "ex) 동작 노인정 주변길"
        $0.delegate = self
        $0.frame.size.height = 56
        $0.addLeftPadding()
        $0.setPlaceholderColor(.systemGray)
    }
    let addButton = UIButton().then {
        $0.setTitle("입력", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = CustomColors.brown
    }
    let outButton = UIButton().then {
        $0.setImage(.init(systemName: "xmark"), for: .normal)
        $0.tintColor = .systemGray
    }
    var onAddButtonTapped: ((String) -> Void)?
    var onOutButtonTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        backgroundColor = CustomColors.bk
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUI() {
        [titleCourse, courseTextField, addButton, outButton].forEach {
            addSubview($0)
        }
        titleCourse.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.top.equalToSuperview().offset(16)
        }
        outButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalTo(titleCourse.snp.centerY)
            $0.width.height.equalTo(24)
        }
        courseTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.top.equalTo(titleCourse.snp.bottom).offset(24)
            $0.trailing.equalToSuperview().inset(16)
        }
        addButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
            $0.top.equalTo(courseTextField.snp.bottom).offset(16)
            $0.width.equalTo(88)
            $0.height.equalTo(40)
        }
    }
}
extension SetCourseTitleModal: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing: \((textField.text) ?? "Empty")")
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing: \((textField.text) ?? "Empty")")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn \((textField.text) ?? "Empty")")

        textField.resignFirstResponder()
        return true

    }
}
#Preview {
    SetCourseTitleModal()
}
