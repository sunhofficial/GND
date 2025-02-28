//
//  CoreLocationServicesProtocol.swift
//  GND
//
//  Created by Sunho on 2/17/25.
//

import Combine
import CoreLocation
protocol CoreLocationServicesProtocol {
    var locationPublisher: AnyPublisher<[CLLocation], Never> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
    func startupdatingLocation()
    func stopupdatingLocation()
}
