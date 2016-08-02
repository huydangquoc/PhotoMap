//
//  PhotoAnnotation.swift
//  Photo Map
//
//  Created by Dang Quoc Huy on 8/2/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var photo: UIImage!
    var title: String?
}
