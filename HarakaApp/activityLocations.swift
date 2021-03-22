//
//  activityLocations.swift
//  HarakaApp
//
//  Created by Noura AlSheikh on 23/02/2021.
//

import Foundation
import MapKit

class activityLocations: NSObject, MKAnnotation {
  let title: String?
  let locationName: String?
  let classification: String?
  let coordinate: CLLocationCoordinate2D

  init(
    title: String?,
    locationName: String?,
    classification: String?,
    coordinate: CLLocationCoordinate2D
  ) {
    self.title = title
    self.locationName = locationName
    self.classification = classification
    self.coordinate = coordinate

    super.init()
  }

  var subtitle: String? {
    return locationName
  }
}
