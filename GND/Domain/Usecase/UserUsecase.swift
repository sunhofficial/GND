//
//  LoginUseCase.swift
//  GND
//
//  Created by 235 on 5/6/24.
//

import Combine
protocol UserUseCaseProtocol {
    func requestLogin(_ loginData: Login) -> AnyPublisher<User, Error>
    func postUserData(_ info: UserInfo) -> AnyPublisher<UserInfo, Error>
    func getUserGoal() -> AnyPublisher<UserGoal, Error>
}
class UserUsecase: UserUseCaseProtocol {

    var userReposiotry: UserRepositoryProtocol
    init(userReposiotry: UserRepositoryProtocol) {
        self.userReposiotry = userReposiotry
    }
    func requestLogin(_ loginData: Login) -> AnyPublisher<User, Error> {
        return userReposiotry.postLogin(loginData)
    }
    func postUserData(_ info: UserInfo) -> AnyPublisher<UserInfo, Error> {
        return userReposiotry.postUserData(info)
    }
    func getUserGoal() -> AnyPublisher<UserGoal, Error> {
        return userReposiotry.getTodayGoal()
    }
}
