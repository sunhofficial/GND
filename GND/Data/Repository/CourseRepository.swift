//
//  CourseRepository.swift
//  GND
//
//  Created by 235 on 5/30/24.
//
import Combine
import Alamofire



class CourseRepository: CourseRepositoryProtocol {
    func getMyRecentCourses(showCount: Int, nextID: Int?) -> AnyPublisher<PagenaitedRecentCourse, Error> {
        return Future<PagenaitedRecentCourse, Error> { promise in
            AF.request(CourseAPI.requestGetRecent(showCount: showCount, nextCourseID: nextID))
                .response{ data in
                debugPrint(data)}
                .responseDecodable(of: GetRecentResponse.self) { response in
                    switch response.result {
                    case .success(let data):
                        let recentCourses = data.results.map { course in
                            RecentCourse(
                                courseId: course.courseID,
                                distance: course.distance,
                                time: course.time,
                                course: course.course,
                                courseName: course.courseName.isEmpty ? nil : course.courseName
                            )
                        }
                        let paginatedResponse = PagenaitedRecentCourse(
                            courses: recentCourses,
                            hasNext: data.hasNext,
                            nextcourseId: data.nextCourseID
                        )
                        promise(.success(paginatedResponse))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}


