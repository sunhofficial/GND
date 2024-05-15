//
//  ExerciseButton.swift
//  GND
//
//  Created by 235 on 5/6/24.
//

import UIKit

class ExerciseButton: UIButton {
    init(mode: ExerciseMode, fontsize: CGFloat = 16) {
        super.init(frame: .zero)
        self.setTitle(mode.rawValue, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontsize, weight: .bold)
        self.backgroundColor = mode.buttonColor
        self.layer.cornerRadius = 48
        self.accessibilityIdentifier = mode.rawValue
    }
    required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 96, height: 96)
    }
}
