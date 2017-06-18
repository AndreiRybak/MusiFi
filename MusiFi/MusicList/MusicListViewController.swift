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
        super.viewWillAppear(animated)
       SessionController.getTracks { [weak self] (tracks) in
            guard let strongSelf = self else { return }
            strongSelf.tracks = tracks
            strongSelf.tableView.reloadData()
        }
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
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicListCell", for: indexPath) as! MusicListTableCell
        let track = tracks[indexPath.row]

        let dataDecoded : Data = Data(base64Encoded: track.image!, options: .ignoreUnknownCharacters)!
        if let image = UIImage(data: dataDecoded) {
            cell.trackImage?.image = image
        } else {
            cell.trackImage?.image = UIImage(named: "default_placeholder")
        }
        
        cell.authorLabel.text = track.artist
        cell.trackNameLabel.text = track.name
        
        return cell
    }
    
}
