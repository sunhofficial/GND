//
//  AnalyzeViewController.swift
//  GND
//
//  Created by 235 on 5/13/24.
//

import UIKit
import SnapKit

class AnalyzeViewController: UIViewController {
    let segmentedControl = UISegmentedControl(items: ["보폭", "걸음속도", "걸음수"])
    let dropBoxButton = DropDownButton()
    let dateLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmendtedControl()
        setupDropDownButton()
    }
    func setupSegmendtedControl() {
        segmentedControl.selectedSegmentIndex = 0
        //        segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentedControl.backgroundColor = CustomColors.cell
        segmentedControl.layer.cornerRadius = 10
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        self.didChangeValue(segment: self.segmentedControl)
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(56)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
    }
    func setupDropDownButton() {
        dropBoxButton.dataSource = DropRange.allCases
        dropBoxButton.delegate = self
        view.addSubview(dropBoxButton)
        dateLabel.font = .systemFont(ofSize: 20, weight: .medium)
        view.addSubview(dateLabel)
        setdateLabel(range: .day)
        dropBoxButton.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(24)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(dropBoxButton.snp.top)
            $0.leading.equalToSuperview().offset(24)
        }
    }
    func setdateLabel(range: DropRange) {
        let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "yyyy.MM.dd"
               let today = Date()
        var startDate: Date
               var endDate: Date = today
        switch range {
               case .day:
                   startDate = Calendar.current.date(byAdding: .day, value: -7, to: today)!
               case .week:
                   startDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: today)!
               case .month:
                   startDate = Calendar.current.date(byAdding: .month, value: -1, to: today)!
               case .year:
                   startDate = Calendar.current.date(byAdding: .year, value: -1, to: today)!
               }
        let startDateString = dateFormatter.string(from: startDate)
             let endDateString = dateFormatter.string(from: endDate)
             dateLabel.text = "\(startDateString) - \(endDateString)"
    }
    @objc private func didChangeValue(segment: UISegmentedControl) {
    }
}
extension AnalyzeViewController: DropDownButtonDelegate {
    func didSelect(_ index: Int) {
        let selectedITEM = dropBoxButton.dataSource[index]
        setdateLabel(range: selectedITEM)
    }
    

}
#Preview {
    AnalyzeViewController()
}
