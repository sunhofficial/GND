//
//  UITextFiled+.swift
//  GND
//
//  Created by 235 on 5/5/24.
//

import UIKit

extension UITextField {
    func addLeftPadding(_ paddingLeft: CGFloat = 16) {
        leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        leftViewMode = .always
    }
//    func addVerticalPadding(_ paddingVertical: CGFloat = 20) {
//        verticalView = UIView
//    }
}
