//
//  ResultsViewController.swift
//  specTro
//
//  Created by Amirsaman Fazelipour on 2020-10-24.
//
import UIKit
import MapKit
import Charts
import CoreLocation
import Charts

var annotations: [[String : Any]] = []
var receivedLat: String?
var receivedLon: String?
var receivedDur: String?
var PM1: [Int] = []
var PM25: [Int] = []
var PM10: [Int] = []
var lenPM: Int = 0

var selectedAnnotationLat: String?
var selectedAnnotationLon: String?

class MapViewController: HomeViewController {
         
    @IBOutlet private var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    static var currentCoordinate: CLLocationCoordinate2D?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeVideoPlayerWithVideo(viewName: "Map")
        player?.play()

        mapView.delegate = self
        let initLatitude = MapViewController.currentCoordinate?.latitude ?? 49.2827
        let initLongitude = MapViewController.currentCoordinate?.longitude ?? -123.1207
        let initialLocation = CLLocation(latitude: initLatitude, longitude: initLongitude)

        mapView.centerToLocation(initialLocation)
        
        createAnnotations(locations: defaults.object(forKey: "annotations") as? [[String : Any]] ?? annotations)

        configureLocationServices()
        
        
        
    }
    
    func configureLocationServices() {
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        if status  == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        else if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: locationManager)
            
        }
    }
    
    func createAnnotations(locations: [[String : Any]]) {
        for location in locations {
            let annotations = MKPointAnnotation()
            annotations.title = location["title"] as? String
            annotations.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! CLLocationDegrees, longitude: location["longitude"] as! CLLocationDegrees)
            
            mapView.addAnnotation(annotations)
        }
    }
    
    private func beginLocationUpdates(locationManager: CLLocationManager) {
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        let zoomRegion = MKCoordinateRegion(center: coordinate , latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(zoomRegion, animated: true)
    }

    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("got last location")
        
        guard let latestLocation = locations.first else { return }
        
        if MapViewController.currentCoordinate == nil {
            zoomToLatestLocation(with: latestLocation.coordinate )
        }
        
        MapViewController.currentCoordinate  = latestLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("status changed")
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: manager)
        }
    }
}

extension MapViewController: MKMapViewDelegate  {
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if annotation is MKUserLocation {
            mapView.tintColor = UIColor .systemBlue
            return nil

        }
        else {
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
            }

            let image = UIImage(named: "chart")
            let resizedSize = CGSize(width: 40, height: 40)

            UIGraphicsBeginImageContext(resizedSize)
            image?.draw(in: CGRect(origin: .zero, size: resizedSize))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            annotationView?.image = resizedImage
            annotationView?.canShowCallout = true
            return annotationView

        }
    }
    
    // can detect which annotation was selected and send correct data to results
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let selectedAnnotation = view.annotation
        let lat = String((selectedAnnotation?.coordinate.latitude)!)
        let lon = String((selectedAnnotation?.coordinate.longitude)!)
        selectedAnnotationLat = lat
        selectedAnnotationLon = lon
        self.performSegue(withIdentifier: "ResultsSegue", sender: self)
        
    }
}



private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

