//
//  Track+CoreDataClass.swift
//  
//
//  Created by Andrei Rybak on 5/11/17.
//
//

import Foundation
import CoreData

@objc(Track)
public class Track: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Track> {
        return NSFetchRequest<Track>(entityName: "Track")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var image: NSData?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var artist: String?
}
