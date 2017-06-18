//
//  FakeTrack.swift
//  MusiFi
//
//  Created by Andrei Rybak on 5/12/17.
//  Copyright © 2017 Andrei Rybak. All rights reserved.
//

import Foundation
import UIKit

class Track {
    
    var artist: String
    var name: String
    var image: String?
    var longitude: String
    var latitude: String

    init(name: String, artist: String, image: String?, longitude: String, latitude: String) {
        self.name = name
        self.artist = artist
        self.image = image
        self.longitude = longitude
        self.latitude = latitude
    }
}
