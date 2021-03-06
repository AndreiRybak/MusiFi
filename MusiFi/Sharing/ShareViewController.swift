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
import KDCircularProgress

internal struct Colors {
    static let dark = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
    static let gray = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1)
    static let orange = UIColor(red: 246/255, green: 166/255, blue: 12/255, alpha: 1)
}

class ShareViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet fileprivate weak var musiFiLabel: UILabel!
    
    @IBOutlet fileprivate weak var progressiveView: KDCircularProgress!
    @IBOutlet fileprivate weak var shareButton: UIButton!
    @IBOutlet fileprivate weak var shareButtonImage: UIImageView!
    
    @IBOutlet fileprivate weak var noteView: UIView!
    @IBOutlet fileprivate weak var noteHeader: UILabel!
    @IBOutlet fileprivate weak var noteImage: UIImageView!
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate var latitude: String?
    fileprivate var longitude: String?
    
    internal var nowPlayingInfo:[String:Any] = [:]
    
    fileprivate var previosPlayingItem: MPMediaItem? = nil
    
    fileprivate var uuid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uuid = UIDevice.current.identifierForVendor?.uuidString
        
        configureUI()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    fileprivate func configureUI() {
        
        self.view.backgroundColor = Colors.dark
        
        musiFiLabel.textColor = Colors.orange
        
        shareButton.layer.cornerRadius = 0.5 * shareButton.bounds.size.width
        
        progressiveView.angle = 0
        progressiveView.trackColor = Colors.orange
        progressiveView.progressInsideFillColor = Colors.orange
        
        noteView.backgroundColor = Colors.gray
        noteView.layer.cornerRadius = 16
        setAttributedText()
        
        tabBarController?.tabBar.tintColor = Colors.orange
        tabBarController?.tabBar.barTintColor = Colors.dark
        
        startRotateAnimation(image: noteImage, repeating: true)
    }
    
    fileprivate func setAttributedText() {
        
        let musiFiString = NSString(string:"Share your music with MusiFi")
        let attributedString = NSMutableAttributedString(string: musiFiString as String)
        let range = musiFiString.range(of: "MusiFi")
        attributedString.addAttribute(NSForegroundColorAttributeName, value: Colors.orange, range: range)
        noteHeader.attributedText = attributedString
    }
    
    fileprivate func startRotateAnimation(image: UIImageView, repeating: Bool) {
        let fullRotation = CGFloat(Double.pi * 2)
        let duration = 1.7
        let delay = 0.0
        let options = UIViewKeyframeAnimationOptions.calculationModeLinear
        
        UIView.animateKeyframes(withDuration: duration, delay: delay, options: options, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/3, animations: {
                image.transform = CGAffineTransform(rotationAngle: 1/3 * fullRotation)
            })
            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
                image.transform = CGAffineTransform(rotationAngle: 2/3 * fullRotation)
            })
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
                image.transform = CGAffineTransform(rotationAngle: 3/3 * fullRotation)
            })
            
        }, completion: { finished in
            if repeating {
                self.startRotateAnimation(image: image, repeating: repeating)
            }
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func shareButtonPressed(_ sender: UIButton?) {
        
        shareButton.isEnabled = false
        startRotateAnimation(image: shareButtonImage, repeating: false)
        
        progressiveView.animate(toAngle: 360, duration: 1.5) { [weak self] (complete) in
            guard let strongSelf = self else { return }
            
            let player = MPMusicPlayerController()
            guard (player.nowPlayingItem != nil) && (player.nowPlayingItem != strongSelf.previosPlayingItem) else {
                strongSelf.progressiveView.angle = 0
                strongSelf.shareButton.isEnabled = true
                return
            }
            strongSelf.previosPlayingItem = player.nowPlayingItem
            
            strongSelf.fetchMP3Info()
            strongSelf.writeLocation()
            strongSelf.sendData()
            strongSelf.progressiveView.angle = 0
            strongSelf.shareButton.isEnabled = true
        }
    }
    
    fileprivate func fetchMP3Info() {
        
        let player = MPMusicPlayerController()
        let playerItem = player.nowPlayingItem
        
        nowPlayingInfo["id"] = uuid
        nowPlayingInfo["favorite"] = false
        
        if let image = playerItem?.artwork?.image(at: CGSize(width: 70, height: 70)) {
            let imageData: Data = UIImagePNGRepresentation(image)!
            let imageBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            nowPlayingInfo["image"] = imageBase64
        }
        
        if let artist = playerItem?.artist {
            nowPlayingInfo["artist"] = artist
        }
        
        if let name = playerItem?.title {
            nowPlayingInfo["name"] = name
        }
        
    }
    
    fileprivate func writeLocation() {
        nowPlayingInfo["latitude"] = self.latitude
        nowPlayingInfo["longitude"] = self.longitude
    }
    
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        self.latitude = String(format: "%f", location.coordinate.latitude)
        self.longitude = String(format: "%f", location.coordinate.longitude)
    }
    
    fileprivate func sendData() {
        
        let name = nowPlayingInfo["name"] as? String
        let artist = nowPlayingInfo["artist"] as? String
        
        let image: String?
        if let trackImage = nowPlayingInfo["image"] as? String {
            image = trackImage
        } else {
            image = ""
        }
        
        let longitude = nowPlayingInfo["longitude"] as? String
        let latitude = nowPlayingInfo["latitude"] as? String
        
        let track = Track(name: name!, artist: artist!, image: image, longitude: "\(longitude!)", latitude: "\(latitude!)")
        SessionController.sendTrack(track: track)
        
        nowPlayingInfo.removeAll()
    }
}
