//
//  MapViewController.swift
//  harakaMap
//
//  Created by Noura AlSheikh on 26/02/2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
  @IBOutlet private var mapView: MKMapView!
  private var places: [Place] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Set initial location in Riyadh
    let initialLocation = CLLocation(latitude: 24.72513829905613, longitude: 46.63842262615593)
    mapView.centerToLocation(initialLocation) //calls the helper method to zoom into initialLocation on startup.,
    
    let ksu = CLLocation(latitude: 24.72513829905613, longitude: 46.63842262615593)
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
    
    mapView.register(
      PlaceViews.self,
      forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    
    loadInitialData()
    mapView.addAnnotations(places)
    
    // Show artwork on map
    let place1 = Place(
      title: "يو ووك",
      locationName: "طريق الأمير تركي الأول - مشي",
      discipline: "walk",
      coordinate: CLLocationCoordinate2D(latitude: 24.741042485669134, longitude: 46.62653397827402))
    mapView.addAnnotation(place1)
    
    let place2 = Place(
      title: "ممشى الملك عبدالله",
      locationName: "طريق الملك عبدالله - مشي",
      discipline: "walk",
      coordinate: CLLocationCoordinate2D(latitude: 24.742934276234724, longitude: 46.703443637806224))
    mapView.addAnnotation(place2)
    
    let place3 = Place(
      title: "حافة العالم - Edge of the world",
      locationName: "العويند - هايكنج",
      discipline: "hike",
      coordinate: CLLocationCoordinate2D(latitude: 24.947868095083106, longitude: 45.99190667378752))
    mapView.addAnnotation(place3)
    
    let place4 = Place(
      title: "أكاديمية التنس",
      locationName: "حي السفارات - تنس",
      discipline: "tennis",
      coordinate: CLLocationCoordinate2D(latitude: 24.674752468495022, longitude: 46.62427472592714))
    mapView.addAnnotation(place4)
    
    let place5 = Place(
      title: "الأكاديمية الأوروبية لكرة القدم",
      locationName: "حي الازدهار - كرة قدم",
      discipline: "soccer",
      coordinate: CLLocationCoordinate2D(latitude: 24.787239556871572, longitude: 46.71031995208695))
    mapView.addAnnotation(place5)
    
  }
  
  private func loadInitialData() {
    // 1
    guard
      let fileName = Bundle.main.url(forResource: "Locations", withExtension: "geojson"),
      let locationsData = try? Data(contentsOf: fileName)
      else {
        return
    }
    
    do {
      // 2
      let features = try MKGeoJSONDecoder()
        .decode(locationsData)
        .compactMap { $0 as? MKGeoJSONFeature }
      // 3
      let validWorks = features.compactMap(Place.init)
      // 4
      places.append(contentsOf: validWorks)
    } catch {
      // 5
      print("Unexpected error: \(error).")
    }
  }
}

private extension MKMapView {
  func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)//tells MKMapView to display the region represented by MKCoordinateRegion
  }
}//

extension MapViewController: MKMapViewDelegate {
  func mapView(
    _ mapView: MKMapView,
    annotationView view: MKAnnotationView,
    calloutAccessoryControlTapped control: UIControl
  ) {
    guard let place = view.annotation as? Place else {
      return
    }
    
    let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
    place.mapItem?.openInMaps(launchOptions: launchOptions)
  }
}
