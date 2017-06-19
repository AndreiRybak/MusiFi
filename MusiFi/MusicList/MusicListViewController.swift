//
//  MusicListViewController.swift
//  MusiFi
//
//  Created by Andrei Rybak on 3/27/17.
//  Copyright © 2017 Andrei Rybak. All rights reserved.
//

import UIKit
import CoreData

class MusicListViewController: UIViewController, UITableViewDelegate, UISearchResultsUpdating, UIActionSheetDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var tracks: Array<Track> = []
    fileprivate var filteredTracks: Array<Track> = []
    
    let searchController = UISearchController(searchResultsController: nil)

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
        self.navigationItem.leftBarButtonItem = sortButton
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
            self.tracks = self.tracks.sorted(by: { $0.name < $1.name })
            self.tableView.reloadData()
        })
        
        let bySongArtist = UIAlertAction(title: "Sor by artist name", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.tracks = self.tracks.sorted(by: { $0.artist < $1.artist })
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
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredTracks = tracks.filter { track in
            let searchString = searchText.lowercased()
            return track.name.lowercased().contains(searchString) ||
                    track.artist.lowercased().contains(searchString)
        }
        
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

extension MusicListViewController: UITableViewDataSource {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicListCell", for: indexPath) as! MusicListTableCell
        let track: Track
        
        if searchController.isActive && searchController.searchBar.text != "" {
            track = filteredTracks[indexPath.row]
        } else {
            track = tracks[indexPath.row]
        }
        
        let dataDecoded : Data = Data(base64Encoded: track.image!, options: .ignoreUnknownCharacters)!
        if let image = UIImage(data: dataDecoded) {
            cell.trackImage?.image = image
        } else {
            cell.trackImage?.image = UIImage(named: "default_placeholder")
        }
        
        cell.authorLabel.text = track.artist
        cell.trackNameLabel.text = track.name
        
        if isCurrentlyAdded(name: track.name, artist: track.artist) == true {
            cell.likeButton?.isSelected = true
        } else {
            cell.likeButton?.isSelected = false

        }
        
        return cell
    }
    
    fileprivate func isCurrentlyAdded(name: String, artist: String) -> Bool {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return true }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        var currentTracks: [NSManagedObject] = []
        
        let namePredicate = NSPredicate(format:"name == %@", name)
        let artistPredicate = NSPredicate(format:"artist == %@", artist)
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteTrack")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [namePredicate, artistPredicate])
        
        fetchRequest.predicate = compoundPredicate
        
        do {
            currentTracks = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        return currentTracks.count == 0 ? false : true
    }
    
}
