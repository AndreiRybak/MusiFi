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

class ShareViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet fileprivate weak var musiFiLabel: UILabel!
    
    @IBOutlet fileprivate weak var progressiveView: KDCircularProgress!
    @IBOutlet fileprivate weak var shareButton: UIButton!
    
    @IBOutlet fileprivate weak var noteView: UIView!
    @IBOutlet fileprivate weak var noteHeader: UILabel!
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate var latitude: Double = 0.0
    fileprivate var longitude: Double = 0.0
    
    var nowPlayingInfo:[String:Any] = [:]
    
    @IBOutlet weak var shareButtonImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    fileprivate func configureUI() {
        
        self.view.backgroundColor = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
        
        musiFiLabel.textColor = UIColor(red: 251/255, green: 155/255, blue: 51/255, alpha: 1)
        
        shareButton.layer.cornerRadius = 0.5 * shareButton.bounds.size.width
        
        progressiveView.angle = 0
        progressiveView.trackColor = UIColor(red: 246/255, green: 166/255, blue: 12/255, alpha: 1)
        progressiveView.progressInsideFillColor = UIColor(red: 246/255, green: 166/255, blue: 12/255, alpha: 1)
        
        noteView.backgroundColor = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1)
        noteView.layer.cornerRadius = 16
        setAttributedText()
        
        tabBarController?.tabBar.tintColor = UIColor(red: 251/255, green: 155/255, blue: 51/255, alpha: 1)
        tabBarController?.tabBar.barTintColor = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
    
    }
    
    fileprivate func  setAttributedText() {
        
        let musiFiString = NSString(string:"Share your music with MusiFi")
        let attributedString = NSMutableAttributedString(string: musiFiString as String)
        let range = musiFiString.range(of: "MusiFi")
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 246/255, green: 166/255, blue: 12/255, alpha: 1), range: range)
        noteHeader.attributedText = attributedString
    }
    
    fileprivate func startAnimateShareButton() {
        let fullRotation = CGFloat(Double.pi * 2)
        let duration = 1.7
        let delay = 0.0
        let options = UIViewKeyframeAnimationOptions.calculationModeLinear
        
        UIView.animateKeyframes(withDuration: duration, delay: delay, options: options, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/3, animations: {
                self.shareButtonImage.transform = CGAffineTransform(rotationAngle: 1/3 * fullRotation)
            })
            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
                self.shareButtonImage.transform = CGAffineTransform(rotationAngle: 2/3 * fullRotation)
            })
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
                self.shareButtonImage.transform = CGAffineTransform(rotationAngle: 3/3 * fullRotation)
            })
            
        }, completion: {finished in
            
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func shareButtonPressed(_ sender: UIButton?) {
        
        shareButton.isEnabled = false
        startAnimateShareButton()
        
        progressiveView.animate(toAngle: 360, duration: 1.5) { [weak self] (complete) in
            guard let strongSelf = self else { return }
            
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
    
    //TODO: IMPLEMENT FOR SEND TRACK DATA
    fileprivate func sendData() {
        
    }
}
