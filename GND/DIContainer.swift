//
//  DIContainer.swift
//  GND
//
//  Created by Sunho on 2/28/25.
//

import Foundation
class DIContainer {
    static let shared = DIContainer()
    func provideCoreLocationService() -> CoreLocationServicesProtocol {
        return CoreLocationServices()
    }
    func provideExerciseRepository() -> ExerciseRepositoryProtocol {
        return ExerciseRepository()
    }
    func provideCoreMotionService(mode: ExerciseMode, goal: UserGoal) -> CoreMotionServiceProtocol {
        return CoreMotionService(mode: mode, goal: goal)
    }
    
    func provideExerciseUseCase(mode: ExerciseMode, goal: UserGoal) -> ExerciseUseCaseProtocol {
         return ExerciseUsecase(
             exerciseRepository: provideExerciseRepository(),
             coreMotionService: provideCoreMotionService(mode: mode, goal: goal),
             coreLocationService: provideCoreLocationService()
         )
     }
    func provideUserUseCase() -> UserUsecase {
        return UserUsecase(userReposiotry: UserRepository())
       }
       
       func provideCourseUseCase() -> CourseUseCase {
           return CourseUseCase(courseRepository: CourseRepository())
       }
}
