//
//  RecentViewController.swift
//  GND
//
//  Created by 235 on 5/30/24.
//

import UIKit
import Combine
import SnapKit

final class RecentViewController: UIViewController {
    var viewModel: MainViewModel?
    private var cancellables = Set<AnyCancellable>()
    private lazy var recentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = CustomColors.bk
        collectionView.register(CellView.self, forCellWithReuseIdentifier: CellView.reuseIdentifier)
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.getRecentCourses()
        setTopNavigation()
        bindViewModel()
        recentCollectionView.delegate = self
        recentCollectionView.dataSource = self
        setUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.eraseRecentCourses()
        self.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    private func setTopNavigation() {
        navigationItem.title = "최근 코스"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .inline
    }
    private func setUI() {
        view.addSubview(recentCollectionView)
        recentCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview()
        }
    }
    private func bindViewModel() {
        viewModel?.$recentCourses
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.recentCollectionView.reloadData()
            }).store(in: &cancellables)
    }

}
extension RecentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout     {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.recentCourses.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellView.reuseIdentifier, for: indexPath) as? CellView else {
                 return UICollectionViewCell()
             }
        guard let course = viewModel?.recentCourses[indexPath.row] else {return cell}
        cell.configure(with: .recentCource(CourseModel(courseTitle: course.courseName ?? "없어", courseDistance: course.distance, courseTime: course.time, coordinates: course.course)))
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight - height {
            viewModel?.getRecentCourses()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 32, height: 108)
    }

}
#Preview {
    UINavigationController(rootViewController: RecentViewController())
}
