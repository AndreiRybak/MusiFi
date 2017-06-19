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
    
    fileprivate func deleteFavoriteTrack(track: FavoriteTrack) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let namePredicate = NSPredicate(format:"name == %@", track.name!)
        let artistPredicate = NSPredicate(format:"artist == %@", track.artist!)
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteTrack")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [namePredicate, artistPredicate])
        fetchRequest.predicate = compoundPredicate
    
        do {
            if let tracks = try? managedContext.fetch(fetchRequest) {
                for track in tracks {
                    managedContext.delete(track)
                }
            }
        }
        
        do {
            try managedContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
}

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

        let dataDecoded : Data = Data(base64Encoded: track.value(forKey: "image") as! String, options: .ignoreUnknownCharacters)!
        if let image = UIImage(data: dataDecoded) {
            cell.trackImage?.image = image
        } else {
            cell.trackImage?.image = UIImage(named: "default_placeholder")
        }
        
        cell.authorLabel.text = track.value(forKey: "artist") as? String
        cell.trackNameLabel.text = track.value(forKey: "name") as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteFavoriteTrack(track: tracks[indexPath.row] as! FavoriteTrack)
            tracks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .none)
        }
    }

}
