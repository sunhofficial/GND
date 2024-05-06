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
    private let userUseCase: UserUsecase
    var appleLoginPublisher = PassthroughSubject<String, any Error>()
    var kakaoLoginPublisher = PassthroughSubject<User, Error>()
    private var cancellables = Set<AnyCancellable>()
    @Published var user: User? {
        didSet {
            print(user)
        }
    }
    init(userUseCase: UserUsecase) {
          self.userUseCase = userUseCase
          super.init()
      }
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
                    print(oauthToken)
                    self.userUseCase.userReposiotry.postLogin(Login(type: "kakao", id: (oauthToken?.idToken)!))
                        .receive(on: DispatchQueue.main)
                        .sink { completion in
                            switch completion {
                            case .failure(let err):
                                print(err)
                            case .finished:
                                print("fin")
                            }
                        } receiveValue: { user in
                            self.user = user
                            self.appleLoginPublisher.send("카톡성공")
                        }.store(in: &self.cancellables)
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
        userUseCase.userReposiotry.postLogin(Login(type: "apple", id: credential.user))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print(err)
                case .finished:
                    print("fin")
                }
            } receiveValue: { user in
                self.user = user
                self.appleLoginPublisher.send("애플로그인성공")
            }.store(in: &self.cancellables)

        print(credential.user)

    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        appleLoginPublisher.send(completion: .failure(error))
//        appleLoginSubject.send(completion: .failure(error))
    }
}
