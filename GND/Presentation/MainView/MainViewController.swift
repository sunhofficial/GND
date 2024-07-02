//
//  MainViewController.swift
//  GND
//
//  Created by 235 on 5/5/24.
//

import UIKit
import Then
import SnapKit
import Combine

class MainViewController: UIViewController {
    var enterRooms :[EnterModel] = [ EnterModel(title: "경희대 사람문의", subtitle: "교수 경희대 국제관 하반기", participantCount: 3, imageString: "logo"),
                                     EnterModel(title: "어쩌구 저쩌구", subtitle: "코스 설명", participantCount: 10, imageString:  "logo")]
//    let goalView = UIView().then {
//        $0.layer.cornerRadius = 16
//        $0.backgroundColor = CustomColors.cell
//    }
    var viewModel: MainViewModel?
    private let loadingView = UIView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var overlayView: UIView?
    private var cancellables = Set<AnyCancellable>()
    let recentView = CellView()
    private var recentData: CellType?
    private let goalView = GoalView()
    private var goalModalView: GoalModalView?
    private var modalType: GoalType?
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EnterRoomCell.self, forCellWithReuseIdentifier: EnterRoomCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        return collectionView
    }()
    private let exerciseButton = ExerciseButton(mode: ExerciseMode.normal )
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingView()
        showLoadingView()
        bindViewModel()
        setupUI()
        self.view.backgroundColor = CustomColors.bk
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        overlayView?.removeFromSuperview()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.getUserGoal()
        viewModel?.getRecent1Course()
    }
    private func bindViewModel() {
        viewModel?.postPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] usergoal in
                self?.hideLoadingView()
                self?.goalView.updateGoalView(viewmodel: (self?.viewModel!)!)

            }).store(in: &cancellables)

        viewModel?.$recentCourse
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] data in
                guard let data = data else {return}
                self?.recentData = .recentCource(CourseModel(courseTitle: data.courseName ?? "", courseDistance: data.distance, courseTime: data.time, coordinates: data.course))
                self?.updateRecentView()

            }).store(in: &cancellables)
        viewModel?.firstPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { isFirst in
                if isFirst {
                    self.modalType = .first
                }
            }).store(in: &cancellables)
        viewModel?.levelupPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { levelup in
                if levelup {
                    self.modalType = .levelup(nextLevel: self.viewModel!.userLevel)
                }
            }).store(in: &cancellables)
    }

    private func setupUI() {
        setupNavigationBar()
        setupGoalView()
        setEnterRooms()
        setRecentCourse()
        setExerciseButton()

        switch modalType {
        case .first:
            setupGoalModalView(isFirst: true )
        case .levelup(let nextLevel):
            setupGoalModalView(isFirst: false)
        case nil:
            break
        }
    }
    private func setupLoadingView() {
        loadingView.frame = view.bounds
        loadingView.backgroundColor = .white

        activityIndicator.center = loadingView.center
        loadingView.addSubview(activityIndicator)
    }

    private func showLoadingView() {
        view.addSubview(loadingView)
        activityIndicator.startAnimating()
    }
    private func hideLoadingView() {
        activityIndicator.stopAnimating()
        loadingView.removeFromSuperview()
    }

    private func setupNavigationBar() {
        let profileButton = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .plain, target: self, action: #selector(profileButtonTapped))
        navigationItem.rightBarButtonItem = profileButton
    }

    @objc private func profileButtonTapped() {
        print("프로필 버튼이 클릭되었습니다.")
    }
    func makeTitleLabel(title: String) -> UILabel {
        let label = UILabel().then {
            $0.text = title
            $0.font = .systemFont(ofSize: 32, weight: .bold)
        }
        return label
    }
    private func setupGoalView() {
        view.addSubview(goalView)
        goalView.snp.makeConstraints {
                 $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
                 $0.leading.trailing.equalToSuperview().inset(20)
             }

    }

    func setEnterRooms() {
        let titleLabel = UILabel().then {
            $0.text = "참여 중인 방"
            $0.font = .systemFont(ofSize: 32, weight: .bold)
        }
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(goalView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(16)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(110)
        }
    }
    func setRecentCourse() {
        let titleLabel = UILabel().then {
            $0.text = "나의 최근 코스"
            $0.font = .systemFont(ofSize: 32, weight: .bold)
        }
        let moreButton = UIButton().then {
            $0.setTitle("더보기 +", for: .normal)
            $0.setTitleColor(CustomColors.brown, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            $0.addTarget(self, action: #selector(moreBtnTouch), for: .touchUpInside)
        }
        view.addSubview(recentView)
        view.addSubview(titleLabel)
        view.addSubview(moreButton)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
        }
        moreButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
        recentView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(moreButton.snp.bottom).offset(4)
            $0.height.equalTo(114)
        }
    }
    private func updateRecentView() {
        guard let recentData = recentData else { return }
        recentView.configure(with: recentData)
    }
    @objc private func moreBtnTouch() {
        viewModel?.moveToRecent()
    }
    private func setExerciseButton() {
        view.addSubview(exerciseButton)
        exerciseButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(104)
            $0.centerX.equalToSuperview()
        }
        exerciseButton.addTarget(self, action: #selector(exerciseButtonTapped), for: .touchUpInside)
    }
    @objc private func exerciseButtonTapped() {
        showExerciseOptions()
    }
    private func showExerciseOptions() {
        let overlay = UIView(frame: self.view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.view.addSubview(overlay)
        self.overlayView = overlay
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissOverlay))
        overlay.addGestureRecognizer(tapGesture)
        let buttons = ExerciseMode.allCases.filter { $0 != .normal }.map { mode -> UIButton in
            let button = ExerciseButton(mode: mode)
            button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            return button
        }
        // Buttons 생성
        buttons.forEach { button in
            overlayView?.addSubview(button)
        }
        buttons[0].snp.makeConstraints { $0.bottom.equalTo(exerciseButton.snp.top).offset(-96); $0.centerX.equalToSuperview() }
        buttons[1].snp.makeConstraints { $0.bottom.equalTo(exerciseButton.snp.top); $0.trailing.equalTo(exerciseButton.snp.leading) }
        buttons[2].snp.makeConstraints { $0.bottom.equalTo(exerciseButton.snp.top); $0.leading.equalTo(exerciseButton.snp.trailing) }
        buttons[3].snp.makeConstraints { $0.edges.equalTo(exerciseButton) }
    }
    private func setupGoalModalView(isFirst: Bool) {
        goalModalView = GoalModalView()
        goalModalView?.goal = viewModel?.modalGoal
        if isFirst {
            goalModalView?.goalType = .first
        } else {
            goalModalView?.goalType = .levelup(nextLevel: viewModel!.userLevel)
        }
        goalModalView?.layer.cornerRadius = 16
        goalModalView?.backgroundColor = CustomColors.bk
        let overlay = UIView(frame: self.view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.view.addSubview(overlay)
        overlay.addSubview(goalModalView!)
        overlayView = overlay
        goalModalView?.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(320)
            $0.height.equalTo(520)
        }
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(dismissOverlay))
        overlay.addGestureRecognizer(tapgesture)
    }
    @objc private func dismissOverlay() {
        overlayView?.removeFromSuperview()
    }

    @objc private func buttonAction(sender: UIButton) {
        guard let modeIdentifier = sender.accessibilityIdentifier,
              let mode = ExerciseMode(rawValue: modeIdentifier) else {
            return
        }
        mode == .none ? dismissOverlay() : viewModel?.moveToExercise(mode: mode)

    }
}



extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        enterRooms.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EnterRoomCell.id, for: indexPath) as? EnterRoomCell else {
            fatalError("Unable to dequeue EnterRoomCell")
        }
        let room = enterRooms[indexPath.row]
        cell.configure(with: room)  // 셀에 데이터 설정
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 32, height: collectionView.bounds.height + 8)
    }
}
#Preview {
    let vc = UINavigationController(rootViewController: MainViewController())
    return vc
}
