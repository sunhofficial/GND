//
//  UserRepositoryProtocol.swift
//  GND
//
//  Created by Sunho on 2/17/25.
//

import Combine

protocol UserRepositoryProtocol {
    func postLogin(_ login: Login) -> AnyPublisher<User, Error>
    func postUserData(_ info: UserInfo) -> AnyPublisher<UserInfo, Error>
    func getTodayGoal() -> AnyPublisher<UserGoal, Error>
}
