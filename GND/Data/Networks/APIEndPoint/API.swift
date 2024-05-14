//
//  config.swift
//  GND
//
//  Created by 235 on 5/6/24.
//

import Foundation
struct API {
    static let baseURL = "http://sonserver.duckdns.org"
    enum NetworkHeaderKey: String {
        case contentType = "Content-Type"
        case authorization = "Authorization"
    }
    static let applicationJSON = "application/json"
    static var headerwithoutToken = [
        NetworkHeaderKey.contentType.rawValue : API.applicationJSON ]
    static var headerwithAuthorization: [String:  String] =  [
        NetworkHeaderKey.contentType.rawValue: API.applicationJSON,
        NetworkHeaderKey.authorization.rawValue: "Bearer \(KeychainManager.shared.readToken(key: "accessToken") ?? "")"
    ]
}
