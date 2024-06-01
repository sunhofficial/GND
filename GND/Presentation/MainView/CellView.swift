//
//  RecentView.swift
//  GND
//
//  Created by 235 on 5/6/24.
//

import UIKit
import MapKit

class CellView: UICollectionViewCell {
    static let reuseIdentifier = "CellView"
    let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20,weight: .semibold)
        $0.textColor = .black
    }
    let subtitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .black
    }
    let lastLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .black

    }
    let mapImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
     lazy var mapView = MKMapView().then {  
        $0.showsUserLocation = false
        $0.overrideUserInterfaceStyle = .light
         $0.layer.cornerRadius = 10
              $0.clipsToBounds = true
    }
    override init(frame: CGRect) {
           super.init(frame: frame)
           setupViews()
       }
    required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    
    private func setupViews() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = CustomColors.cell
        [mapView, titleLabel, subtitleLabel, lastLabel].forEach {
            addSubview($0)
        }
            mapView.snp.makeConstraints { make in
                make.top.left.equalToSuperview().inset(8)
                make.width.height.equalTo(88)
            }

            titleLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(12)
                make.leading.equalTo(mapView.snp.trailing).offset(16)
                
            }

            subtitleLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(16)
                make.leading.equalTo(mapView.snp.trailing).offset(16)
            }

            lastLabel.snp.makeConstraints { make in
                make.top.equalTo(subtitleLabel.snp.bottom).offset(16)
                make.leading.equalTo(mapView.snp.trailing).offset(16)
                make.bottom.equalToSuperview().offset(-8)
            }
        }

        func configure(with model: CellType) {
            model.configure(view: self)
        }
}
