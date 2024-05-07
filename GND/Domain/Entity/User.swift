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
struct Tokens {
    var accessToken: String
    var refreshToken: String
}
