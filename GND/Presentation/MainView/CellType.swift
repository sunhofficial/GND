//
//  CellType.swift
//  GND
//
//  Created by 235 on 5/6/24.
//

import UIKit
import MapKit
enum CellType {
    case enterRoom(EnterModel)
    case recentCource(CourseModel)
    func configure(view: CellView) {
          switch self {
          case .enterRoom(let model):
              view.titleLabel.text = model.title
              view.subtitleLabel.text = model.subtitle
              view.lastLabel.text = "\(model.participantCount)명 참여중"
              view.mapImageView.image = UIImage(named: model.imageString)
          case .recentCource(let model):
              view.titleLabel.text = model.courseTitle
              view.subtitleLabel.text = "코스길이: \(model.courseDistance)m"
              let hours = model.courseTime / 3600
                let minutes = (model.courseTime % 3600) / 60
                let seconds = model.courseTime % 60

                if hours > 0 {
                    view.lastLabel.text = "운동시간: \(hours)시간 \(minutes)분"
                } else {
                    view.lastLabel.text = "운동시간: \(minutes)분 \(seconds)초"
                }
              guard let firstCoordinates = model.coordinates.first else {return}
              let startannotation = MKPointAnnotation()
              startannotation.coordinate = CLLocationCoordinate2D(latitude: firstCoordinates.latitude, longitude: firstCoordinates.longitude)
              startannotation.title = "시작점"
              view.mapView.addAnnotation(startannotation)
              guard let endCoordinates = model.coordinates.last else {return}
              let endannotation = MKPointAnnotation()
              endannotation.coordinate = CLLocationCoordinate2D(latitude: endCoordinates.latitude, longitude: endCoordinates.longitude)
              endannotation.title = "종료점"
              view.mapView.addAnnotation(endannotation)
              var coordinates: [CLLocationCoordinate2D] = []
              for coordinate in model.coordinates {
                  coordinates.append(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
              }
              let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
              view.mapView.addOverlay(polyline)
              view.mapView.setVisibleMapRect(polyline.boundingMapRect,  edgePadding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), animated: true)

          }
      }
}
