//
//  FavoriteListViewController.swift
//  MusiFi
//
//  Created by Andrei Rybak on 5/11/17.
//  Copyright © 2017 Andrei Rybak. All rights reserved.
//

import UIKit
import CoreData

class FavoriteListViewController: UIViewController {

    fileprivate struct NibName {
        static let cellNibName = "FavoriteListTableCell"
        static let cellReuseIdentifier = "favoriteListCell"
    }

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var tracks: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.dark
        self.tableView.backgroundColor = Colors.dark
        
        tableView.register(UINib.init(nibName: NibName.cellNibName, bundle: nil), forCellReuseIdentifier: NibName.cellReuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 90.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.backBarButtonItem?.tintColor = Colors.orange
        self.navigationController?.navigationBar.tintColor = Colors.orange
        
        fetchTracks()
    }
    
    fileprivate func fetchTracks() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteTrack")
        
        do {
            tracks = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

//TODO: DELETE ROWS WHEN CORE DATA WILL BE IMPLEMENTED

extension FavoriteListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteListCell", for: indexPath) as! FavoriteListTableCell
        let track = tracks[indexPath.row]
        //TODO: CONFIGURE CELL
        cell.imageView?.image = UIImage(named: "default_placeholder")
        cell.authorLabel.text = track.value(forKey: "artist") as? String
        cell.trackNameLabel.text = track.value(forKey: "name") as? String
        return cell
    }

}
