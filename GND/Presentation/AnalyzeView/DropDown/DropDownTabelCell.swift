//
//  DropDownTabelCell.swift
//  GND
//
//  Created by 235 on 6/19/24.
//

import Foundation
import UIKit
import SnapKit

class DropDownTabelCell: UITableViewCell {
    static let reuseIdentifier = "DropDownTableCell"
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.top.bottom.equalToSuperview()
        }
    }
    func set(_ text: String) {
        label.text = text
    }
}
