//
//  LoginRequest.swift
//  GND
//
//  Created by 235 on 5/6/24.
//

import Foundation
struct LoginRequest: Codable {
    var type: String
    var id: String
}
struct UserInfoDTO: Codable {
    var gender: String
    var age: String
    var nickname: String
    func toDomain() -> UserInfo {
        return .init(gender: gender, age: age, nickname: nickname)
    }
}
