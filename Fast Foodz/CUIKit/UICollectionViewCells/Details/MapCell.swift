//
//  MapCell.swift
//  CUIKit
//.
//  Created by Vlad Z. on 1/30/20.
//

import UIKit
import MapKit
import CoreLocation

public struct MapCellConfig {
    public var coordinates: CLLocationCoordinate2D
    public var strokeColor: UIColor
    public var strokeWidth: CGFloat
    
    public init(coordinates: CLLocationCoordinate2D,
                strokeColor: UIColor,
                strokeWidth: CGFloat) {
        self.coordinates = coordinates
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
    }
}

public class MapCell: UICollectionViewCell, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet public weak var mapView: MKMapView?
    let locationManager = CLLocationManager()
    
    public var renderer: MKPolylineRenderer?
    
    var config: MapCellConfig?
    public func configure(_ config: MapCellConfig) {
        self.config = config
        setupLocationServices()
    }
    
    private func setupLocationServices() {
        let authorizationStatus = CLLocationManager.authorizationStatus()

        if authorizationStatus == CLAuthorizationStatus.notDetermined {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        
        if let config = config {
            renderer?.lineWidth = config.strokeWidth
            renderer?.strokeColor = config.strokeColor
        }
        
        return renderer!
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        processLocation(for: locValue.latitude, longitude: locValue.longitude)
    }
    
    func processLocation(for latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        guard let config = config else { return }
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: config.coordinates.latitude, longitude: config.coordinates.longitude), addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile

        let directions = MKDirections(request: request)

        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }

            for route in unwrappedResponse.routes {
                self.mapView?.addOverlay(route.polyline)
                self.mapView?.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
}
