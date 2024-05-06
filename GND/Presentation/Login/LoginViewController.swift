//
//  LoginView.swift
//  GND
//
//  Created by 235 on 5/4/24.
//

import UIKit
import Then
import AuthenticationServices
import Combine
import SnapKit

class LoginViewController: UIViewController {
    let titleLabel = UILabel().then{
        $0.text = "거닐다"
        $0.font = UIFont.systemFont(ofSize: 60)
        $0.textColor = CustomColors.brown
    }
    let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "logo.svg")
    }
    let kakaoLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "kakaoLogin.svg"), for: .normal)
    }
    let appleLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "appleLogin.svg"), for: .normal)
    }
    private var viewModel: LoginViewModel = LoginViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomColors.bk

        setupLayout()
        setLoginButton()
        bind()
    }
    func setupLayout(){
        self.view.addSubview(logoImageView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(kakaoLoginButton)
        self.view.addSubview(appleLoginButton)
        logoImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(70)
            make.top.equalToSuperview().inset(64)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(36)
        }
        kakaoLoginButton.snp.makeConstraints { make in
            make.width.equalTo(342)
                  make.height.equalTo(56)
            make.top.equalTo(titleLabel.snp.bottom).offset(61)
            make.centerX.equalToSuperview()
        }
        appleLoginButton.snp.makeConstraints { make in
            make.width.equalTo(342)
            make.height.equalTo(56)
             make.centerX.equalToSuperview()
             make.bottom.equalToSuperview().offset(-70) // 밑에서부터 70만큼의 여백
         }
    }
    private func setLoginButton() {
        appleLoginButton.addTarget(self, action: #selector(appleLoginTapped), for: .touchUpInside)
        kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginTapped), for: .touchUpInside)
    }

    @objc
    func kakaoLoginTapped() {
        viewModel.performKakaoLogin()
    }
    @objc
    func appleLoginTapped() {
        viewModel.performAppleLogin()
    }

    private func bind() {
        viewModel.appleLoginPublisher
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("피니쉬")
                    print(completion)
                    break
                case .failure:
                    print("삐용삐용")
                }
            } receiveValue: { [weak self] data in
                print(data)
                print("로그인성공")
            }.store(in: &cancellable)

    }
}
