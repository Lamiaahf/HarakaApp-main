//
//  PlaceViews.swift
//  harakaMap
//
//  Created by Noura AlSheikh on 15/03/2021.
//

import Foundation
import MapKit

class PlaceMarkerViews: MKMarkerAnnotationView {
  override var annotation: MKAnnotation? {
    willSet {
      // 1
      guard let place = newValue as? Place else {
        return
      }
      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

      // 2
      markerTintColor = place.markerTintColor
      glyphImage = place.image
    }
  }
}

class PlaceViews: MKAnnotationView {
  override var annotation: MKAnnotation? {
    willSet {
      guard let place = newValue as? Place else {
        return
      }

      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 48, height: 48)))
      mapsButton.setBackgroundImage(#imageLiteral(resourceName: "Map"), for: .normal)
      rightCalloutAccessoryView = mapsButton

      image = place.image
      
      let detailLabel = UILabel()
      detailLabel.numberOfLines = 0
      detailLabel.font = detailLabel.font.withSize(12)
      detailLabel.text = place.subtitle
      detailCalloutAccessoryView = detailLabel
    }
  }
}
