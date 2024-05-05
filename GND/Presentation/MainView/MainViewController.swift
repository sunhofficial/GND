//
//  MainViewController.swift
//  GND
//
//  Created by 235 on 5/5/24.
//

import UIKit
import Then
import SnapKit
class MainViewController: UIViewController {
    var enterRooms :[EnterModel] = [ EnterModel(title: "경희대 사람문의", subtitle: "교수 경희대 국제관 하반기", participantCount: 3, imageString: "logo"),
    EnterModel(title: "어쩌구 저쩌구", subtitle: "코스 설명", participantCount: 10, imageString:  "logo")]
    let goalView = UIView().then {
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .yellow
    }
    private var overlayView: UIView?
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
    private let exerciseButton = ExerciseButton(title: "운동하기", backgroundColor: .brown)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupUI()
    }
    private func setupUI() {
        setupNavigationBar()
        setupGoalView()
        setEnterRooms()
        setRecentCourse()
        setExerciseButton()
    }
    private func setupNavigationBar() {
           navigationItem.title = "오늘의 목표"
           navigationController?.navigationBar.prefersLargeTitles = true
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
        let levelLabel = UILabel().then {
            $0.text = "LV 2"
            $0.font = .systemFont(ofSize: 32, weight: .bold)
            $0.textColor = .black
        }
        let meterGoalView = makeGoalInfoView(current: 3500, goal: 5000, measure: "미터")
        let speedGoalView = makeGoalInfoView(current: 4.8, goal: 5.0, measure: "km/h")
        let distanceGoalView = makeGoalInfoView(current: 2000, goal: 4000, measure: "걸음")
        let infoStack = UIStackView(arrangedSubviews: [meterGoalView, speedGoalView, distanceGoalView]).then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
        }
        goalView.addSubview(levelLabel)
        goalView.addSubview(infoStack)
        levelLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
        }
        infoStack.snp.makeConstraints {
            $0.top.equalTo(levelLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(8)
        }
        view.addSubview(goalView)
        goalView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(156)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
    }
    func makeGoalInfoView(current: Double, goal: Double, measure: String) -> UIStackView {
        let topLabel = UILabel().then {
            $0.text = "\(current)"
            $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            $0.textAlignment = .center
            $0.textColor = current < goal ? .red : .green
        }
        let bottomLabel = UILabel().then {
            $0.text = "/\n\(goal) \(measure)"
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            $0.textColor = .black
            $0.numberOfLines = 0
        }
        let stack = UIStackView(arrangedSubviews: [topLabel, bottomLabel]).then {
            $0.axis = .vertical
            $0.spacing = 0
        }
        return stack
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
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
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
            $0.setTitleColor(.brown, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            $0.addTarget(self, action: #selector(moreBtnTouch), for: .touchUpInside)
        }
        let recentView = CellView()
        let recentData = CellType.recentCource(CourseModel(courseTitle: "경희대 뒷길", courseDistance: "5000", courseTime: 10, mapImageString: "logo"))
        recentView.configure(with: recentData)
        view.addSubview(recentView)
        view.addSubview(titleLabel)
        view.addSubview(moreButton)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
        }
        moreButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(titleLabel.snp.bottom)
        }
        recentView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(moreButton.snp.bottom).offset(8)
            $0.height.equalTo(114)
        }
    }
    @objc private func moreBtnTouch() {
        print("더볼래?")
    }
    private func setExerciseButton() {
        view.addSubview(exerciseButton)
        exerciseButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(32)
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
        let buttons = [
                ExerciseButton(title: "산책하기", backgroundColor: .systemGray),
                ExerciseButton(title: "속도훈련", backgroundColor: .systemGray),
                ExerciseButton(title: "보폭훈련", backgroundColor: .lightGray),
                ExerciseButton(title: "X", backgroundColor: .red)
            ]
         // Buttons 생성
        buttons.forEach { button in
                  overlayView?.addSubview(button)
                  button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
              }
        buttons[0].snp.makeConstraints { $0.bottom.equalTo(exerciseButton.snp.top).offset(-96); $0.centerX.equalToSuperview() }
             buttons[1].snp.makeConstraints { $0.bottom.equalTo(exerciseButton.snp.top); $0.trailing.equalTo(exerciseButton.snp.leading) }
             buttons[2].snp.makeConstraints { $0.bottom.equalTo(exerciseButton.snp.top); $0.leading.equalTo(exerciseButton.snp.trailing) }
             buttons[3].snp.makeConstraints { $0.edges.equalTo(exerciseButton) }


    }
    @objc private func dismissOverlay() {
        overlayView?.removeFromSuperview()
    }

    @objc private func buttonAction(sender: UIButton) {
        print("Button Pressed: \(sender.currentTitle ?? "")")
        dismissOverlay()
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