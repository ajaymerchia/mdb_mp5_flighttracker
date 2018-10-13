//
//  FavoritesViewController.swift
//  mdb_mp5_flighttracker
//
//  Created by Ajay Raj Merchia on 10/9/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import UIKit
import JGProgressHUD

class FavoritesViewController: UIViewController {

    var favoritesList: UITableView!
    var favorites: [Flight] = []
    var links: [String] = []
    
//    var initialized = false
    
    var alerts: AlertManager!
    var hud: JGProgressHUD!
    
    var selectedFlight:Flight?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        alertManager()
//        downloadFlights()
//        initialized = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if links != LocalData.getLocalDataAsArr(forKey: .favorites) {
            downloadFlights()
        }
        
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
