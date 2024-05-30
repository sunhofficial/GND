//
//  CourseAPI.swift
//  GND
//
//  Created by 235 on 5/30/24.
//

import Foundation
import Alamofire

enum CourseAPI {
    case requestGetRecent(showCount: Int, nextCourseID: Int?)
}
extension CourseAPI: Router, URLRequestConvertible {
    var baseURL: String {
        return API.baseURL+"/api/course"
    }
    
    var path: String {
        switch self {
        case .requestGetRecent:
            "/mine"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .requestGetRecent:
                .get

        }
    }
    
    var headers: Alamofire.HTTPHeaders {
        switch self {
        case .requestGetRecent:
            return API.headerwithAuthorization
        }
    }
    
    var parameters:  Encodable? {
        switch self {
              case .requestGetRecent(let showCount, let nextCourseID):
                  return GetRecentRequest(showcount: showCount, nextcourseid: nextCourseID)
              }
    }
    
    func asURLRequest() throws -> URLRequest {
            let url = try baseURL.asURL().appendingPathComponent(path)
        var request = try URLRequest(url: url, method: method)
           request.headers = headers

           switch self {
           case .requestGetRecent:
               if let params = parameters {
                   let encodedparmas = try params.toDictionary()
                   request = try URLEncoding.default.encode(request, with: encodedparmas)
               }
           }

           return request
    }
    
    
}
