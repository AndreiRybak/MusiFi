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
        return 10 //TODO: NUMBER OF ITEMS FROM REQUEST
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicListCell", for: indexPath) as! MusicListTableCell
        //TODO: CONFIGURE CELL
        cell.imageView?.image = UIImage(named: "default_placeholder")
        return cell
    }
    
}
