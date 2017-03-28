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
    var locationManager: LocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = LocationManager.sharedInstance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    
}
