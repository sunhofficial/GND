//
//  LoginResponse.swift
//  GND
//
//  Created by 235 on 5/6/24.
//

import Foundation
struct LoginResponse: Decodable {
    let accessToken: String
    let refreshToken : String
    let needInitialization: Bool
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case needInitialization = "need_initialization"
    }
}
