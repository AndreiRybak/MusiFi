//
//  HomePlayerViewController.swift
//  MusiFi
//
//  Created by Andrei Rybak on 3/27/17.
//  Copyright © 2017 Andrei Rybak. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ShareViewController: UIViewController {
    
    var url:NSURL!
    let audioInfo = MPNowPlayingInfoCenter.default()
    var nowPlayingInfo:[String:Any] = [:]

    @IBAction func shareButtonPressed(_ sender: UIButton) {
        fetchMP3Info()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func fetchMP3Info() {
        
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
}
