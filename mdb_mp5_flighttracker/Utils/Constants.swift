//
//  Constants.swift
//  mdb_mp5_flighttracker
//
//  Created by Ajay Raj Merchia on 10/10/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    // UI Elements
    static let PADDING:CGFloat = 30
    static let MARGINAL_PADDING:CGFloat = 10
    
    static let HEADER_FONT_SIZE: CGFloat = 40
    static let SUBTITLE_FONT_SIZE: CGFloat = 25
    static let HEADER_FONT = UIFont(name: "Avenir-Heavy", size: HEADER_FONT_SIZE)
    static let SUBTITLE_FONT = UIFont(name: "Avenir-Roman", size: SUBTITLE_FONT_SIZE)
    static let TEXT_FONT = UIFont(name: "Avenir-Roman", size: 16)
    
    static let CORPORATE_COLOR = rgba(10, 29, 61, 1)
    static let DEEP_BLUE = rgba(9, 83, 254, 1)
    // Credentials
    static let LUFTHANSA_CLIENTID = "vumfbzdjuw54tfspn7hc6k3f"
    static let LUFTHANSA_CLIENTSECRET = "B328YNetxf"
    
    // API Endpoint
    static let AUTH_ENDPOINT = "https://api.lufthansa.com/v1/oauth/token"
    static let FLIGHT_STATUS = "https://api.lufthansa.com/v1/operations/flightstatus"
    static let AIRPORT_DEETS = "https://api.lufthansa.com/v1/references/airports"
    static let AIRCRAFT_INFO = "https://api.lufthansa.com/v1/references/aircraft"
    static let ALL_AIRPORTS = "https://api.lufthansa.com/v1/references/airports/?lang=en&limit=100"
    static let ARRIVALS =  "https://api.lufthansa.com/v1/operations/flightstatus/arrivals"
    static let DEPARTURES =  "https://api.lufthansa.com/v1/operations/flightstatus/departures"
    
    static let defaultPlane:UIImage! = UIImage(named: "defaultPlane")
    
    static let AIRPLANE_LINKS: [String: String] = [
        "Boeing 747-8" : "https://www.lufthansagroup.com/fileadmin/data/images/unternehmen/flotte/lufthansa/LH_B748_l_ws.png",
        "Boeing 747-400" : "https://www.lufthansagroup.com/fileadmin/data/images/unternehmen/flotte/lufthansa/LH_B744_l_ws.png",
        "Airbus A340-600" : "https://www.lufthansagroup.com/fileadmin/data/images/unternehmen/flotte/lufthansa/LH_A346_l_ws.png",
        "Airbus A350-900" : "https://www.lufthansagroup.com/fileadmin/data/images/unternehmen/flotte/lufthansa/LH_A359_l_ws.png",
        "Airbus A340-300" : "https://www.lufthansagroup.com/fileadmin/data/images/unternehmen/flotte/lufthansa/LH_A343_l_ws.png",
        "Airbus A330-300" : "https://www.lufthansagroup.com/fileadmin/data/images/unternehmen/flotte/lufthansa/LH_A333_l_ws.png",
        "Airbus A321-100/200" : "https://www.lufthansagroup.com/fileadmin/data/images/unternehmen/flotte/lufthansa/LH_A321-200_l_D-AIDV_ws.png",
        "Airbus A320neo" : "https://www.lufthansagroup.com/fileadmin/data/images/unternehmen/flotte/lufthansa/LH_A320neo_l_ws.png",
        "Airbus A320-200" : "https://www.lufthansagroup.com/fileadmin/data/images/unternehmen/flotte/lufthansa/LH_A320_l_ws.png",
        "Airbus A319-100" : "https://www.lufthansagroup.com/fileadmin/data/images/unternehmen/flotte/lufthansa/LH_A319_l_ws.png",
        "Embraer 195" : "https://www.lufthansagroup.com/fileadmin/data/images/unternehmen/flotte/lufthansa/LHC_ERJ195_l_ws.png",
        "Embraer 190" : "https://www.lufthansagroup.com/fileadmin/data/images/unternehmen/flotte/lufthansa/LHC_ERJ190_l_ws.png",
        "Bombardier CR900" : "https://www.lufthansagroup.com/fileadmin/data/images/unternehmen/flotte/lufthansa/LHC_CRJ900_l_ws.png"
        ]
    
}
