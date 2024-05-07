//
//  NicknameViewController.swift
//  GND
//
//  Created by 235 on 5/5/24.
//

import UIKit

import Then
import SnapKit
import Combine

class NicknameViewController: UIViewController {
    private var cancellables: Set<AnyCancellable> = []
    var gender: Gender?
    var ageRange: AgeRange?
    let viewModel = NickNameViewModel()
    let titleLabel = UILabel().then {
        $0.text = "사용하실 닉네임을 알려주세요"
        $0.font = .systemFont(ofSize: 28, weight: .semibold)
        $0.textColor = .black
    }
    lazy var nicknameField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.backgroundColor = CustomColors.cell
        $0.textColor = .black
        $0.placeholder = "닉네임을 입력해주세요"
        $0.delegate = self
        $0.addLeftPadding()
    }
    let notiNicknameLabel = UILabel().then {
        $0.text = "닉네임은 8자 이하로 입력해주세요"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .systemGray
    }
    let nextButton = UIButton().then {
        $0.layer.cornerRadius = 15
        $0.setTitle("완료", for: .normal)
        $0.backgroundColor = CustomColors.brown
    }
    override func viewDidLoad() {
        view.backgroundColor = CustomColors.bk
        super.viewDidLoad()
        setUI()
        bindings()
    }
    private func bindings() {
        viewModel.outputs.isCompleteButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.nextButton.isEnabled = isValid
                self?.nextButton.backgroundColor = isValid ? CustomColors.brown : UIColor.lightGray
                               }.store(in: &cancellables)
    }
    private func setUI(){
        [titleLabel, nicknameField, notiNicknameLabel, nextButton].forEach {
            view.addSubview($0)
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(272)
        }
        nicknameField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
        notiNicknameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nicknameField.snp.bottom).offset(32)
        }
        nextButton.snp.makeConstraints {
            $0.width.equalTo(342)
            $0.height.equalTo(56)
            $0.top.equalTo(notiNicknameLabel.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
    }
}

extension NicknameViewController: UITextFieldDelegate {
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
