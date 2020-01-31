//
//  BusinessesPlacesViewController.swift
//  BusinessesPlacesModule
//
//  Created by Vlad Z. on 1/31/20.
//

import CUIKit
import CFoundation

import MapKit
import CoreLocation

import MERLin

class BusinessesPlacesViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    var mapView: MKMapView = MKMapView() <~ {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var datasource: [BusinessPin] = []
    var viewModel: BusinessesPlacesViewModel
    var annotationsArray: [MKPointAnnotation] = []
    
    private let actions = PublishSubject<BusinessesPlacesUIAction>()
    
    init(with viewModel: BusinessesPlacesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        
        mapView.delegate = self
    }
    
    private func layout() {
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        let states = viewModel.transform(input: actions).publish()
        
        states.capture(case: BusinessesPlacesState.pages)
            .asDriverIgnoreError()
            .drive(onNext: { [weak self] rows in
                self?.datasource = rows
                self?.addAnnotationsToMap()
            })
            .disposed(by: disposeBag)
    
        states.connect()
            .disposed(by: disposeBag)
    }
}

extension BusinessesPlacesViewController: MKMapViewDelegate {
    private func addAnnotationsToMap() {
        clearAnnotationsOnMap()
        
        for pin in datasource {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(pin.coordinates.latitude),
                                                               CLLocationDegrees(pin.coordinates.longitude))
            annotation.title = String(format: "%i", pin.title)
            annotationsArray.append(annotation)
            mapView.addAnnotation(annotation)
        }
        
        zoomToFitMapAnnotations()
    }
    
    fileprivate func clearAnnotationsOnMap() {
        mapView.removeAnnotations(annotationsArray)
    }
    
    private func zoomToFitMapAnnotations() {
        guard annotationsArray.isEmpty else { return }
        
        var topLeftCoordinate = CLLocationCoordinate2DMake(-90, 180)
        var bottomRightCoordinate = CLLocationCoordinate2DMake(90, -180)
        
        for annotation in annotationsArray {
            topLeftCoordinate.latitude = max(topLeftCoordinate.latitude, annotation.coordinate.latitude)
            topLeftCoordinate.longitude = min(topLeftCoordinate.longitude, annotation.coordinate.longitude)
            
            bottomRightCoordinate.latitude = min(bottomRightCoordinate.latitude, annotation.coordinate.latitude)
            bottomRightCoordinate.longitude = max(bottomRightCoordinate.longitude, annotation.coordinate.longitude)
        }
        
        var region = MKCoordinateRegion()
        region.center.latitude = topLeftCoordinate.latitude - (topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 0.5
        region.center.longitude = topLeftCoordinate.longitude + (bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 0.5
        region.span.latitudeDelta = abs(topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 1.8
        region.span.longitudeDelta = abs(bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 2.0
        
        region = mapView.regionThatFits(region)
        mapView.setRegion(region, animated: false)
    }
    
    private func adjustMapRegion(forCoordinate coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 3200, longitudinalMeters: 3200)
        let adjustedRegion = mapView.regionThatFits(region)
        mapView.setRegion(adjustedRegion, animated: true)
    }
}
