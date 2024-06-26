//
//  ExerciseBarView.swift
//  GND
//
//  Created by 235 on 5/15/24.
//

import SwiftUI
import MapKit
import SnapKit


final class FinishExerciseViewController: UIViewController {
    var viewModel: ExerciseViewModel?
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    var userGoal: UserGoal?
    lazy var mapView =  MKMapView().then {
        $0.delegate = self
        $0.overrideUserInterfaceStyle = .light
        $0.showsUserLocation = false
        if let hasValue = viewModel?.locationUpdates {
            $0.setRegion(MKCoordinateRegion(center: hasValue.last! , span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        }
    }
    let sharingDescription = UILabel().then {
        $0.text = "코스를 공유하시겠습니까?"
        $0.font = .systemFont(ofSize: 32, weight: .medium)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    let shareButton = UIButton().then {
        $0.setTitle("예", for: .normal)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = CustomColors.brown
        $0.setTitleColor(CustomColors.bk, for: .normal)
    }
    let notshareButton = UIButton().then {
        $0.setTitle("아니요", for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = CustomColors.brown.cgColor
        $0.layer.cornerRadius = 8
        $0.setTitleColor(CustomColors.brown, for: .normal)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        addButtonAction()

    }
    private func setUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(mapView)
        if let coordinates = viewModel?.locationUpdates {
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(polyline)
        }
        addPin()
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        mapView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(400)
        }
        let controller = UIHostingController(rootView: ChartView(viewModel: viewModel!, userGoal: userGoal!))
        guard let chartsView = controller.view else {
            return
        }
        contentView.addSubview(chartsView)
        chartsView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(mapView.snp.bottom).offset(16)
//            $0.height.equalTo(800)

        }
        contentView.addSubview(sharingDescription)
        sharingDescription.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(chartsView.snp.bottom).offset(24)

        }
        contentView.addSubview(shareButton)
        contentView.addSubview(notshareButton)

        notshareButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(48)
            $0.top.equalTo(sharingDescription.snp.bottom).offset(32)
            $0.height.equalTo(52)
            $0.trailing.equalTo(contentView.snp.centerX).offset(-16)
//            $0.bottom.equalToSuperview()
        }
        shareButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(48)
            $0.top.equalTo(sharingDescription.snp.bottom).offset(32)
            $0.height.equalTo(52)
            $0.leading.equalTo(contentView.snp.centerX).offset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
 
    private func addButtonAction() {
        shareButton.addTarget(self, action: #selector(shareCourse), for: .touchUpInside)
        notshareButton.addTarget(self, action: #selector(notshareCourse), for: .touchUpInside)
    }
    @objc func shareCourse() {
        presentCourseTitleModal()
    }
    private func presentCourseTitleModal() {
          let modalVC = UIViewController()
          modalVC.modalPresentationStyle = .overFullScreen
        modalVC.modalTransitionStyle = .crossDissolve
          modalVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
          let modalView = SetCourseTitleModal()
        modalView.onAddButtonTapped = { title in
            self.viewModel?.sendToSever(title: title)
            modalVC.dismiss(animated: true)
        }
        modalView.onOutButtonTapped = {
            modalVC.dismiss(animated: true)
        }
        modalVC.view.addSubview(modalView)

          modalView.snp.makeConstraints {
              $0.center.equalToSuperview()
              $0.width.equalTo(350)
              $0.height.equalTo(196)
          }

          present(modalVC, animated: true, completion: nil)
      }
    @objc func notshareCourse() {
        viewModel?.inputs.sendNotsharing()
    }
    private func addPin() {
        if let locationdatas = viewModel?.locationUpdates {
            let startPin = MKPointAnnotation()
            startPin.title = "start"
            startPin.coordinate = locationdatas[0]
            mapView.addAnnotation(startPin)
            let endPin = MKPointAnnotation()
            endPin.title = "end"
            endPin.coordinate = locationdatas.last!
            mapView.addAnnotation(endPin)
        }
    }
//    func shareing
}
extension FinishExerciseViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MKPolyline else { return MKOverlayRenderer() }
        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = .blue
        renderer.lineWidth = 2.0
        renderer.alpha = 1.0

        return renderer
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        } else {
            annotationView?.annotation = annotation
        }
        switch annotation.title {
        case "start":
            annotationView?.image = UIImage(named: "startPin")
        case "end":
            annotationView?.image = UIImage(named: "endPin")
        default:
            break
        }
        return annotationView
    }
}

//#Preview {
//    FinishExerciseView()
//}
