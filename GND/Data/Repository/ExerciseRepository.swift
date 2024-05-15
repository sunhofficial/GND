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
    func postSaveExercise(_ exercise: Exercise) -> AnyPublisher<Exercise,  Error>
}

class ExerciseRepository: ExerciseRepositoryProtocol {
    func postSaveExercise(_ exercise: Exercise) -> AnyPublisher<Exercise, any Error> {
        return Future<Exercise, Error> { promise in
            AF.request(ExerciseAPI.requestSaveExercise(exercise.toDTO()))
                .response { response in
                    debugPrint(response)
                }
                .responseDecodable(of: SaveExerciseRequest.self) { res in
                    if let data = res.value {
                        promise(.success(data.toDomain()))
                    } else if let error = res.error {
                        promise(.failure(error))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    func getTodayGoal() {

    }

}
