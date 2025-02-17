//
//  ExerciseRepositoryProtocol.swift
//  GND
//
//  Created by Sunho on 2/17/25.
//

import Combine
protocol ExerciseRepositoryProtocol {

    func postSaveExercise(_ exerciseSession: ExerciseSession, exerciseMetrics: ExerciseMetrics) -> AnyPublisher<Bool,  Error>
    func getAnalyzeSpeed(type: DropRange, startDate: String, endDate: String)-> AnyPublisher<AnalzyeDateResponse<AnalyzeSpeedData>, Error>
    func getAnalyzeStride(type: DropRange, startDate: String, endDate: String) -> AnyPublisher<AnalzyeDateResponse<AnalyzeStrideData>, Error>
    func getAnalyzeSteps(type: DropRange, startDate: String, endDate: String) -> AnyPublisher<AnalzyeDateResponse<AnalyzeStepData>, Error>
}
