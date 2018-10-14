//
//  AirportInfo-control.swift
//  mdb_mp5_flighttracker
//
//  Created by Ajay Raj Merchia on 10/12/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import JGProgressHUD
import SwiftyJSON

extension AirportInfoViewController {
    func pullFlights() {
        guard let code = airport.airportCode else {
            return
        }
        
        let dateString = Utils.getYYYYMMDDRepr(date: Date.init(timeIntervalSinceNow: 0))
        
        LufthansaAPI.getArrivalsFromAirport(airportCode: code, airportLocation: airport.location!) { (json) in
            let flightsArray = json.arrayValue
            for flight in flightsArray {
            
                let flightNum = flight["OperatingCarrier"]["AirlineID"].stringValue + flight["OperatingCarrier"]["FlightNumber"].stringValue

                self.allFlights[1].append(Flight(json: flight, id: flightNum, date: dateString))
            }
            if self.raceConditionController == 0 {
                self.raceConditionController = 1
            } else {
                self.finishedLoading()
            }
        }
        
        LufthansaAPI.getDeparturesFromAirport(airportCode: code, airportLocation: airport.location!) { (json) in
            let flightsArray = json.arrayValue
            for flight in flightsArray {

                let flightNum = flight["OperatingCarrier"]["AirlineID"].stringValue + flight["OperatingCarrier"]["FlightNumber"].stringValue
                
                self.allFlights[0].append(Flight(json: flight, id: flightNum, date: dateString))
            }
            if self.raceConditionController == 0 {
                self.raceConditionController = 1
            } else {
                self.finishedLoading()
            }
        }
    }
    
    func finishedLoading() {
        hud?.dismiss()
        displayFlights.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.hud?.dismiss()
        if let index = selectedIndex {
            displayFlights.deselectRow(at: index, animated: true)
        }

        if let vc = segue.destination as? FlightInfoViewController {
            vc.FLIGHT = selectedFlight
        }
    }
    
}
