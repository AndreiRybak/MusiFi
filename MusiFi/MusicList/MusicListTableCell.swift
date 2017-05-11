//
//  MusicListTableCell.swift
//  MusiFi
//
//  Created by Andrei Rybak on 3/27/17.
//  Copyright © 2017 Andrei Rybak. All rights reserved.
//

import UIKit
import WCLShineButton

class MusicListTableCell: UITableViewCell {
    
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    @IBOutlet weak var likeView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = Colors.dark
        self.contentView.backgroundColor = Colors.dark
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = Colors.orange
        self.selectedBackgroundView = bgColorView
        
        addLikeButton()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    fileprivate func addLikeButton() {
        var params = WCLShineParams()
        params.bigShineColor = UIColor(red: 255/255, green: 97/255, blue: 0/255, alpha: 1)
        params.smallShineColor = UIColor(red: 239/255, green: 142/255, blue: 45/255, alpha: 1)
        
        let likeButton = WCLShineButton(frame: .init(x: 5, y: 5, width: 30, height: 30), params: params)
        
        likeButton.fillColor = UIColor(red: 219/255, green: 87/255, blue: 90/255, alpha: 1)
        likeButton.color = UIColor.white
        likeView.addSubview(likeButton)
        
        //TODO: ADD ACTION FOR SAVE IN CORE DATA
        //bt1.addTarget(self, action: #selector(action), for: .touchUpInside)
    }
    
}
