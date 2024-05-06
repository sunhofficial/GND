//
//  Router.swift
//  GND
//
//  Created by 235 on 5/6/24.
//

import Alamofire

protocol Router {
    var baseURL: String {get}
    var path: String {get}
    var method: HTTPMethod {get}
    var headers: [String: String] { get }
        var parameters: [String: Any]? { get }
        var encoding: ParameterEncoding? { get }
}
