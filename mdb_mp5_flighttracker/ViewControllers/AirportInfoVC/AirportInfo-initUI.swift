//
//  AirportInfo-initUI.swift
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

extension AirportInfoViewController {
    func initUI() {
        initNav()
        initMap()
        initSwitch()
        initTableView()
    }
    func initNav() {
        self.title = airport.fullname!
    }
    func initMap() {
        mapView = MKMapView(frame: CGRect(x: 0, y: (navigationController?.navigationBar.frame.maxY)!, width: view.frame.width, height: view.frame.height/3))
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = (airport.location?.coordinate)!
        annotation.title = airport.fullname
        annotation.subtitle = airport.airportCode
        mapView.addAnnotation(annotation)
        view.addSubview(mapView)
        
        mapView.setRegion(MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    func initSwitch() {
        segmentedControl = UISegmentedControl(frame: LayoutManager.belowCentered(elementAbove: mapView, padding: 0, width: view.frame.width, height: 40))
        segmentedControl.insertSegment(withTitle: "Departures", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Arrivals", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = .flatSkyBlue
        segmentedControl.addTarget(self, action: #selector(switchLayout), for: .valueChanged)
        
        view.addSubview(segmentedControl)
    }
    
    func initTableView() {
        displayFlights = UITableView(frame: LayoutManager.belowCentered(elementAbove: segmentedControl, padding: 0, width: view.frame.width, height: (tabBarController?.tabBar.frame.minY)! - segmentedControl.frame.maxY))
        displayFlights.register(FlightCell.self, forCellReuseIdentifier: "flightcell")
        displayFlights.delegate = self
        displayFlights.dataSource = self
        displayFlights.rowHeight = 80
        displayFlights.backgroundColor = .flatWhite
        displayFlights.showsVerticalScrollIndicator = false
        view.addSubview(displayFlights)
    }
    
    @objc func switchLayout() {
        displayFlights.reloadData()
    }
}
