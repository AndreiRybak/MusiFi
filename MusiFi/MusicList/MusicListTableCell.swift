//
//  MusicListTableCell.swift
//  MusiFi
//
//  Created by Andrei Rybak on 3/27/17.
//  Copyright © 2017 Andrei Rybak. All rights reserved.
//

import UIKit

class MusicListTableCell: UITableViewCell {
    
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
        self.contentView.backgroundColor = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 251/255, green: 155/255, blue: 51/255, alpha: 0.9)
        self.selectedBackgroundView = bgColorView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
