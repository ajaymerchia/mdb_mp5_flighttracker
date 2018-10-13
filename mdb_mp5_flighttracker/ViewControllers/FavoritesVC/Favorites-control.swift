//
//  Favorites-control.swift
//  mdb_mp5_flighttracker
//
//  Created by Ajay Raj Merchia on 10/12/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import JGProgressHUD

extension FavoritesViewController {
    func alertManager() {
        alerts = AlertManager.init(view: self, stateRestoration: {
            self.hud?.dismiss()
        })
    }
    
    func downloadFlights() {
        hud = Utils.startProgressHud(inView: view, withMsg: "Loading Favorites. This may take a while.")
        favorites = []
        selectedFlight = nil
        
        links = LocalData.getLocalDataAsArr(forKey: .favorites)!
        
        if links.count == 0 {
            hud.dismiss()
            alerts.displayAlert(title: "Oops", message: "You have no favorited flights")
            return
        }
        
        for link in links {
            downloadAndAdd(link: link)
            sleep(1)
        }
    }
    
    func downloadAndAdd(link: String) {
        LufthansaAPI.getFlightDetails(url: link) { (flightRecord) in
            debugPrint(flightRecord)
            if flightRecord == JSON.null {
                self.alerts.displayAlert(title: "Sorry!", message: "We couldn't find that flight.")
                return
            }
            let flightNum = flightRecord["OperatingCarrier"]["AirlineID"].stringValue + flightRecord["OperatingCarrier"]["FlightNumber"].stringValue
            
            let thisFlight = Flight(json: flightRecord, id: flightNum, date: "testdate")
            
            thisFlight.dateString = Utils.getYYYYMMDDRepr(date: thisFlight.departScheduled)

            thisFlight.departingAirport?.computeDetails(callback: {
                thisFlight.arrivingAirport?.computeDetails(callback: {
                    
                    guard let planeCode = thisFlight.planeType.identifier else {
                        thisFlight.planeType = Plane(name: "Unknown", img: Constants.defaultPlane)
                        self.finishLoading(thisFlight, removableLink: link)
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
                                    
                                    thisFlight.planeType = Plane(name: planeName, img: planeImage)
                                    self.finishLoading(thisFlight, removableLink: link)
                                    
                                    
                                })
                                return
                            }
                        }
                        thisFlight.planeType = Plane(name: planeName, img: Constants.defaultPlane)
                        self.finishLoading(thisFlight, removableLink: link)
                        
                    })
                })
        })
        }
    }
    
    func finishLoading(_ flight: Flight, removableLink: String) {
        
        if flight.departScheduled.timeIntervalSince1970 < Date.init(timeIntervalSinceNow: 0).timeIntervalSince1970 {
            links.remove(at: links.index(of: removableLink)!)
            LocalData.putLocalData(forKey: .favorites, data: links)
        } else {
            favorites.append(flight)

        }
        hud.dismiss()

        if favorites.count == links.count {
            favorites.sort()
            self.favoritesList.reloadData()
            hud.dismiss()
            
            if favorites.count == 0 {
                alerts.displayAlert(title: "Oops", message: "You have no favorited flights")

            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FlightInfoViewController {
            vc.FLIGHT = selectedFlight
        }
    }
}
