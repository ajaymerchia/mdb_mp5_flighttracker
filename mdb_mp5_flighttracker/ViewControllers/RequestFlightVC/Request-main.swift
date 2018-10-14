//
//  RequestViewController.swift
//  mdb_mp5_flighttracker
//
//  Created by Ajay Raj Merchia on 10/9/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import UIKit
import JGProgressHUD

class RequestFlightViewController: UIViewController {

    // Header
    var headerImage: UIImageView!
    var headerText: UILabel!
    var subtitle: UILabel!
    
    // Request Entry Processing
    var flightNumberEntry: UITextField!
    var flightDatePicker: UIDatePicker!
    var flightRequestTrigger: UIButton!
    
    // UI Constants
    let INTERNAL_PADDING:CGFloat = 100
    var OUTER_BOX_WIDTH:CGFloat!
    var INNER_BOX_WIDTH:CGFloat!
    
    // UI Elements
    var hud:JGProgressHUD?
    
    // Logic
    var alerts:AlertManager!
    var selectedFlight: Flight?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ensureFavorites()
        calculateConstants()
        setUpManagers()
        initUI()
        
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
