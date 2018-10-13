//
//  AirportMapViewController.swift
//  mdb_mp5_flighttracker
//
//  Created by Ajay Raj Merchia on 10/9/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import JGProgressHUD

class AirportMapViewController: UIViewController {

    var mapView:MKMapView!
    var hud: JGProgressHUD?
    var airports: [Airport] = []
    var additionalPorts:UIButton!
    var alerts: AlertManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAlertManager()
        initUI()
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
