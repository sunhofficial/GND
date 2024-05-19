//
//  ExerciseRepository.swift
//  GND
//
//  Created by 235 on 5/15/24.
//

import Alamofire
import Combine

protocol ExerciseRepositoryProtocol {
    func getTodayGoal()
    func postSaveExercise(_ exerciseSession: ExerciseSession, exerciseMetrics: ExerciseMetrics) -> AnyPublisher<Bool,  Error>
}

class ExerciseRepository: ExerciseRepositoryProtocol {
    func postSaveExercise(_ exerciseSession: ExerciseSession, exerciseMetrics: ExerciseMetrics) -> AnyPublisher<Bool, any Error> {
        return Future<Bool, Error> { promise in
            let saveExerciseRequest = SaveExerciseRequest(minStride: exerciseMetrics.minStride, maxStride: exerciseMetrics.maxStride, averageStride: exerciseMetrics.averageStride, minSpeed: exerciseMetrics.minSpeed, maxSpeed: exerciseMetrics.maxSpeed, averageSpeed: exerciseMetrics.averageSpeed, step: exerciseMetrics.step, distance: exerciseMetrics.distance, startTime: exerciseSession.startTime, endTime: exerciseSession.endTime, course: exerciseSession.course, doShareCourse: exerciseSession.doShareCourse, courseName: exerciseSession.courseName)
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
    
    func getTodayGoal() {

    }

}
