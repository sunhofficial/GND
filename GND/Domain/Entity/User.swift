//
//  User.swift
//  GND
//
//  Created by 235 on 5/7/24.
//

import Foundation
struct User {
    var firstTime: Bool
    var jwtToken : Tokens
}
struct UserInfo {
    var gender: String
    var age: String
    var nickname: String
}
enum Gender: String {
    case male = "man"
    case female = "woman"
    case none
    var label: String {
        switch self {
        case .male:
            "남자"
        case .female:
            "여자"
        case .none:
            ""
        }
    }
}
struct Tokens {
    var accessToken: String
    var refreshToken: String
}
