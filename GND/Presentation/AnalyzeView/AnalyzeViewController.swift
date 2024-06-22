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
    private var selectedType: AnalzyeType = .stride {
        didSet {
            updateInfoview()
        }
    }
    private var selectedDate: DropRange = .day
    private var cancellables = Set<AnyCancellable>()
    let scrollView = UIScrollView()
    let containerView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setScrollview()
        setupSegmendtedControl()
        setupDropDownButton()

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
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualTo(scrollView.snp.height)
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
        containerView.addSubview(dropBoxButton)
        dateLabel.font = .systemFont(ofSize: 20, weight: .medium)
        containerView.addSubview(dateLabel)
        containerView.addSubview(analyzeImage)
        dateLabel.text = "\(viewModel.dateRanges[selectedDate]!.formatToCalendarString())-\(viewModel.endDate.formatToCalendarString())"
        dropBoxButton.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(24)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(dropBoxButton.snp.top)
            $0.leading.equalToSuperview().offset(24)
        }
        analyzeImage.snp.makeConstraints{
            $0.top.equalTo(dropBoxButton.snp.bottom).offset(64)
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
    private func updateInfoview() {
        for (type, infoView) in infoViews {
                  infoView.isHidden = type != selectedType
              }
    }
}
extension AnalyzeViewController: DropDownButtonDelegate {
    func didSelect(_ index: Int) {
        selectedDate = dropBoxButton.dataSource[index]
        dateLabel.text = "\(viewModel.dateRanges[selectedDate]!.formatToCalendarString())-\(viewModel.endDate.formatToCalendarString())"
        viewModel.fetchChartData(type: selectedType, dateRange: selectedDate)
    }


}
#Preview {
    AnalyzeViewController()
}
