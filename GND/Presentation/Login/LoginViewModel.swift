//
//  LoginViewModel.swift
//  GND
//
//  Created by 235 on 5/4/24.
//

import Foundation
import Combine
import AuthenticationServices
import KakaoSDKUser

protocol LoginViewModelInput {
    func performAppleLogin()
    func performKakaoLogin()
}

protocol LoginViewModelOutput {
    var appleLoginPublisher: PassthroughSubject< String, Error> { get }
}
//protocl
protocol LoginViewModelType: LoginViewModelInput, LoginViewModelOutput {
}
class LoginViewModel: NSObject, LoginViewModelType {

    var appleLoginPublisher = PassthroughSubject<String, any Error>()
    override init() {
        super.init()
    }
//    var input: LoginViewModelInput { return self }
//    var output: LoginViewModelOutput { return self }
    func performAppleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    func performKakaoLogin() {
        // 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("카카오 로그인 성공")
                    print(oauthToken)
                    _ = oauthToken
                }
            }
        }
    }
}

extension LoginViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("No windows available")
        }
        return window
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {return}
        print(credential.user)
        appleLoginPublisher.send("애플로그인성공")
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        appleLoginPublisher.send(completion: .failure(error))
//        appleLoginSubject.send(completion: .failure(error))
    }
}
