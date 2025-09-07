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
    func provideCoreMotionService() -> CoreMotionServiceProtocol {
        return CoreMotionService()
    }
    
    func provideExerciseUseCase() -> ExerciseUsecase {
         return ExerciseUsecase(
             exerciseRepository: provideExerciseRepository(),
             coreMotionService: provideCoreMotionService(),
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
