//
//  MapViewController.swift
//  MyApp
//
//  Created by MBA0103 on 8/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

  weak var mapView: MKMapView!

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Map"
    configLocationServices()
    configMapView()
    addAnnotation()
    // addOverlayData()
  }

  func configLocationServices() {
    AppDelegate.shared.configLocationService()
  }

  func configMapView() {
    // Add map view
    let mapView = MKMapView(frame: UIScreen.main.bounds)
    self.mapView = mapView
    view.addSubview(mapView)

    // Setting the Visible Portion of the Map
    let center = CLLocationCoordinate2D(latitude: 16.078906, longitude: 108.232525) // This is coordinate of Hai Chau district of Da Nang city
    let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    mapView.region = MKCoordinateRegion(center: center, span: span)

    // Display 3D map
    /*
     let eyeCoordinate = CLLocationCoordinate2D(latitude: 16.05, longitude: 108.17)
     mapView.camera = MKMapCamera(lookingAtCenter: center, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 1000)
     */

    // Show user location
    mapView.showsUserLocation = true

    // Using delegate of map view to response user interactions
    mapView.delegate = self
  }

  func addAnnotation() {
    let annotation = MKPointAnnotation()
    annotation.coordinate = CLLocationCoordinate2D(latitude: 16.044, longitude: 108.172)
    annotation.title = "Point Annotation"
    annotation.subtitle = "Point annotation information"
    mapView.addAnnotation(annotation)
  }

  func addOverlayData() {
    let coordinates = [CLLocationCoordinate2D(latitude: 16.0472484, longitude: 108.1716005),
                       CLLocationCoordinate2D(latitude: 16.0432484, longitude: 108.1736005),
                       CLLocationCoordinate2D(latitude: 16.0412484, longitude: 108.1776005)]
    for center in coordinates {
      let radius = 1000.0 // Distance unit: meters
      let overlayData = MKCircle(center: center, radius: radius)
      mapView.add(overlayData)
    }
  }
}

extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let pin = MKPinAnnotationView(annotation: annotation,
                                  reuseIdentifier: "MKPinAnnotationView")
    pin.animatesDrop = true
    pin.pinTintColor = .green
    pin.canShowCallout = true
    pin.leftCalloutAccessoryView = UIImageView(image: nil)
    pin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    return pin
  }

  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    print("Did select")
  }

  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
               calloutAccessoryControlTapped control: UIControl) {
    print("Callout")
  }

  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    guard let circle = overlay as? MKCircle else { return MKOverlayRenderer() }
    let circleRenderer = MKCircleRenderer(circle: circle)
    circleRenderer.fillColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 0.3)
    circleRenderer.strokeColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 0.7)
    circleRenderer.lineWidth = 3
    circleRenderer.lineDashPhase = 10
    return circleRenderer
  }
}
