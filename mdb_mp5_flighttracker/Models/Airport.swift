//
//  Airport.swift
//  mdb_mp5_flighttracker
//
//  Created by Ajay Raj Merchia on 10/9/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import Foundation
import CoreLocation

class Airport {
    var airportCode: String!
    var location: CLLocation?
    var fullname: String?
    
    init(airportCode: String) {
        self.airportCode = airportCode
    }
    
    init(location: CLLocation, name: String, code: String) {
        self.airportCode = code
        self.location = location
        self.fullname = name
    }
    
    func computeDetails(callback: @escaping (() -> ())) {
        // use api helper to touch endpoint and come back
        LufthansaAPI.getAirportDetails(id: airportCode) { (json) in
            let lat = json["Position"]["Coordinate"]["Latitude"].floatValue
            let lon = json["Position"]["Coordinate"]["Longitude"].floatValue
            self.location = CLLocation(latitude: CLLocationDegrees(exactly: lat)!, longitude: CLLocationDegrees(exactly: lon)!)
            
            self.fullname = json["Names"]["Name"].arrayValue[1]["$"].stringValue
            callback()
            
        }
    }
}
