//
//  SessionController.swift
//  MusiFi
//
//  Created by Andrei Rybak on 3/27/17.
//  Copyright © 2017 Andrei Rybak. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SessionController {
    
    static func sendTrack(track: Track) {
        let url = URL(string: "https://musifi.herokuapp.com/api/locations")
        
        let name = track.name
        let artist = track.artist
        
        let image: String?
        if let trackImage = track.image {
            image = trackImage
        } else {
            image = ""
        }
        
        let longitude = track.longitude
        let latitude = track.latitude
        
        let parameters: Parameters = ["name":"\(name)", "artist": "\(artist)", "image": "\(image!)", "longitude": "\(longitude)", "latitude": "\(latitude)"]
        
        Alamofire.request((url?.absoluteString)!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (data) in
            print(data)
        }
    }

    static func getTracks(callback: @escaping ([Track]) -> ()) {
        let url = URL(string: "https://musifi.herokuapp.com/api/locations")
        var tracks: [Track] = []
        
        Alamofire.request((url?.absoluteString)!).responseJSON { response in

            guard let objects = response.result.value as? NSArray else { return }

            for object in objects {
                if let object  = object as? [String: Any] {
                    let name = object["name"] as? String
                    let artist = object["artist"] as? String
                    let image = object["image"] as? String
                    let latitude = object["latitude"] as? String
                    let longitude = object["longitude"] as? String
                    let track = Track(name: name!, artist: artist!, image: image!, longitude: longitude!, latitude: latitude!)
                    tracks.append(track)
                }
            }
            callback(tracks)
        }
    }
    
}
