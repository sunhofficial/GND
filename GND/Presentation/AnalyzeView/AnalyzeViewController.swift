//
//  AnalyzeViewController.swift
//  GND
//
//  Created by 235 on 5/13/24.
//

import UIKit
import SnapKit
import Combine
import Then
import SwiftUI
enum AnalzyeType: String{
    case stride = "보폭"
    case speed = "걸음속도"
    case steps = "걸음수"
}
class AnalyzeViewController: UIViewController {
    let segmentedControl = UISegmentedControl(items: ["보폭", "걸음속도", "걸음수"])
    let dropBoxButton = DropDownButton()
    let dateLabel = UILabel()
    var infoViews: [AnalzyeType: UIView] = [:]
    let viewModel = AnalyzeViewModel(analyzeUsecase: AnalyzeUseCase(exerciseReposiotory: ExerciseRepository()))
    let analyzeImage = UIImageView(image: UIImage(named: "analyzeLogo"))
    private var selectedDate: DropRange = .day
    private var cancellables = Set<AnyCancellable>()
    let scrollView = UIScrollView()
    let containerView = UIView()
    var chartViewHosting: UIHostingController<AnalyzeChartView>? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setScrollview()
        setupSegmendtedControl()
        setupDropDownButton()
        setChartView()
        setInfoView()
        updateInfoview()
    }
    private func setScrollview() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()

        }
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview() // containerView의 상단과 하단을 scrollView와 맞춤
            $0.width.equalToSuperview()
//            $0.bottom.
//            $0.width.equalToSuperview()
            $0.height.equalTo(1400)
//            $0.bottom.equalToSuperview()
        }
    }
    func setupSegmendtedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = CustomColors.cell
        segmentedControl.layer.cornerRadius = 10
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        self.didChangeValue(segment: self.segmentedControl)
        containerView.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
    }
    func setupDropDownButton() {
        dropBoxButton.dataSource = DropRange.allCases
        dropBoxButton.delegate = self

        dateLabel.font = .systemFont(ofSize: 20, weight: .medium)
        containerView.addSubview(dateLabel)
        containerView.addSubview(analyzeImage)
        dateLabel.text = "\(viewModel.dateRanges[selectedDate]!.formatToCalendarString())-\(viewModel.endDate.formatToCalendarString())"

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(24)
        }

    }
    private func setChartView() {
        chartViewHosting = UIHostingController(rootView: AnalyzeChartView(viewModel: viewModel))
        guard let chartsView = chartViewHosting?.view else {
            return
        }
        containerView.addSubview(chartsView)
        containerView.addSubview(dropBoxButton)
        chartsView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(chartsView.snp.width)
        }
        dropBoxButton.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(24)
        }
        analyzeImage.snp.makeConstraints{
            $0.top.equalTo(chartsView.snp.bottom).offset(24)
            $0.width.height.equalTo(280)
            $0.centerX.equalToSuperview()
        }
    }
    func setInfoView() {
        let strideInfoView = StrideInfoView()
        let speedInfoView = SpeedInfoVIew()
        let stepsInfoView = StepsInfoView()

        infoViews[.stride] = strideInfoView
        infoViews[.speed] = speedInfoView
        infoViews[.steps] = stepsInfoView
        for (_, infoview) in infoViews {
            containerView.addSubview(infoview)
            infoview.snp.makeConstraints {
                $0.top.equalTo(analyzeImage.snp.bottom).offset(16)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
            infoview.isHidden = true
        }
    }
    @objc private func didChangeValue(segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            viewModel.updateAnalyzeType(type: .stride)
        case 1:
            viewModel.updateAnalyzeType(type: .speed)
        case 2:
            viewModel.updateAnalyzeType(type: .steps)
        default:
            break
        }
        viewModel.fetchChartData( dateRange: selectedDate)
        updateInfoview()
    }
    private func updateInfoview() {
        for (type, infoView) in infoViews {
            infoView.isHidden = type != viewModel.selectedType
              }
    }
}
extension AnalyzeViewController: DropDownButtonDelegate {
    func didSelect(_ index: Int) {
        selectedDate = dropBoxButton.dataSource[index]
        dateLabel.text = "\(viewModel.dateRanges[selectedDate]!.formatToCalendarString())-\(viewModel.endDate.formatToCalendarString())"
        viewModel.fetchChartData( dateRange: selectedDate)
    }


}
#Preview {
    AnalyzeViewController()
}
