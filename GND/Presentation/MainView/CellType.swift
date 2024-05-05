//
//  CellType.swift
//  GND
//
//  Created by 235 on 5/6/24.
//

import UIKit
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
              view.subtitleLabel.text = "코스길이: \(model.courseDistance)"
              view.lastLabel.text = "운동시간: \(model.courseTime)분"
              view.mapImageView.image = UIImage(named: model.mapImageString)
          }
      }
}
