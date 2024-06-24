//
//  ExerciseRepository.swift
//  GND
//
//  Created by 235 on 5/15/24.
//

import Alamofire
import Combine
import Foundation

protocol ExerciseRepositoryProtocol {

    func postSaveExercise(_ exerciseSession: ExerciseSession, exerciseMetrics: ExerciseMetrics) -> AnyPublisher<Bool,  Error>
    func getAnalyzeSpeed(type: DropRange, startDate: String, endDate: String)-> AnyPublisher<AnalzyeDateResponse<AnalyzeSpeedData>, Error>
    func getAnalyzeStride(type: DropRange, startDate: String, endDate: String) -> AnyPublisher<AnalzyeDateResponse<AnalyzeStrideData>, Error>
    func getAnalyzeSteps(type: DropRange, startDate: String, endDate: String) -> AnyPublisher<AnalzyeDateResponse<AnalyzeStepData>, Error>
}

class ExerciseRepository: ExerciseRepositoryProtocol {
    func getAnalyzeStride(type: DropRange, startDate: String, endDate: String) -> AnyPublisher<AnalzyeDateResponse<AnalyzeStrideData>, any Error> {
        return Future<AnalzyeDateResponse<AnalyzeStrideData>, Error> { promise in
            let requestStride = AnalyzeDataRequest(type: type, startDate: startDate, endDate: endDate)
            AF.request(ExerciseAPI.requestStrideStats(requestStride))
                .response { res in debugPrint(res)}
                .responseDecodable(of: AnalzyeDateResponse<AnalyzeStrideData>.self) { response in
                    switch response.result {
                    case .success(let analyzeDateResponse):
                        promise(.success(analyzeDateResponse))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }.eraseToAnyPublisher()
        }

    
    func getAnalyzeSteps(type: DropRange, startDate: String, endDate: String) -> AnyPublisher<AnalzyeDateResponse<AnalyzeStepData>, any Error> {
        return Future<AnalzyeDateResponse<AnalyzeStepData>, Error> { promise in
            let requestStride = AnalyzeDataRequest(type: type, startDate: startDate, endDate: endDate)
            AF.request(ExerciseAPI.requestStepStats(requestStride))
                .response { res in debugPrint(res)}
                .responseDecodable(of: AnalzyeDateResponse<AnalyzeStepData>.self) { response in
                    switch response.result {
                    case .success(let analyzeDateResponse):
                        promise(.success(analyzeDateResponse))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    func getAnalyzeSpeed(type: DropRange, startDate: String, endDate: String) -> AnyPublisher<AnalzyeDateResponse<AnalyzeSpeedData>, Error> {
        return Future<AnalzyeDateResponse<AnalyzeSpeedData>, Error> { promise in
            let requestSpeed = AnalyzeDataRequest(type: type, startDate: startDate, endDate: endDate)
            AF.request(ExerciseAPI.requestspeedStats(requestSpeed))
                .response { res in debugPrint(res)}
                .responseDecodable(of: AnalzyeDateResponse<AnalyzeSpeedData>.self) { response in
                    switch response.result {
                    case .success(let analyzeDateResponse):
                        promise(.success(analyzeDateResponse))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }.eraseToAnyPublisher()
    }



    func postSaveExercise(_ exerciseSession: ExerciseSession, exerciseMetrics: ExerciseMetrics) -> AnyPublisher<Bool, any Error> {
        return Future<Bool, Error> { promise in
            let startTime  = exerciseSession.startTime
            let endTime = exerciseSession.endTime
            let saveExerciseRequest = SaveExerciseRequest(minStride: exerciseMetrics.minStride, maxStride: exerciseMetrics.maxStride, averageStride: exerciseMetrics.averageStride, minSpeed: exerciseMetrics.minSpeed, maxSpeed: exerciseMetrics.maxSpeed, averageSpeed: exerciseMetrics.averageSpeed, step: exerciseMetrics.step, distance: exerciseMetrics.distance, startTime: startTime, endTime: endTime, course: exerciseSession.course, doShareCourse: exerciseSession.doShareCourse, courseName: exerciseSession.courseName, datacount: exerciseMetrics.datacount)
            AF.request(ExerciseAPI.requestSaveExercise(saveExerciseRequest))
                .response { response in
                    debugPrint(response)
                }
                .responseDecodable(of: SaveExerciseRequest.self) { res in
                    if let data = res.value {
                        promise(.success(true))
                    } else if let error = res.error {
                        promise(.failure(error))
                    }
                }
        }.eraseToAnyPublisher()
    }


}
