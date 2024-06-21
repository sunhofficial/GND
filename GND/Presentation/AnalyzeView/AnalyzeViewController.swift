//
//  AnalyzeViewController.swift
//  GND
//
//  Created by 235 on 5/13/24.
//

import UIKit
import SnapKit
import Combine

enum AnalzyeType: String{
    case stride = "보폭"
    case speed = "걸음속도"
    case steps = "걸음수"
}
class AnalyzeViewController: UIViewController {
    let segmentedControl = UISegmentedControl(items: ["보폭", "걸음속도", "걸음수"])
    let dropBoxButton = DropDownButton()
    let dateLabel = UILabel()
    let viewModel = AnalyzeViewModel(analyzeUsecase: AnalyzeUseCase(exerciseReposiotory: ExerciseRepository()))
    private var selectedType: AnalzyeType = .stride
    private var selectedDate: DropRange = .day
      private var cancellables = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupSegmendtedControl()
        setupDropDownButton()
    }
    func setupSegmendtedControl() {
        segmentedControl.selectedSegmentIndex = 0
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
        dateLabel.text = "\(viewModel.dateRanges[selectedDate]!)-\(viewModel.endDate)"
        dropBoxButton.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(24)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(dropBoxButton.snp.top)
            $0.leading.equalToSuperview().offset(24)
        }
    }
    @objc private func didChangeValue(segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
           case 0:
               selectedType = .stride
           case 1:
               selectedType = .speed
           case 2:
               selectedType = .steps
           default:
               break
           }
        viewModel.fetchChartData(type: selectedType, dateRange: selectedDate)
    }
}
extension AnalyzeViewController: DropDownButtonDelegate {
    func didSelect(_ index: Int) {
        selectedDate = dropBoxButton.dataSource[index]
        dateLabel.text = "\(viewModel.dateRanges[selectedDate]!)-\(viewModel.endDate)"
        viewModel.fetchChartData(type: selectedType, dateRange: selectedDate)
    }


}
#Preview {
    AnalyzeViewController()
}
