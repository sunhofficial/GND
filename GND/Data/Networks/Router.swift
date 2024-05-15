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
    var headers: HTTPHeaders { get }
        var parameters: Encodable? { get }
//        var encoding: ParameterEncoding? { get }
}
