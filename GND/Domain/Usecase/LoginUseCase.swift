//
//  LoginUseCase.swift
//  GND
//
//  Created by 235 on 5/6/24.
//

import Combine
protocol UserUseCaseProtocol {
    func requestLogin(_ loginData: Login) -> AnyPublisher<User, Error>
}
class UserUsecase: UserUseCaseProtocol {

    
//    var userDa
    var userReposiotry: UserRepositoryProtocol
    init(userReposiotry: UserRepositoryProtocol) {
        self.userReposiotry = userReposiotry
    }
    func requestLogin(_ loginData: Login) -> AnyPublisher<User, Error> {
        return userReposiotry.postLogin(loginData)
    }
}
