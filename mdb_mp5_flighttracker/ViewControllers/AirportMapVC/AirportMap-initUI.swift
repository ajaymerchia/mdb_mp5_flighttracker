//
//  AirportMap-initUI.swift
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

extension AirportMapViewController: MKMapViewDelegate {
    func initUI() {
        
        buildMapView()
        additionalPortsButton()
        addAirports()
    }
    
    func buildMapView() {
        mapView = MKMapView(frame: view.frame)
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 54.5260, longitude: 15.2551)
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    @objc func addAirports() {
        hud = Utils.startProgressHud(inView: view, withMsg: "Loading Airports")
        additionalPorts.isUserInteractionEnabled = false
        LufthansaAPI.getAllAirports { (response) in
            if response == JSON.null {
                self.alerts.displayAlert(title: "Sorry!", message: "No more airports to display.")
                return
            }
            
            let allAirports = response.arrayValue
            for airport in allAirports {
                self.extractAirport(airportJSON: airport, callback: { currAirport in
                    self.airports.append(currAirport)
                    self.addAirportToMap(airport: currAirport)
                })
            }
            self.hud?.dismiss()
            self.additionalPorts.isUserInteractionEnabled = true
        }
    }
    
    func extractAirport(airportJSON: JSON, callback: @escaping (Airport) -> ()) {
        let code = airportJSON["AirportCode"].stringValue
        let name = airportJSON["Names"]["Name"]["$"].stringValue
        let lat = airportJSON["Position"]["Coordinate"]["Latitude"].floatValue
        let lon = airportJSON["Position"]["Coordinate"]["Longitude"].floatValue
        
        callback(Airport(location: CLLocation(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon)), name: name, code: code))
        
    }
    func addAirportToMap(airport: Airport) {
        let annotation = MKPointAnnotationWithAirport(airport: airport)
        
        annotation.coordinate = (airport.location?.coordinate)!
        annotation.title = "\(airport.airportCode!)"
        annotation.subtitle = "\(airport.fullname!)"
        
    
        mapView.addAnnotation(annotation)
    }
    
    func additionalPortsButton() {
        let buttonWidth:CGFloat = 150
        additionalPorts = UIButton(frame: CGRect(x: view.frame.width - (buttonWidth + Constants.PADDING), y: Constants.PADDING, width: buttonWidth, height: 40))
        additionalPorts.setBackgroundColor(color: .white, forState: .normal)
        additionalPorts.setTitle("More Airports", for: .normal)
        additionalPorts.addTarget(self, action: #selector(addAirports), for: .touchUpInside)
        additionalPorts.setTitleColor(UIColor.flatSkyBlue, for: .normal)
        additionalPorts.layer.cornerRadius = 5
        additionalPorts.clipsToBounds = true
        view.addSubview(additionalPorts)
    }
    
    
    
    
    
}
