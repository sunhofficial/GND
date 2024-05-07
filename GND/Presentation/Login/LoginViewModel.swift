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
//enum LoginType {
//    case initial
//    case success
//    case fail
//}
protocol LoginViewModelOutput {
    var appleLoginPublisher: PassthroughSubject< Bool, Error> { get }
}
//protocl
protocol LoginViewModelType: LoginViewModelInput, LoginViewModelOutput {
}
class LoginViewModel: NSObject, LoginViewModelType {
    private let userUseCase: UserUsecase
    var appleLoginPublisher = PassthroughSubject<Bool,  Error>()
    var kakaoLoginPublisher = PassthroughSubject<User, Error>()
    private var cancellables = Set<AnyCancellable>()
    private let kakaologinService = KakaoLoginServices()
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
        guard UserApi.isKakaoTalkLoginAvailable() else {
            print("카카오 앱이 안깔려있습니다.")
            return
        }
        // 카카오톡 설치 여부 확인
        kakaologinService.publishloginWithKakao()
            .flatMap { oauthToken in
                print(oauthToken)
                return self.kakaologinService.publishMe()
            }
            .flatMap { ownId in
                return self.userUseCase.userReposiotry.postLogin(Login(type: "kakao", id: ownId))
            }
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
                self.appleLoginPublisher.send(user.firstTime ? true : false)
            }.store(in: &self.cancellables)
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

                self.appleLoginPublisher.send(user.firstTime ? true : false)
            }.store(in: &self.cancellables)

        print(credential.user)

    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        appleLoginPublisher.send(completion: .failure(error))
//        appleLoginSubject.send(completion: .failure(error))
    }
}
