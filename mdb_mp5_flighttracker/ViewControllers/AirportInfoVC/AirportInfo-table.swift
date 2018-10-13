//
//  AirportInfo-table.swift
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

extension AirportInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFlights[segmentedControl.selectedSegmentIndex].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flightcell") as! FlightCell
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        let currList = allFlights[segmentedControl.selectedSegmentIndex]
        
        // Initialize Cell
        cell.awakeFromNib()
        cell.initializeCellFrom(flight: currList[indexPath.row], state: segmentedControl.selectedSegmentIndex, expectedWidth: view.frame.width)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        
        selectedFlight = allFlights[segmentedControl.selectedSegmentIndex][indexPath.row]
        hud = Utils.startProgressHud(inView: view, withMsg: "Loading Details")
        selectedFlight?.arrivingAirport.computeDetails {
            self.selectedFlight?.departingAirport.computeDetails {
                guard let planeCode = self.selectedFlight?.planeType.identifier else {
                    self.selectedFlight?.planeType = Plane(name: "Unknown", img: Constants.defaultPlane)
                    self.performSegue(withIdentifier: "airport2flight", sender: self)
                    return
                }
                
                LufthansaAPI.getAircraftDetails(code: planeCode, callback: { (craftDetails) in
                    
                    let planeName = craftDetails["AircraftSummary"]["Names"]["Name"]["$"].stringValue
                    let planeSerial = craftDetails["AircraftSummary"]["AirlineEquipCode"].stringValue
                    
                    for serials in Constants.AIRPLANE_LINKS.keys {
                        if serials.lowercased().contains(planeSerial.lowercased()) {
                            debugPrint("found a URL")
                            debugPrint(Constants.AIRPLANE_LINKS[serials])
                            Utils.getImageFrom(url: Constants.AIRPLANE_LINKS[serials]!, defaultImg: Constants.defaultPlane, callback: { (planeImage) in
                                
                                self.selectedFlight?.planeType = Plane(name: planeName, img: planeImage)
                                self.performSegue(withIdentifier: "airport2flight", sender: self)
                            })
                            return
                        }
                    }
                    
                    self.selectedFlight?.planeType = Plane(name: planeName, img: Constants.defaultPlane)
                    self.performSegue(withIdentifier: "airport2flight", sender: self)
                    
                    
                })
                
            }
        }
    }
    
    
}
