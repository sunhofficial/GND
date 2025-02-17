//
//  CoreMotionServiceProtocol.swift
//  GND
//
//  Created by Sunho on 2/17/25.
//
import Combine

protocol CoreMotionServiceProtocol {
    var mode: ExerciseMode { get }
    func startPedometer()
    func stopActivity()
    var warningPublisher: AnyPublisher<WarningCase, Error> { get }
    var exerciseDataPublisher: AnyPublisher<ExerciseData, Never> { get }
    var stepsPublisher: AnyPublisher<Int, Never> { get }
}
