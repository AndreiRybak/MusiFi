//
//  FavoriteListViewController.swift
//  MusiFi
//
//  Created by Andrei Rybak on 5/11/17.
//  Copyright © 2017 Andrei Rybak. All rights reserved.
//

import UIKit
import CoreData

class FavoriteListViewController: UIViewController, UISearchResultsUpdating {

    fileprivate struct NibName {
        static let cellNibName = "FavoriteListTableCell"
        static let cellReuseIdentifier = "favoriteListCell"
    }

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var tracks: [NSManagedObject] = []
    fileprivate var filteredTracks: [NSManagedObject] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
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
        setupSearchBar()
        setupSortButton()
    }
    
    fileprivate func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.backgroundColor = Colors.dark
        searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor = Colors.orange
        
        let backView = UIView(frame: tableView.bounds)
        backView.backgroundColor = Colors.dark
        self.tableView.backgroundView = backView
        
        tableView.backgroundView?.backgroundColor = Colors.dark
        tableView.tableHeaderView?.backgroundColor = Colors.dark
        
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = Colors.orange
        
    }
    
    fileprivate func setupSortButton() {
        let sortButton = UIBarButtonItem(image: UIImage(named:"sort_icon"), style: .plain, target: self, action: #selector(showSortActions))
        sortButton.imageInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 0)
        sortButton.tintColor = Colors.orange
        self.navigationItem.rightBarButtonItem = sortButton
    }
    
    @objc fileprivate func showSortActions() {
        let optionMenu = UIAlertController(title: nil, message: "Choose sorting option", preferredStyle: .actionSheet)
        optionMenu.view.tintColor = Colors.orange
        
        
        let subview = optionMenu.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        let items = alertContentView.subviews.first! as UIView
        items.backgroundColor = Colors.gray
        
        let bySongName = UIAlertAction(title: "Sor by song name", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.tracks = self.tracks.sorted(by: { ($0.value(forKey: "name") as! String) < ($1.value(forKey: "name") as! String) })
            self.tableView.reloadData()
        })
        
        let bySongArtist = UIAlertAction(title: "Sor by artist name", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.tracks = self.tracks.sorted(by: { ($0.value(forKey: "artist") as! String) < ($1.value(forKey: "artist") as! String) })
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(bySongName)
        optionMenu.addAction(bySongArtist)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
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
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredTracks = tracks.filter { track in
            let searchString = searchText.lowercased()
            return ((track.value(forKey: "name") as? String)!).lowercased().contains(searchString) ||
                   ((track.value(forKey: "artist") as? String)!).lowercased().contains(searchString)
        }
        
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

extension FavoriteListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredTracks.count
        } else {
            return tracks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteListCell", for: indexPath) as! FavoriteListTableCell
        let track: NSManagedObject
        
        if searchController.isActive && searchController.searchBar.text != "" {
            track = filteredTracks[indexPath.row]
        } else {
            track = tracks[indexPath.row]
        }

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
            if filteredTracks.count > 0 {
               filteredTracks.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .none)
        }
    }

}
