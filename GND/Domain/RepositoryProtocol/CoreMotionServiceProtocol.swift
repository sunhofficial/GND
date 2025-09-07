//
//  CoreMotionServiceProtocol.swift
//  GND
//
//  Created by Sunho on 2/17/25.
//
import Combine

protocol CoreMotionServiceProtocol {
    func startPedometer()
    func stopActivity()
    var motionDataPublisher: AnyPublisher<RawMotionData, Never> { get }
    var exerciseDataPublisher: AnyPublisher<ExerciseData, Never> { get }
    var stepsPublisher: AnyPublisher<Int, Never> { get }
}
