//
//  UserAPI.swift
//  GND
//
//  Created by 235 on 5/6/24.
//

import Foundation
import Alamofire
enum UserAPI {
    case requestlogin(LoginRequest)
    case requestRefreshToken
    case requestSetuser(UserInfoDTO)
    case requestUpdateprofile
    case requestUpdatenickname
}
extension UserAPI: Router, URLRequestConvertible {
    var baseURL: String {
        return API.baseURL+"/api/"
    }
    var path: String {
        switch self {
        case .requestlogin:
            "auth/login"
        case .requestRefreshToken:
            "auth/refresh"
        case .requestSetuser:
            "user"
        case .requestUpdateprofile:
            "user/profile"
        case .requestUpdatenickname:
            "user/nickname"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestlogin:
                .post
        case .requestRefreshToken:
                .post
        case .requestSetuser:
                .post
        case .requestUpdateprofile:
                .put
        case .requestUpdatenickname:
                .put
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .requestlogin, .requestRefreshToken:
            API.headerWithoutToken
        default:
            API.headerwithAuthorization
        }
    }
    
    var parameters: Encodable? {
        switch self {
        case .requestlogin(let loginRequest):
           return loginRequest
        case .requestSetuser(let userDTO):
            return userDTO
        default:
            return nil
//        case .requestRefreshToken:
//            <#code#>

//        case .requestUpdateprofile:
//            <#code#>
//        case .requestUpdatenickname:
//            <#code#>
        }
    }
    
//    var encoding: ParameterEncoding? {
//        switch self {
//        case .requestlogin:
//            return JSONEncoding.default
//        default:
//            return JSONEncoding.default
//        }
//    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseURL + path)
        var request = URLRequest(url: url!)
        request.method = method
        request.headers = headers
        if let parameters = parameters {
            request = try JSONParameterEncoder().encode(parameters, into: request)
        }
        return request
    }


}
