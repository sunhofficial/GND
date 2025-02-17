//
//  CoreLocationServices.swift
//  GND
//
//  Created by 235 on 5/12/24.
//

import Foundation
import CoreLocation
import Combine


class CoreLocationServices: NSObject, CoreLocationServicesProtocol {
    private let locationSubject = PassthroughSubject<[CLLocation], Never>()
    private let locationManager = CLLocationManager()
    private let errorSubject = PassthroughSubject<Error, Never>()
    var locationPublisher: AnyPublisher<[CLLocation], Never> {
        locationSubject.eraseToAnyPublisher()
    }
    var errorPublisher: AnyPublisher<Error, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 20
        locationManager.allowsBackgroundLocationUpdates = true
        setup()
    }
    private func setup() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    func startupdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    func stopupdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}
extension CoreLocationServices: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard .authorizedWhenInUse == manager.authorizationStatus else { return }
          locationManager.requestLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        errorSubject.send(error)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationSubject.send(locations)
    }
}
