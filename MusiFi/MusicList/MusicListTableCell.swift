//
//  MusicListTableCell.swift
//  MusiFi
//
//  Created by Andrei Rybak on 3/27/17.
//  Copyright © 2017 Andrei Rybak. All rights reserved.
//

import UIKit
import WCLShineButton
import CoreData

class MusicListTableCell: UITableViewCell {
    
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    @IBOutlet weak var likeView: UIView!
    var likeButton: WCLShineButton? = nil
    
    var tracks: [NSManagedObject] = []
    
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
        
        likeButton = WCLShineButton(frame: .init(x: 5, y: 5, width: 30, height: 30), params: params)
        likeButton?.addTarget(self, action: #selector(likeButtonPressed(sender:)), for: .touchUpInside)
        
        likeButton?.fillColor = UIColor(red: 219/255, green: 87/255, blue: 90/255, alpha: 1)
        likeButton?.color = UIColor.white

        likeView.addSubview(likeButton!)
    }
    
    @objc fileprivate func likeButtonPressed(sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        if isCurrentlyAdded() == false {
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "FavoriteTrack", in: managedContext)!
            
            let track = NSManagedObject(entity: entity, insertInto: managedContext)
            
            let imageData: Data = UIImagePNGRepresentation(self.trackImage.image!)!
            let imageBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            
            track.setValue(imageBase64, forKey: "image")
            track.setValue(self.trackNameLabel.text, forKey: "name")
            track.setValue(self.authorLabel.text, forKey: "artist")
        
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    fileprivate func isCurrentlyAdded() -> Bool {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return true }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        var currentTracks: [NSManagedObject] = []
        
        let namePredicate = NSPredicate(format:"name == %@", trackNameLabel.text!)
        let artistPredicate = NSPredicate(format:"artist == %@", authorLabel.text!)
        
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
