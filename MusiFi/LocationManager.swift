//
//  LocationManager.swift
//  MusiFi
//
//  Created by Andrei Rybak on 3/27/17.
//  Copyright © 2017 Andrei Rybak. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager:NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationManager()
    
    var locationManager: CLLocationManager!
    
    var latitude: Double!
    var longitude: Double!
    
    private override init() {
        super.init()
        locationManager = CLLocationManager()
        self.setupLocationManager()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func getCurrentLocation() -> [String:Double] {
        latitude = locationManager.location?.coordinate.latitude as! Double
        longitude = locationManager.location?.coordinate.longitude
        let cooridnate = ["latitude":latitude, "longitude":longitude]
        return cooridnate
    }
    
    fileprivate func setupLocationManager() {
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }

}
