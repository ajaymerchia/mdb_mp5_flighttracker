//
//  FlightInfoViewController.swift
//  mdb_mp5_flighttracker
//
//  Created by Ajay Raj Merchia on 10/9/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import UIKit
import MapKit

class FlightInfoViewController: UIViewController {

    var FLIGHT: Flight!
    var mapView: MKMapView!
    
    var heightOfPane:CGFloat!
    
    var pane: UIView!
    var flightStatus: UILabel!
    var flightNumber: UILabel!
    
    var timingPane: UIView!
    
    var bigDepart: UILabel!
    var smallDepart: UILabel?
    var bigArrive: UILabel!
    var smallArrive: UILabel?
    
    var srcAirportCode: UILabel!
    var desAirportCode: UILabel!
    var airportArrow: UIImageView!
    
    var plane: UIImageView!
    var planeName: UILabel!
    
    var departTermGate: UILabel!
    var arriveTermGate: UILabel!
    
    var animationDistance:CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heightOfPane = view.frame.height/1.5
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
