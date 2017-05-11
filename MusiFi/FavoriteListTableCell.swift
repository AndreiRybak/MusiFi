//
//  FavoriteListTableCell.swift
//  MusiFi
//
//  Created by Andrei Rybak on 5/11/17.
//  Copyright © 2017 Andrei Rybak. All rights reserved.
//

import UIKit

class FavoriteListTableCell: UITableViewCell {

    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = Colors.dark
        self.contentView.backgroundColor = Colors.dark
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = Colors.orange
        self.selectedBackgroundView = bgColorView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
