//
//  Extension+MKMapView.swift
//  Plogging
//
//  Created by HONORE Adeline on 17/10/2022.
//

import MapKit

extension MKMapView {
  func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 30000) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
