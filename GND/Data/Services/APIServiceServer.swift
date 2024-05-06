////
////  LoginDatasource.swift
////  GND
////
////  Created by 235 on 5/6/24.
////
//
//import Foundation
//import Alamofire
//class APIServiceServer{
//    static let shared = APIServiceServer()
//    private let url = "http://gunilda-dev.kro.kr"
//
//}
//
//enum HTTPMethod: String {
//    case get = "GET"
//    case post = "POST"
//    case put = "PUT"
//    case delete = "DELETE"
//
//    var afMethod: Alamofire.HTTPMethod {
//        return Alamofire.HTTPMethod(rawValue: self.rawValue)
//    }
//}
//
//protocol RestApi {
//    var path: String { get }
//    var method: HTTPMethod { get }
//    var headers: HTTPHeaders { get }
//    func request<T: Decodable>(returnType: T.Type, completion: @escaping (Result<T, Error>) -> Void)
//
//}
//
//extension RestApi {
//    var headers: HTTPHeaders {
//        return [
//            "Content-Type": "application/json"
//        ]
//    }
//
//    func request<T: Decodable>(returnType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
//        let url = "\(API.baseURL.)/\(path)"
//
//        print(">>> Network Request \(method.rawValue):", url)
//
//        AF.request(url,
//                   method: method.afMethod,
//                   headers: headers)
//        .validate(statusCode: 200 ..< 300)
//        .responseDecodable(of: T.self) { response in
//            switch response.result {
//            case .success(let value):
//                completion(.success(value))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//}
