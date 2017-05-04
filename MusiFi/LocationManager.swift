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

class LocationManager: CLLocationManager {
    
    static let sharedInstance = LocationManager()
    
    private override init() {
        super.init()
    }

}
