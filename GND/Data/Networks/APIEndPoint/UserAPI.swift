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
        case .requestlogin(let loginRequest):
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
        case .requestlogin(let loginRequest):
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
    
    var headers: [String : String] {
        switch self {
        case .requestlogin, .requestRefreshToken:
            API.headerwithoutToken
        default:
            API.headerwithAuthorization
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .requestlogin(let loginRequest):
            return ["type": loginRequest.type,
                    "id": loginRequest.id]
        case .requestSetuser(let userDTO):
            return ["gender": userDTO.gender,
                    "age": userDTO.age,
                    "nickname": userDTO.nickname]
        default:
            return [:]
//        case .requestRefreshToken:
//            <#code#>

//        case .requestUpdateprofile:
//            <#code#>
//        case .requestUpdatenickname:
//            <#code#>
        }
    }
    
    var encoding: ParameterEncoding? {
        switch self {
        case .requestlogin:
            return JSONEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseURL + path)
        var request = URLRequest(url: url!)
        request.method = method
        request.headers = HTTPHeaders(headers)
        if let encoding = encoding {
            return try encoding.encode(request, with: parameters)
        }
        return request
    }


}
