//
//  FavoriteListViewController.swift
//  MusiFi
//
//  Created by Andrei Rybak on 5/11/17.
//  Copyright © 2017 Andrei Rybak. All rights reserved.
//

import UIKit

class FavoriteListViewController: UIViewController {

    fileprivate struct NibName {
        static let cellNibName = "FavoriteListTableCell"
        static let cellReuseIdentifier = "favoriteListCell"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib.init(nibName: NibName.cellNibName, bundle: nil), forCellReuseIdentifier: NibName.cellReuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 90.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.backBarButtonItem?.tintColor = Colors.orange
        self.navigationController?.navigationBar.tintColor = Colors.orange
 
    }
}

//TODO: DELETE ROWS WHEN CORE DATA WILL BE IMPLEMENTED

extension FavoriteListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteListCell", for: indexPath) as! FavoriteListTableCell
        //TODO: CONFIGURE CELL
        cell.imageView?.image = UIImage(named: "default_placeholder")
        return cell
    }

}
