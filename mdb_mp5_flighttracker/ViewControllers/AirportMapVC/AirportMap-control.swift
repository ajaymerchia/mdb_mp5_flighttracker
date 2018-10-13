//
//  AirportMap-control.swift
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

extension AirportMapViewController {
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        hud?.dismiss()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        hud?.dismiss()
        
    }
    
    func setUpAlertManager() {
        alerts = AlertManager(view: self, stateRestoration: {
            self.hud?.dismiss()
            self.additionalPorts.isUserInteractionEnabled = true
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AirportInfoViewController {
            vc.airport = ((sender as! MKPinAnnotationView).annotation as! MKPointAnnotationWithAirport).airport
        }
        
    }
    
    
}
