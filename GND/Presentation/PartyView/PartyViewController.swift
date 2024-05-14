//
//  PartyView.swift
//  GND
//
//  Created by 235 on 5/6/24.
//

import UIKit

import SnapKit
import Then

class PartyViewController: UIViewController {
    var dummydata = [PartyModel(mapImageString: "map", partyTitle: "안녕여긴", participantCount: 10, distance: 3),PartyModel(mapImageString: "map", partyTitle: "안녕여긴", participantCount: 10, distance: 3),PartyModel(mapImageString: "map", partyTitle: "안녕여긴", participantCount: 10, distance: 3),PartyModel(mapImageString: "map", partyTitle: "안녕여긴", participantCount: 10, distance: 3),PartyModel(mapImageString: "map", partyTitle: "안녕여긴", participantCount: 10, distance: 3),PartyModel(mapImageString: "map", partyTitle: "안녕여긴", participantCount: 10, distance: 3)]
    private let gridFlowLayout = GridCollectionViewFlowLayout().then {
        $0.cellSpacing = 24
        $0.itemSpacing = 13
    }
    private lazy var collectionView: UICollectionView = {
       let view = UICollectionView(frame: .zero, collectionViewLayout: self.gridFlowLayout)
       view.isScrollEnabled = true
       view.showsHorizontalScrollIndicator = false
       view.showsVerticalScrollIndicator = true
   //    view.scrollIndicatorInsets = UIEdgeInsets(top: -2, left: 0, bottom: 0, right: 4)
       view.contentInset = .zero
       view.backgroundColor = .clear
       view.clipsToBounds = true
        view.register(PartyCell.self, forCellWithReuseIdentifier: PartyCell.id)
       return view
     }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        self.view.addSubview(self.collectionView)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(165)
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.bottom.equalToSuperview()
        }
    }
    private func setupNavigationBar() {
        navigationItem.title = "현재 인기있는 걷기모임"
        navigationController?.navigationBar.prefersLargeTitles = true}
}
extension PartyViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummydata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PartyCell.id, for: indexPath) as? PartyCell else {
            fatalError("Unable to dequeue EnterRoomCell")
        }
        let partyCell = dummydata[indexPath.row]
         cell.configure(partyCell)// 셀에 데이터 설정
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard
             let flowLayout = collectionViewLayout as? GridCollectionViewFlowLayout,
             flowLayout.numberOfColumns > 0
           else { fatalError() }
        let widthOfCells = collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)

        // spacing 값
        let widthOfSpacing = CGFloat(flowLayout.numberOfColumns - 1) * flowLayout.itemSpacing

        // cell하나의 width = cell들의 width값에서 spacing값을 뺀것
        let width = (widthOfCells - widthOfSpacing) / CGFloat(flowLayout.numberOfColumns)
     


              return CGSize(width: width, height: 268)

    }
}

#Preview {
    let vc = UINavigationController(rootViewController: PartyViewController())
    return vc
}
