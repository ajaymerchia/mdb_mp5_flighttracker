//
//  AirportInfoViewController.swift
//  mdb_mp5_flighttracker
//
//  Created by Ajay Raj Merchia on 10/9/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import JGProgressHUD

class AirportInfoViewController: UIViewController {

    var airport: Airport!
    
    var mapView: MKMapView!
    var alerts: AlertManager!
    var hud: JGProgressHUD!
    var selectedFlight: Flight?
    
    var segmentedControl: UISegmentedControl!
    
    var raceConditionController = 0
    
    var allFlights:[[Flight]] = [[],[]]
    
    var selectedIndex: IndexPath?

    
    var displayFlights: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alerts = AlertManager(view: self, stateRestoration: {
            self.hud?.dismiss()
        })
        initUI()
        hud = Utils.startProgressHud(inView: view, withMsg: "Loading Flights")

        pullFlights()
        // Do any additional setup after loading the view.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
