//
//  MusicListViewController.swift
//  MusiFi
//
//  Created by Andrei Rybak on 3/27/17.
//  Copyright © 2017 Andrei Rybak. All rights reserved.
//

import UIKit

class MusicListViewController: UIViewController, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!

    struct Constants {
        static let cellNibName = "MusicListTableCell"
        static let cellReuseIdentifier = "musicListCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
        
        tableView.register(UINib.init(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellReuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 90.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //TODO: REQUEST FOR ITEMS
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicListCell", for: indexPath)
        //TODO: CONFIGURE CELL
        cell.imageView?.image = UIImage(named: "default_placeholder")
        return cell
    }
    
}
