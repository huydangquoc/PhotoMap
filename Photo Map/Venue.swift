//
//  Venue.swift
//  Photo Map
//
//  Created by Dang Quoc Huy on 8/2/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import Foundation

class Venue {
    
    var name: String?
    var latitude: NSNumber?
    var longtitude: NSNumber?
    var rawData: NSDictionary?
    
    init(dictionary: NSDictionary) {
        
        rawData = dictionary
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        if let latitude = dictionary.valueForKeyPath("location.lat") as? NSNumber {
            self.latitude = latitude
        }
        if let longtitude = dictionary.valueForKeyPath("location.lng") as? NSNumber {
            self.longtitude = longtitude
        }
    }
}
