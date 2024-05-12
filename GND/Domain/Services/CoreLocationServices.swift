//
//  CoreLocationServices.swift
//  GND
//
//  Created by 235 on 5/12/24.
//

import Foundation
import CoreLocation

class CoreLocationServices: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var locations: [CLLocation] = [] {
        didSet {
            print(locations)
        }
    }
    @Published var locationdraw: [CLLocationCoordinate2D] = []
    private var oldLocatio: CLLocation?
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 20
        locationManager.allowsBackgroundLocationUpdates = true

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
    func startagain() {
        locationManager.startUpdatingLocation()
    }
    func stop() {
        locationManager.stopUpdatingLocation()
    }
}
extension CoreLocationServices: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard .authorizedWhenInUse == manager.authorizationStatus else { return }
          locationManager.requestLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        guard let newLocation = locations.last else {return}
        guard let oldLocation = locations.first else {
            self.oldLocatio = newLocation
            return
        }
        locationdraw.append(newLocation.coordinate)
        locations.last.map {
            region in
            self.locations.append(region)
        }
        self.oldLocatio = newLocation
    }
}
