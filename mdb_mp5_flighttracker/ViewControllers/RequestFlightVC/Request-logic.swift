//
//  Request-logic.swift
//  mdb_mp5_flighttracker
//
//  Created by Ajay Raj Merchia on 10/10/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

extension RequestFlightViewController {
    func ensureFavorites() {
        guard let _ = LocalData.getLocalDataAsArr(forKey: .favorites) else {
            LocalData.putLocalData(forKey: .favorites, data: [])
            return
        }
    }
    
    @objc func searchFlights(sender: UIButton) {
        sender.isUserInteractionEnabled = false
        hud = Utils.startProgressHud(inView: self.view, withMsg: "Searching for Flight")
        
        
        // Parse the Flight Number
        guard var flightNum = flightNumberEntry.text else {
            alerts.displayAlert(title: "Oops", message: "Please check your flight number.")
            return
        }
        flightNum = flightNum.uppercased()
        if !flightNum.starts(with: "LH") {
            alerts.displayAlert(title: "Oops", message: "Please check your flight number. Remember, all flights must start with code 'LH'.")
            return
        }

        // Parse the Date given
        if flightDatePicker.date.timeIntervalSinceNow > 60*60*24*6 {
            alerts.displayAlert(title: "Sorry!", message: "We can not find flights a week in advance. Please change the date.")
            return
        }
        
        let dateString = Utils.getYYYYMMDDRepr(date: flightDatePicker.date)
        
        LufthansaAPI.getFlightDetails(id: flightNum, date: dateString) { (flightRecord) in
            debugPrint(flightRecord)
            if flightRecord == JSON.null {
                self.alerts.displayAlert(title: "Sorry!", message: "We couldn't find that flight.")
                return
            }
            self.selectedFlight = Flight(json: flightRecord, id: flightNum, date: dateString)
            
            self.selectedFlight?.departingAirport?.computeDetails(callback: {
                self.selectedFlight?.arrivingAirport?.computeDetails(callback: {
                    
                    guard let planeCode = self.selectedFlight?.planeType.identifier else {
                        self.selectedFlight?.planeType = Plane(name: "Unknown", img: Constants.defaultPlane)
                        
                        self.performSegue(withIdentifier: "search2flight", sender: self)
                        return
                    }
                    
                    LufthansaAPI.getAircraftDetails(code: planeCode, callback: { (craftDetails) in
                        
                        debugPrint(craftDetails)
                        let planeName = craftDetails["AircraftSummary"]["Names"]["Name"]["$"].stringValue
                        let planeSerial = craftDetails["AircraftSummary"]["AirlineEquipCode"].stringValue
                        debugPrint(planeName)
                        debugPrint(planeSerial)
                        
                        for serials in Constants.AIRPLANE_LINKS.keys {
                            if serials.lowercased().contains(planeSerial.lowercased()) {
                                debugPrint("found a URL")
                                debugPrint(Constants.AIRPLANE_LINKS[serials])
                                Utils.getImageFrom(url: Constants.AIRPLANE_LINKS[serials]!, defaultImg: Constants.defaultPlane, callback: { (planeImage) in
                                    
                                    self.selectedFlight?.planeType = Plane(name: planeName, img: planeImage)
                                    self.performSegue(withIdentifier: "search2flight", sender: self)
                                })
                                return
                            }
                        }
                        self.selectedFlight?.planeType = Plane(name: planeName, img: Constants.defaultPlane)
                        self.performSegue(withIdentifier: "search2flight", sender: self)
                        
                        

                    })
                })
            })
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FlightInfoViewController {
            guard let flight = selectedFlight else {
                return
            }
            vc.FLIGHT = flight
        }
    }
    
}
