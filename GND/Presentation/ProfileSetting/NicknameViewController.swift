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

    var viewModel: NickNameViewModel?
    let titleLabel = UILabel().then {
        $0.text = "사용하실 닉네임을 알려주세요"
        $0.font = .systemFont(ofSize: 28, weight: .semibold)
        $0.textColor = .black
    }
    lazy var nicknameField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.backgroundColor = CustomColors.cell
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.placeholder = "닉네임을 입력해주세요"
        $0.delegate = self
        $0.frame.size.height = 56
        $0.addLeftPadding()
        $0.setPlaceholderColor(.systemGray)
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
        hideKeyboard()
    }
    private func hideKeyboard() {
           let recognizer = UITapGestureRecognizer(target: self, action: #selector(tappedView))
           view.addGestureRecognizer(recognizer)
       }
    @objc private func tappedView() {
           self.view.endEditing(true)
       }
    @objc private func nextBtnTapped() {
        viewModel?.inputs.didTapCompleteButton()
            
    }
    private func bindings() {
        nextButton.addTarget(self, action: #selector(nextBtnTapped), for: .touchUpInside)
        nicknameField.publisher
                 .receive(on: RunLoop.main)
                 .assign(to: \.!.nickNameText, on: viewModel)
                 .store(in: &cancellables)
        viewModel!.outputs.isCompleteButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.nextButton.isEnabled = isValid
                self?.nextButton.backgroundColor = isValid ? CustomColors.brown : UIColor.lightGray
                               }.store(in: &cancellables)
        viewModel?.outputs.postPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { isSucceed in
                self.goNextView()
            })   .store(in: &cancellables)
    }
    private func goNextView() {
        navigationController?.pushViewController(TabbarViewController(), animated: true)
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
