//
//  AnalyzeUseCase.swift
//  GND
//
//  Created by 235 on 6/20/24.
//

import Combine

protocol AnalyzeUseCaseProtocol {
    func getStrideStats(type: DropRange, startDate: String, endDate: String) -> AnyPublisher<AnalzyeDateResponse<AnalyzeStrideData>, Error>
    func getStepsStats(type: DropRange, startDate: String, endDate: String) ->
    AnyPublisher<AnalzyeDateResponse<AnalyzeStepData>, Error>
    func getSpeedStats(type: DropRange, startDate: String, endDate: String) -> AnyPublisher<AnalzyeDateResponse<AnalyzeSpeedData>, Error>
}
final class AnalyzeUseCase: AnalyzeUseCaseProtocol {
    var exerciseReposiotory: ExerciseRepositoryProtocol
    init(exerciseReposiotory: ExerciseRepositoryProtocol) {
        self.exerciseReposiotory = exerciseReposiotory
    }
    func getStrideStats(type: DropRange, startDate: String, endDate: String) -> AnyPublisher<AnalzyeDateResponse<AnalyzeStrideData>, any Error> {
        exerciseReposiotory.getAnalyzeStride(type: type, startDate: startDate, endDate: endDate)
            .eraseToAnyPublisher()
    }
    
    func getStepsStats(type: DropRange, startDate: String, endDate: String) -> AnyPublisher<AnalzyeDateResponse<AnalyzeStepData>, any Error> {
        exerciseReposiotory.getAnalyzeSteps(type: type, startDate: startDate, endDate: endDate)
            .eraseToAnyPublisher()
    }
    
    func getSpeedStats(type: DropRange, startDate: String, endDate: String) -> AnyPublisher<AnalzyeDateResponse<AnalyzeSpeedData>, any Error> {
        exerciseReposiotory.getAnalyzeSpeed(type: type, startDate: startDate, endDate: endDate)
            .eraseToAnyPublisher()
    }
    

}
