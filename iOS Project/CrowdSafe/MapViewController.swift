//
//  MapViewController.swift
//  CrowdSafe
//
//  Created by Arman Vaziri on 5/9/20.
//  Copyright © 2020 ArmanVaziri. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
//    var locationManager: CLLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        locationManager.delegate = self
        mapView.delegate = self
        setupMap()
    }
    
    func setupMap() {
        
        mapView.showsPointsOfInterest = false
        
        let latitude = 37.866974
        let longitude = -122.256044
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025))
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = "Crossroads cafeteria"
        annotation.subtitle = "Tap the blue button for info"
        annotation.coordinate = center
        mapView.addAnnotation(annotation)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        print("ANNOTATIONVIEW SET UP")
        
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Crossroads")
        annotationView.isEnabled = true
        annotationView.canShowCallout = true
        let btn = UIButton(type: .detailDisclosure)
        annotationView.rightCalloutAccessoryView = btn
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        print("ANNOTATIONVIEW TAPPED")
        
        performSegue(withIdentifier: "mapToMain", sender: view)
        
    }
    

}
