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
        private var viewModel: ExerciseViewModel?
        private lazy var mapView = MKMapView().then {
            $0.delegate = self
            $0.showsUserLocation = true
            $0.userTrackingMode  = .followWithHeading
            $0.addGestureRecognizer(UIPanGestureRecognizer())

        }
        override func viewDidLoad() {
            super.viewDidLoad()
            viewModel?.startTracking()
        }

        func configureUI() {
            self.view.addSubview(mapView)
            mapView.snp.makeConstraints {
                $0.left.right.top.bottom.equalToSuperview()
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
    }
