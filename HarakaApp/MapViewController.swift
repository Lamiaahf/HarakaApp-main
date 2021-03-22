//
//  MapViewController.swift
//  HarakaApp
//
//  Created by Noura AlSheikh on 23/02/2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet private var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set initial location in Riyadh
        let initialLocation = CLLocation(latitude: 24.774265, longitude: 46.774265)
        mapView.centerToLocation(initialLocation)
        
        let ksu = CLLocation(latitude: 24.7264101, longitude: 46.6278917)
        let region = MKCoordinateRegion(
          center: ksu.coordinate,
          latitudinalMeters: 50000,
          longitudinalMeters: 60000)
        mapView.setCameraBoundary(
          MKMapView.CameraBoundary(coordinateRegion: region),
          animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        mapView.setCameraZoomRange(zoomRange, animated: true)

        mapView.delegate = self
        
        let location = activityLocations(
          locationName: "ممشى الملك عبدالله",
            description: "خارجي-هادئ-مناسب في جميع أوقات اليوم",
          classification: "Walking",
            coordinate: CLLocationCoordinate2D(latitude: 24.7426030, longitude: 46.7035402))
        mapView.addAnnotation(location)
       
    }
    
}
private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

extension ViewController: MKMapViewDelegate {
  // 1
  func mapView(
    _ mapView: MKMapView,
    viewFor annotation: MKAnnotation
  ) -> MKAnnotationView? {
    // 2
    guard let annotation = annotation as? activityLocations else {
      return nil
    }
    // 3
    let identifier = "location"
    var view: MKMarkerAnnotationView
    // 4
    if let dequeuedView = mapView.dequeueReusableAnnotationView(
      withIdentifier: identifier) as? MKMarkerAnnotationView {
      dequeuedView.annotation = annotation
      view = dequeuedView
    } else {
      // 5
      view = MKMarkerAnnotationView(
        annotation: annotation,
        reuseIdentifier: identifier)
      view.canShowCallout = true
      view.calloutOffset = CGPoint(x: -5, y: 5)
      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    return view
  }
}
