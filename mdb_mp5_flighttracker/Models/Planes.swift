//
//  Planes.swift
//  mdb_mp5_flighttracker
//
//  Created by Ajay Raj Merchia on 10/10/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import Foundation
import UIKit
class Plane {
    var identifier: String!
    var image: UIImage!
    
    init(name: String) {
        identifier = name
    }
    
    init(name: String, img: UIImage) {
        identifier = name
        image = img
    }
    
    
    
    
}
