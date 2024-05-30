//
//  CourseUseCase.swift
//  GND
//
//  Created by 235 on 5/30/24.
//

import Combine
protocol CourseUseCaseProtocol {
//    var getRecentPublisher: AnyPublisher<PagenaitedRecentCourse,Error> {get}
    func getRecentCourses(showCount: Int, nextID: Int?) -> AnyPublisher<PagenaitedRecentCourse,Error>
}
final class CourseUseCase: CourseUseCaseProtocol {
    var getRecentPublisher: AnyPublisher<PagenaitedRecentCourse, Error> {
        getRecentSubject.eraseToAnyPublisher()
    }
    private let getRecentSubject = PassthroughSubject<PagenaitedRecentCourse, Error>()
    var courseRepository: CourseRepositoryProtocol
    init(courseRepository: CourseRepositoryProtocol) {
        self.courseRepository = courseRepository
    }
    func getRecentCourses(showCount: Int, nextID: Int?) -> AnyPublisher<PagenaitedRecentCourse, Error> {
        return courseRepository.getMyRecentCourses(showCount: showCount, nextID: nextID)
    }
}
