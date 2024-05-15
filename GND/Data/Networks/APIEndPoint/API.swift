//
//  config.swift
//  GND
//
//  Created by 235 on 5/6/24.
//

import Foundation
import Alamofire

struct API {
    static let baseURL = "http://sonserver.duckdns.org"
    enum NetworkHeaderKey: String {
        case contentType = "Content-Type"
        case authorization = "Authorization"
    }
    static let applicationJSON = "application/json"
    static var headerWithoutToken: HTTPHeaders {
          return [
            NetworkHeaderKey.contentType.rawValue : applicationJSON
          ]
      }
    static var headerwithAuthorization: HTTPHeaders =  [
        NetworkHeaderKey.contentType.rawValue: API.applicationJSON,
        NetworkHeaderKey.authorization.rawValue: "Bearer \(KeychainManager.shared.readToken(key: "accessToken") ?? "")"
    ]
}
