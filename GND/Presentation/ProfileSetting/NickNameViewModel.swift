//
//  NickNameViewModel.swift
//  GND
//
//  Created by 235 on 5/7/24.
//

import Foundation
import Combine
protocol NickNameViewModelInput {
//    var nickname: CurrentValueSubject<String, Never> { get }
    func didTapCompleteButton()
}
protocol NickNameViewModelOutput{
    var isCompleteButtonEnabled: AnyPublisher<Bool, Never> { get }
    var postPublisher: PassthroughSubject<Bool,  Error> {get}
}
protocol NickNameViewModelType: NickNameViewModelInput, NickNameViewModelOutput {
    var inputs: NickNameViewModelInput { get }
    var outputs: NickNameViewModelOutput {  get }
}
class NickNameViewModel: NickNameViewModelType {
//    var nickname = CurrentValueSubject<String, Never>("")
    var isCompleteButtonEnabled: AnyPublisher<Bool, Never> {
        $nickNameText
            .map {!$0.isEmpty && $0.count <= 8}
            .eraseToAnyPublisher()
    }
    var inputs: NickNameViewModelInput { return self }
    var outputs: NickNameViewModelOutput { return self }
    var postPublisher = PassthroughSubject<Bool,  Error>()
    @Published var nickNameText: String = ""
    private let userUseCase: UserUsecase
    var gender: String
    var age: String
    
    init(userUseCase: UserUsecase, gender: String, age: String) {
        self.userUseCase = userUseCase
        self.gender = gender
        self.age = age
    }
    func didTapCompleteButton() {
        userUseCase.postUserData(UserInfo(gender: gender, age: age, nickname: nickNameText))
            .sink(receiveCompletion: { completino in
                switch completino {
                case .finished:
                    print("ohyeah")
                case .failure(let failure):
                    print("ff")
                }
            }) { userinfo in
                print("유저")
                self.postPublisher.send(true)
            }
    }





}
