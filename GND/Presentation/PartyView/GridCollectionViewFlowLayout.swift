//
//  GridCollectionViewFlowLayout.swift
//  GND
//
//  Created by 235 on 5/6/24.
//

import UIKit

class GridCollectionViewFlowLayout: UICollectionViewFlowLayout {
  var numberOfColumns = 2
    var itemSpacing = 0.0 {
        didSet {
            self.minimumInteritemSpacing = self.itemSpacing
        }
    }
  var cellSpacing = 0.0 {
    didSet {
      self.minimumLineSpacing = self.cellSpacing

    }
  }

  override init() {
    super.init()
    self.scrollDirection = .vertical
  }
  required init?(coder: NSCoder) {
    fatalError()
  }
}
