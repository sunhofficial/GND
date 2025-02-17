//
//  CourseRepositoryProtocol.swift
//  GND
//
//  Created by Sunho on 2/17/25.
//

import Combine
protocol CourseRepositoryProtocol {
    func getMyRecentCourses(showCount: Int, nextID: Int?) -> AnyPublisher<PagenaitedRecentCourse, Error>
}
