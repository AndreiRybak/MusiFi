//
//  MusicMapViewController.swift
//  MusiFi
//
//  Created by Andrei Rybak on 3/27/17.
//  Copyright © 2017 Andrei Rybak. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MusicMapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()


    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span = MKCoordinateSpanMake(0.2, 0.2)
        let myLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
    
    
}
