//
//  MusicListViewController.swift
//  MusiFi
//
//  Created by Andrei Rybak on 3/27/17.
//  Copyright © 2017 Andrei Rybak. All rights reserved.
//

import UIKit


class MusicListViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var tracks: Array<Track> = []

    fileprivate struct Constants {
        static let cellNibName = "MusicListTableCell"
        static let cellReuseIdentifier = "musicListCell"
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.dark
        self.tableView.backgroundColor = Colors.dark
        self.navigationController?.navigationBar.barTintColor = Colors.dark
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        
        tableView.register(UINib.init(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellReuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 90.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        addMyFavoriteButton()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //TODO: REQUEST FOR ITEMS
        getAllTrack()
       
    }
    
    fileprivate func getAllTrack() {
//        let t1 = Track()
//        t1.artist = "The Neighbourhood"
//        t1.name = "West Coast"
//        
//        let t2 = FakeTrack()
//        t2.artist = "RÜFÜS"
//        t2.name = "Sarah"
//        
//        let t3 = FakeTrack()
//        t3.artist = "Miss Li"
//        t3.name = "Aualung"
//        
//        let t4 = FakeTrack()
//        t4.artist = "Calum Scott"
//        t4.name = "Dancing on my own"
//        
//        let t5 = FakeTrack()
//        t5.artist = "Ladi6"
//        t5.name = "Automatic"
//        
//        self.tracks = [t1,t2,t3,t4,t5]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func addMyFavoriteButton() {
        let button = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(showFavoriteController))
        button.tintColor = Colors.orange
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc fileprivate func showFavoriteController() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let favoriteVC = sb.instantiateViewController(withIdentifier: "favoriteListViewController") as! FavoriteListViewController
        self.navigationController?.show(favoriteVC, sender: self)

    }
}

extension MusicListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count //TODO: NUMBER OF ITEMS FROM REQUEST
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicListCell", for: indexPath) as! MusicListTableCell
        //TODO: CONFIGURE CELL
        //TODO: Configure like button
//        cell.likeButton?.isSelected = true
//        cell.likeButton?.isEnabled = false
        cell.imageView?.image = UIImage(named: "default_placeholder")
        cell.authorLabel.text = tracks[indexPath.row].artist
        cell.trackNameLabel.text = tracks[indexPath.row].name
        return cell
    }
    
}
