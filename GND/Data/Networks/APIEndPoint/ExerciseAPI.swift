//
//  ExerciseAPI.swift
//  GND
//
//  Created by 235 on 5/15/24.
//

import Foundation
import Alamofire

enum ExerciseAPI {
    case requestGoal
    case requestSaveExercise(SaveExerciseRequest )
    case requestStrideStats(AnalyzeDataRequest)
    case requestspeedStats(AnalyzeDataRequest)
    case requestStepStats(AnalyzeDataRequest)
    //    case request

}

extension ExerciseAPI: Router,  URLRequestConvertible {


    var baseURL: String {
        return API.baseURL + "/api/exercise"
    }

    var path: String {
        switch self {
        case .requestGoal:
            "/goal"
        case .requestSaveExercise:
            ""
        case .requestStrideStats:
            "/stats/stride"
        case .requestspeedStats:
            "/stats/speed"
        case .requestStepStats:
            "/stats/step"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .requestGoal:
                .get
        case .requestSaveExercise:
                .post
        default:
                .get

        }
    }

    var headers: HTTPHeaders {
        switch self {
        default:
            API.headerwithAuthorization
        }
    }

    var parameters: Encodable? {
        switch self {
        case .requestGoal:
            return  nil
        case .requestSaveExercise(let exerciseData):
            return exerciseData
        case .requestStepStats(let data):
            return data
        case .requestStrideStats(let requestdata):
            return requestdata
        case .requestspeedStats(let requestData):
            return requestData
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url: URL
        if path != "" {
             url = try baseURL.asURL().appendingPathComponent(path)
        } else {
             url = URL(string: baseURL)!
        }

        var request = try URLRequest(url: url, method: method, headers: headers)
        switch self {
        case .requestGoal:
            break
        case .requestSaveExercise:
            if let parameters = parameters {
                request = try JSONParameterEncoder().encode(parameters, into: request)
            }
        case .requestspeedStats, .requestStepStats,.requestStrideStats:
            if let parameters = parameters {
                var urlComponents = URLComponents(string: url.absoluteString)!

                urlComponents.queryItems = try parameters.toDictionary().map { URLQueryItem(name: $0.key, value: "\($0.value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)) }
//
                // URL 쿼리 매개변수 중 "+"를 "%2B"로 인코딩
                if let query = urlComponents.url?.absoluteString.replacingOccurrences(of: "+", with: "%2B") {
                    request.url = URL(string: query)
                }
            }

        }

        return request
    }


}
