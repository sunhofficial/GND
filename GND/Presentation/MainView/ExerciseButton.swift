//
//  ExerciseButton.swift
//  GND
//
//  Created by 235 on 5/6/24.
//

import UIKit

class ExerciseButton: UIButton {
    init(title: String, backgroundColor: UIColor, fontsize: CGFloat = 16) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontsize, weight: .bold)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = 48

    }
    required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 96, height: 96)
    }
}
