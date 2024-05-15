    //
    //  ExerciseViewController.swift
    //  GND
    //
    //  Created by 235 on 5/12/24.
    //

    import UIKit
    import MapKit
    import Then
    import Combine
    import SnapKit
    class ExerciseViewController: UIViewController {
        private var cancellables = Set<AnyCancellable>()
         var viewModel: ExerciseViewModel?
        private lazy var mapView = MKMapView().then {
            $0.delegate = self
            $0.showsUserLocation = true
            $0.userTrackingMode  = .followWithHeading
            $0.addGestureRecognizer(UIPanGestureRecognizer())
        }
        let progressBar = UIProgressView().then {
            $0.progress = 0.1
            $0.trackTintColor = CustomColors.brown
            $0.backgroundColor = .systemGray
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8

        }
        lazy var exerciseBar = UIView().then {
            $0.backgroundColor = .white
            let stopButton = UIButton().then {
                $0.setTitle("종료", for: .normal)
                $0.titleLabel?.font = .systemFont(ofSize: 32)
                $0.titleLabel?.textColor = .white
                $0.backgroundColor = CustomColors.brown
                $0.addTarget(self, action: #selector(stopExercise), for: .touchUpInside)
                $0.layer.cornerRadius = 8
            }
            var config = UIImage.SymbolConfiguration(hierarchicalColor: .brown)
            config = config.applying(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 48)))
            let footIcon = UIImage(systemName: "shoeprints.fill", withConfiguration: config)
            let imageView = UIImageView(image: footIcon)
            $0.addSubview(imageView)
            $0.addSubview(progressBar)
            $0.addSubview(stopButton)
            imageView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(16)
                $0.top.equalToSuperview().offset(24)
                $0.bottom.equalToSuperview().inset(64)
            }
            progressBar.snp.makeConstraints {
                $0.leading.equalTo(imageView.snp.trailing).offset(16)
                $0.trailing.equalToSuperview().inset(16)
                $0.top.equalToSuperview().offset(32)
                $0.height.equalTo(24)
            }
            stopButton.snp.makeConstraints {
                $0.top.equalTo(progressBar.snp.bottom).offset(8)
                $0.bottom.equalToSuperview().inset(8)
                $0.trailing.equalToSuperview().inset(16)
                $0.width.equalTo(94)
                $0.height.equalTo(52).priority(.low)
            }

        }
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .background
            viewModel?.startTracking()
            configureUI()
            bindViewModel()
        }

        func configureUI() {
            self.view.addSubview(mapView)
            self.view.addSubview(exerciseBar)
            exerciseBar.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview().inset(self.tabBarController?.tabBar.frame.height ?? 49)
                $0.height.equalTo(132)
            }
            mapView.snp.makeConstraints {
                $0.top.left.right.equalToSuperview()
                $0.bottom.equalTo(exerciseBar.snp.top)
            }

        }

        func bindViewModel() {
            viewModel?.locationUpdatesPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] coordinates in
                    self?.updateMap(with: coordinates)

                }.store(in: &cancellables)
        }
        func updateMap(with coordinates: [CLLocationCoordinate2D]) {
            let polyLine = MKPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(polyLine)
        }
        @objc func stopExercise() {
            viewModel?.stopTracking()
        }
    }
    extension ExerciseViewController: MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
            guard let polyLine = overlay as? MKPolyline else { return MKOverlayRenderer() }

            let renderer = MKPolylineRenderer(polyline: polyLine)
            renderer.strokeColor = .black
            renderer.lineWidth = 5.0
            renderer.alpha = 1.0

            return renderer
        }
        func drawLine(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) {
            let coordinates = [start, end]
            let line = MKPolyline(coordinates: coordinates, count: coordinates.count)
            self.mapView.addOverlay(line)
        }
    }
