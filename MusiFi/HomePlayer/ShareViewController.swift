//
//  HomePlayerViewController.swift
//  MusiFi
//
//  Created by Andrei Rybak on 3/27/17.
//  Copyright © 2017 Andrei Rybak. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import MediaPlayer

class ShareViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var shareButton: UIButton!
    
    var nowPlayingInfo:[String:Any] = [:]
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate var latitude: Double = 0.0
    fileprivate var longitude: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    @IBAction func shareButtonPressed(_ sender: UIButton?) {
        fetchMP3Info()
        //SHOULD BE CALLED AFTER LOCATION UPDATE
        writeLocation()
        sendData()
    }

    
    fileprivate func fetchMP3Info() {
        
        let player = MPMusicPlayerController()
        let playerItem = player.nowPlayingItem
        
        if let image = playerItem?.artwork?.image(at: CGSize(width: 70, height: 70)) {
            nowPlayingInfo["image"] = image
        }
        
        if let artist = playerItem?.artist {
            nowPlayingInfo["artist"] = artist
        }
        
        if let title = playerItem?.title {
            nowPlayingInfo["title"] = title
        }
        
    }
    
    
    fileprivate func writeLocation() {
        nowPlayingInfo["latitude"] = self.latitude
        nowPlayingInfo["longitude"] = self.longitude
    }
    
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
    
    //Implement for send soundtrack Data
    fileprivate func sendData() {
        
    }
}
