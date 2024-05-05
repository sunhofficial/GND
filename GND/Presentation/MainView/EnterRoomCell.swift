//
//  EnterRoomCell.swift
//  GND
//
//  Created by 235 on 5/5/24.
//

import UIKit
import Then
import SnapKit

class EnterRoomCell: UICollectionViewCell {
    static let id = "EnterRoomCell"
    private var enterRoomView:  CellView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        enterRoomView = CellView(frame: .zero)
              guard let enterRoomView = enterRoomView else { return }
              contentView.addSubview(enterRoomView)
              enterRoomView.snp.makeConstraints { make in
                  make.edges.equalToSuperview()
              }
    }
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    func configure(with model: EnterModel) {
        enterRoomView?.configure(with: .enterRoom(model))
      }
}

