//
//  MapViewController.swift
//  harakaMap
//
//  Created by Noura AlSheikh on 26/02/2021.
//

import UIKit
import MapKit
import AMTabView


class MapViewController: UIViewController , TabItem{
  @IBOutlet private var mapView: MKMapView!
    private var places: [Place] = []
   // tab bar
    var tabImage2: UIImage? {
      return UIImage(named: " 568635131536669843-129")
    }
      
      override func viewDidLoad() {
        super.viewDidLoad()
        // Set initial location in Riyadh
        let initialLocation = CLLocation(latitude: 24.72513829905613, longitude: 46.63842262615593)
        mapView.centerToLocation(initialLocation)
        
        let ksu = CLLocation(latitude: 24.72513829905613, longitude: 46.63842262615593)
        let region = MKCoordinateRegion(
          center: ksu.coordinate,
          latitudinalMeters: 70000, longitudinalMeters: 70000)
        mapView.setCameraBoundary(
          MKMapView.CameraBoundary(coordinateRegion: region),
          animated: true)
        
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 500000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
        mapView.delegate = self
        
        mapView.register(
          PlaceViews.self,
          forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        
        // Show artwork on map
        let place1 = Place(
          title: "يو ووك",
          locationName: "طريق الأمير تركي الأول - مشي",
          discipline: "walk",
          coordinate: CLLocationCoordinate2D(latitude: 24.741042485669134, longitude: 46.62653397827402))
     
        
        let place2 = Place(
          title: "ممشى الملك عبدالله",
          locationName: "طريق الملك عبدالله - مشي",
          discipline: "walk",
          coordinate: CLLocationCoordinate2D(latitude: 24.742934276234724, longitude: 46.703443637806224))
     
        
        let place3 = Place(
          title: "حافة العالم - Edge of the world",
          locationName: "العويند - هايكنج",
          discipline: "hike",
          coordinate: CLLocationCoordinate2D(latitude: 24.947868095083106, longitude: 45.99190667378752))
       
        
        let place4 = Place(
          title: "أكاديمية التنس",
          locationName: "حي السفارات - تنس",
          discipline: "tennis",
          coordinate: CLLocationCoordinate2D(latitude: 24.674752468495022, longitude: 46.62427472592714))
       
        
        let place5 = Place(
          title: "الأكاديمية الأوروبية لكرة القدم",
          locationName: "حي الازدهار - كرة قدم",
          discipline: "soccer",
          coordinate: CLLocationCoordinate2D(latitude: 24.787239556871572, longitude: 46.71031995208695))
       
        let place6 = Place(
          title: "نادي الأغر للفروسية",
          locationName: "حي السفارات - فروسية",
          discipline: "horse",
          coordinate: CLLocationCoordinate2D(latitude: 24.69342982140788, longitude: 46.62286518384784))
        
        let place7 = Place(
          title: "مسار وادي حنيفة",
          locationName: "وادي حنيفة - ركوب دراجة",
          discipline: "bike",
          coordinate: CLLocationCoordinate2D(latitude: 24.593810799138407, longitude: 46.705269118497796))
        
        let place8 = Place(
          title: "مسار وادي لبن",
          locationName: "وادي لبن - ركوب دراجة",
          discipline: "bike",
          coordinate: CLLocationCoordinate2D(latitude: 24.606737202055825, longitude: 46.546039053161095))
     
        
        let place9 = Place(
          title: "ممشى حديقة حي النهضة",
          locationName: "حي النهضة - مشي",
          discipline: "walk",
          coordinate: CLLocationCoordinate2D(latitude:24.686599801657845, longitude:  46.75489885316269))
        
        places.append(place1)
        places.append(place2)
        places.append(place3)
        places.append(place4)
        places.append(place5)
        places.append(place6)
        places.append(place7)
        places.append(place8)
        places.append(place9)
        
        
        for count in 0...8{
        mapView.addAnnotation(places[count])
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
    }
     
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
